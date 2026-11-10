import '../../domain/models/categoria.dart';
import '../../domain/models/historico_local.dart';
import '../../domain/models/objeto_detalhe.dart';
import '../services/cade_database.dart' hide HistoricoLocal;
import '../services/midia_service.dart';
import 'categoria_repository.dart';
import 'mappers.dart';

class ObjetoRepository {
  ObjetoRepository({
    required this._banco,
    required this._categorias,
    required this._midia,
  });

  final CadeDatabase _banco;
  final CategoriaRepository _categorias;
  final MidiaService _midia;

  // ---------------------------------------------------------------
  // Registrar (US01 a US04)
  // ---------------------------------------------------------------

  /// Registra um objeto. Os caminhos de mídia são RELATIVOS, como devolvidos
  /// pelo MidiaService. Se falhar, as mídias não são apagadas: o ViewModel
  /// ainda as tem e o usuário pode tentar de novo.
  Future<int> registrar({
    required String nome,
    required String nomeLocal,
    String? fotoPath,
    String? fotoLocalPath,
    String? audioPath,
    String? descricao,
    int? categoriaId,
    int tamanhoBytes = 0,
    List<String> fotosExtras = const [],
  }) {
    if (nome.trim().isEmpty || nomeLocal.trim().isEmpty) {
      throw ArgumentError('Nome e local são obrigatórios.');
    }
    return _banco.registrarObjeto(
      nome: nome,
      nomeLocal: nomeLocal,
      fotoPath: fotoPath,
      fotoLocalPath: fotoLocalPath,
      audioPath: audioPath,
      descricao: descricao,
      categoriaId: categoriaId,
      tamanhoBytes: tamanhoBytes,
      fotosExtras: fotosExtras,
    );
  }

  Future<void> atualizar({
    required int id,
    required String nome,
    required String nomeLocal,
    String? fotoPath,
    String? fotoLocalPath,
    String? audioPath,
    String? descricao,
    int? categoriaId,
    int tamanhoBytes = 0,
    List<String>? fotosExtras,
  }) async {
    if (nome.trim().isEmpty || nomeLocal.trim().isEmpty) {
      throw ArgumentError('Nome e local são obrigatórios.');
    }
    final anterior = await _banco.obterObjeto(id);
    if (anterior == null) throw StateError('Objeto não encontrado.');
    final fotosAnteriores = await _banco.listarFotosExtras(id);
    await _banco.atualizarObjeto(
      objetoId: id,
      nome: nome,
      nomeLocal: nomeLocal,
      fotoPath: fotoPath,
      fotoLocalPath: fotoLocalPath,
      audioPath: audioPath,
      descricao: descricao,
      categoriaId: categoriaId,
      tamanhoBytes: tamanhoBytes,
      fotosExtras: fotosExtras,
    );
    // Só remove a mídia antiga depois que a atualização foi persistida.
    if (anterior.objeto.fotoPath != fotoPath) {
      await _midia.apagar(anterior.objeto.fotoPath);
    }
    if (anterior.objeto.audioPath != audioPath) {
      await _midia.apagar(anterior.objeto.audioPath);
    }
    if (fotosExtras != null) {
      for (final caminho in fotosAnteriores) {
        if (!fotosExtras.contains(caminho) && caminho != fotoPath) {
          await _midia.apagar(caminho);
        }
      }
    }
  }

  // ---------------------------------------------------------------
  // Encontrar (US05, US06)
  // ---------------------------------------------------------------

  /// Busca por texto, com filtros opcionais de local e categoria.
  /// Termo vazio devolve todos os objetos, do mais recente ao mais antigo.
  ///
  /// Os filtros são aplicados em memória: para um app de uso pessoal a lista
  /// é pequena. Se crescer, mova o filtro para uma consulta no CadeDatabase.
  Future<List<ObjetoDetalhe>> buscar(
    String termo, {
    int? localId,
    int? categoriaId,
  }) async {
    final linhas = await _banco.buscarObjetos(termo);
    final categorias = await _mapaDeCategorias();

    return linhas
        .where((l) => localId == null || l.objeto.localId == localId)
        .where(
          (l) => categoriaId == null || l.objeto.categoriaId == categoriaId,
        )
        .map(
          (l) => ObjetoDetalhe(
            objeto: l.objeto.paraModel(),
            local: l.local.paraModel(),
            categoria: categorias[l.objeto.categoriaId],
          ),
        )
        .toList();
  }

  // ---------------------------------------------------------------
  // Consultar (US07)
  // ---------------------------------------------------------------

  Future<ObjetoDetalhe?> obter(int id) async {
    final linha = await _banco.obterObjeto(id);
    if (linha == null) return null;

    final categorias = await _mapaDeCategorias();
    return ObjetoDetalhe(
      objeto: linha.objeto.paraModel(),
      local: linha.local.paraModel(),
      categoria: categorias[linha.objeto.categoriaId],
      fotosExtras: await _banco.listarFotosExtras(id),
    );
  }

  // ---------------------------------------------------------------
  // Manter (US09, US10, US11)
  // ---------------------------------------------------------------

  /// US09: muda o local (criando-o se for novo) e renova a confirmação.
  /// Passar o mesmo local do objeto só renova a confirmação (US11).
  Future<void> mover(int objetoId, String novoLocal) {
    if (novoLocal.trim().isEmpty) {
      throw ArgumentError('Informe o novo local.');
    }
    return _banco.moverObjeto(objetoId, novoLocal);
  }

  Future<List<HistoricoLocal>> historicoDoObjeto(int objetoId) async {
    final registros = await _banco.historicoDoObjeto(objetoId);
    if (registros.isEmpty) return const [];

    final locais = {
      for (final local in await _banco.listarLocais()) local.id: local,
    };
    return registros.map((registro) {
      final localAntigo = registro.localAntigoId == null
          ? '—'
          : (locais[registro.localAntigoId]?.nome ?? 'Local removido');
      final localNovo = locais[registro.localNovoId]?.nome ?? 'Local removido';

      return HistoricoLocal(
        id: registro.id,
        objetoId: registro.objetoId,
        localAntigo: localAntigo,
        localNovo: localNovo,
        alteradoEm: registro.alteradoEm,
      );
    }).toList();
  }

  /// Exclui o registro e suas mídias. A foto compartilhada do local é mantida.
  Future<void> excluir(int id) async {
    final fotosExtras = await _banco.listarFotosExtras(id);
    final removido = await _banco.excluirObjeto(id);
    if (removido == null) return;
    await _midia.apagar(removido.fotoPath);
    await _midia.apagar(removido.audioPath);
    for (final caminho in fotosExtras) {
      await _midia.apagar(caminho);
    }
  }

  /// US11: objetos sem confirmação há mais de [meses] meses.
  Future<List<ObjetoDetalhe>> listarAntigos({int meses = 11}) async {
    final antigos = await _banco.objetosAntigos(meses: meses);
    if (antigos.isEmpty) return [];

    final locais = {for (final l in await _banco.listarLocais()) l.id: l};
    final categorias = await _mapaDeCategorias();

    final resultado = <ObjetoDetalhe>[];
    for (final o in antigos) {
      final local = locais[o.localId];
      if (local == null) continue;
      resultado.add(
        ObjetoDetalhe(
          objeto: o.paraModel(),
          local: local.paraModel(),
          categoria: categorias[o.categoriaId],
        ),
      );
    }
    return resultado;
  }

  // ---------------------------------------------------------------
  // Apoio
  // ---------------------------------------------------------------

  Future<Map<int, Categoria>> _mapaDeCategorias() async {
    return {for (final c in await _categorias.listar()) c.id: c};
  }
}
