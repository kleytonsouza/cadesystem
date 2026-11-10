import 'package:cadesystem/data/repositories/categoria_repository.dart';
import 'package:cadesystem/data/repositories/local_repository.dart';
import 'package:cadesystem/data/repositories/objeto_repository.dart';
import 'package:cadesystem/data/services/cade_database.dart';
import 'package:cadesystem/data/services/midia_service.dart';
import 'package:cadesystem/ui/buscar/buscar_view_model.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class _MidiaDeTeste implements MidiaService {
  @override
  Future<void> apagar(String? relativo) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late CadeDatabase banco;
  late CategoriaRepository categorias;
  late LocalRepository locais;
  late ObjetoRepository objetos;
  late BuscarViewModel viewModel;

  setUp(() async {
    banco = CadeDatabase(NativeDatabase.memory());
    categorias = CategoriaRepository(banco: banco);
    locais = LocalRepository(banco: banco, midia: _MidiaDeTeste());
    objetos = ObjetoRepository(
      banco: banco,
      midia: _MidiaDeTeste(),
      categorias: categorias,
    );

    final listaCategorias = await categorias.listar();
    final categoriaId = listaCategorias.first.id;

    await objetos.registrar(
      nome: 'Chave inglesa',
      nomeLocal: 'Mesa do escritório',
      categoriaId: categoriaId,
    );
    await objetos.registrar(
      nome: 'Documento de contrato',
      nomeLocal: 'Gaveta de cima',
      categoriaId: categoriaId,
    );

    viewModel = BuscarViewModel(
      objetos: objetos,
      locais: locais,
      categorias: categorias,
    );
  });

  tearDown(() async {
    viewModel.dispose();
    await banco.close();
  });

  test('inicia a busca e aplica filtros por local e categoria', () async {
    await viewModel.iniciar();
    expect(viewModel.locais, isNotEmpty);
    expect(viewModel.categorias, isNotEmpty);
    expect(viewModel.resultados, hasLength(2));

    final local = viewModel.locais.firstWhere(
      (item) => item.nome == 'Mesa do escritório',
    );
    await viewModel.filtrarPorLocal(local.id);
    expect(viewModel.temFiltro, isTrue);
    expect(viewModel.resultados, hasLength(1));
    expect(viewModel.resultados.single.objeto.nome, 'Chave inglesa');

    final categoria = viewModel.categorias.first;
    await viewModel.filtrarPorCategoria(categoria.id);
    expect(viewModel.resultados, hasLength(1));
    expect(viewModel.resultados.single.categoria?.id, categoria.id);

    await viewModel.limparFiltros();
    expect(viewModel.temFiltro, isFalse);
    expect(viewModel.resultados, hasLength(2));
  });

  test('exclui um item do histórico e atualiza a lista', () async {
    await viewModel.iniciar();
    expect(viewModel.resultados, hasLength(2));

    final idParaExcluir = viewModel.resultados.first.objeto.id;
    final ok = await viewModel.excluirItem(idParaExcluir);

    expect(ok, isTrue);
    expect(viewModel.resultados, hasLength(1));
    expect(
      viewModel.resultados.any((item) => item.objeto.id == idParaExcluir),
      isFalse,
    );
  });

  test('mostra registros antigos e remove aviso após confirmar local', () async {
    final itens = await objetos.buscar('');
    final antigo = itens.first.objeto.id;
    final dataAntiga = DateTime.now()
        .subtract(const Duration(days: 400))
        .millisecondsSinceEpoch ~/ 1000;
    await banco.customStatement(
      'UPDATE objetos SET confirmado_em = ? WHERE id = ?',
      [dataAntiga, antigo],
    );

    await viewModel.iniciar();
    expect(viewModel.quantidadeAntigos, 1);
    viewModel.alternarAntigos();
    expect(viewModel.resultados.single.objeto.id, antigo);

    final local = itens.first.local.nome;
    await objetos.mover(antigo, local);
    await viewModel.buscar();
    expect(viewModel.quantidadeAntigos, 0);
    expect(viewModel.resultados, isEmpty);
    viewModel.alternarAntigos();
    expect(viewModel.resultados, hasLength(2));
  });
}
