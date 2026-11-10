import 'dart:async';

import '../../data/repositories/categoria_repository.dart';
import '../../data/repositories/local_repository.dart';
import '../../data/repositories/objeto_repository.dart';
import '../../domain/models/categoria.dart';
import '../../domain/models/local.dart';
import '../../domain/models/objeto_detalhe.dart';
import '../core/base_view_model.dart';

class BuscarViewModel extends BaseViewModel {
  BuscarViewModel({
    required this._objetos,
    required LocalRepository locais,
    required CategoriaRepository categorias,
    this.atrasoDaBusca = const Duration(milliseconds: 300),
  }) : _locaisRepo = locais,
       _categoriasRepo = categorias;

  final ObjetoRepository _objetos;
  final LocalRepository _locaisRepo;
  final CategoriaRepository _categoriasRepo;

  /// Espera o usuário parar de digitar antes de consultar o banco.
  final Duration atrasoDaBusca;

  String _termo = '';
  int? _localId;
  int? _categoriaId;
  bool _somenteAntigos = false;

  List<ObjetoDetalhe> _resultados = [];
  List<Local> _locais = [];
  List<Categoria> _categorias = [];

  Timer? _espera;

  /// Descarta respostas antigas: só a última consulta vale.
  int _consultaAtual = 0;

  // ---------------------------------------------------------------
  // Leitura para a View
  // ---------------------------------------------------------------

  String get termo => _termo;
  int? get localSelecionado => _localId;
  int? get categoriaSelecionada => _categoriaId;
  List<ObjetoDetalhe> get resultados => List.unmodifiable(
    _somenteAntigos
        ? _resultados.where((item) => item.objeto.registroAntigo())
        : _resultados,
  );
  bool get somenteAntigos => _somenteAntigos;
  int get quantidadeAntigos =>
      _resultados.where((item) => item.objeto.registroAntigo()).length;
  List<Local> get locais => List.unmodifiable(_locais);
  List<Categoria> get categorias => List.unmodifiable(_categorias);

  bool get temFiltro => _localId != null || _categoriaId != null;

  // ---------------------------------------------------------------
  // Ações
  // ---------------------------------------------------------------

  /// Carrega os filtros e já mostra os objetos mais recentes.
  Future<void> iniciar() async {
    try {
      _locais = await _locaisRepo.listar();
      _categorias = await _categoriasRepo.listar();
    } catch (_) {
      // Sem filtros a busca por texto ainda funciona.
    }
    await buscar();
  }

  void termoAlterado(String valor) {
    _termo = valor;
    _espera?.cancel();
    _espera = Timer(atrasoDaBusca, buscar);
  }

  Future<void> filtrarPorLocal(int? localId) {
    _localId = localId;
    return buscar();
  }

  Future<void> filtrarPorCategoria(int? categoriaId) {
    _categoriaId = categoriaId;
    return buscar();
  }

  Future<void> limparFiltros() {
    _localId = null;
    _categoriaId = null;
    return buscar();
  }

  void alternarAntigos() {
    _somenteAntigos = !_somenteAntigos;
    notifyListeners();
  }

  Future<bool> excluirItem(int objetoId) async {
    try {
      await _objetos.excluir(objetoId);
      _resultados.removeWhere((item) => item.objeto.id == objetoId);
      definirEstado(
        _resultados.isEmpty ? EstadoTela.vazio : EstadoTela.sucesso,
      );
      return true;
    } catch (_) {
      mostrarErro('Não foi possível excluir este item do histórico.');
      return false;
    }
  }

  /// Recarrega a lista (por exemplo, ao voltar da tela de detalhe).
  Future<void> buscar() async {
    _espera?.cancel();
    final minhaConsulta = ++_consultaAtual;

    // Só mostra o indicador de carregamento quando não há nada na tela,
    // para a lista não piscar a cada letra digitada.
    if (_resultados.isEmpty) definirEstado(EstadoTela.carregando);

    try {
      final lista = await _objetos.buscar(
        _termo,
        localId: _localId,
        categoriaId: _categoriaId,
      );
      if (minhaConsulta != _consultaAtual) return;
      _resultados = lista;
      definirEstado(lista.isEmpty ? EstadoTela.vazio : EstadoTela.sucesso);
    } catch (_) {
      if (minhaConsulta != _consultaAtual) return;
      definirEstado(
        EstadoTela.erro,
        erro: 'Não foi possível buscar agora. Tente novamente.',
      );
    }
  }

  @override
  void dispose() {
    _espera?.cancel();
    super.dispose();
  }
}
