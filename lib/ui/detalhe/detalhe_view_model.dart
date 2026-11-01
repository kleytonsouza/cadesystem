import '../../data/repositories/objeto_repository.dart';
import '../../domain/models/historico_local.dart';
import '../../domain/models/objeto_detalhe.dart';
import '../core/base_view_model.dart';

class DetalheViewModel extends BaseViewModel {
  DetalheViewModel({required this.objetoId, required this._objetos});

  final int objetoId;
  final ObjetoRepository _objetos;

  ObjetoDetalhe? _detalhe;
  List<HistoricoLocal> _historico = const [];
  bool _ocupado = false;
  bool _excluido = false;

  // ---------------------------------------------------------------
  // Leitura para a View
  // ---------------------------------------------------------------

  ObjetoDetalhe? get detalhe => _detalhe;
  List<HistoricoLocal> get historico => List.unmodifiable(_historico);

  /// Há uma operação em andamento (mover, excluir...): desabilite os botões.
  bool get ocupado => _ocupado;

  /// true depois de excluir: a View deve fechar a tela.
  bool get excluido => _excluido;

  /// US11: o registro não é confirmado há muito tempo.
  bool get registroAntigo => _detalhe?.objeto.registroAntigo() ?? false;

  // ---------------------------------------------------------------
  // Ações
  // ---------------------------------------------------------------

  Future<void> carregar() async {
    definirEstado(EstadoTela.carregando);
    await _buscarDetalhe();
  }

  Future<void> _buscarDetalhe() async {
    try {
      final encontrado = await _objetos.obter(objetoId);
      if (encontrado == null) {
        _detalhe = null;
        definirEstado(
          EstadoTela.vazio,
          erro: 'Este objeto não foi encontrado.',
        );
        return;
      }
      _detalhe = encontrado;
      _historico = await _objetos.historicoDoObjeto(objetoId);
      definirEstado(EstadoTela.sucesso);
    } catch (_) {
      _historico = const [];
      definirEstado(
        EstadoTela.erro,
        erro: 'Não foi possível abrir o objeto. Tente novamente.',
      );
    }
  }

  /// US09: muda o objeto de lugar. Também renova a confirmação (US11).
  Future<bool> mover(String novoLocal) async {
    final destino = novoLocal.trim();
    if (destino.isEmpty || _ocupado) return false;
    return _executar(
      () => _objetos.mover(objetoId, destino),
      'Não foi possível mudar o local.',
    );
  }

  /// US11: "Continua aqui". Mover para o mesmo local só renova a confirmação.
  Future<bool> confirmarLocal() async {
    final atual = _detalhe;
    if (atual == null || _ocupado) return false;
    return _executar(
      () => _objetos.mover(objetoId, atual.local.nome),
      'Não foi possível confirmar agora.',
    );
  }

  /// US10: exclui o objeto (o repository também apaga foto e áudio).
  Future<bool> excluir() async {
    if (_detalhe == null || _ocupado) return false;
    _ocupado = true;
    limparErro();
    notifyListeners();
    try {
      await _objetos.excluir(objetoId);
      _excluido = true;
      _ocupado = false;
      notifyListeners();
      return true;
    } catch (_) {
      _ocupado = false;
      mostrarErro('Não foi possível excluir. Tente novamente.');
      return false;
    }
  }

  /// Roda uma alteração e recarrega o detalhe sem piscar a tela.
  Future<bool> _executar(Future<void> Function() acao, String erro) async {
    _ocupado = true;
    limparErro();
    notifyListeners();
    try {
      await acao();
      await _buscarDetalhe();
      _ocupado = false;
      notifyListeners();
      return true;
    } catch (_) {
      _ocupado = false;
      mostrarErro(erro);
      return false;
    }
  }
}
