// lib/ui/configuracoes/configuracoes_view_model.dart
//
// Tela de configurações: espaço usado pelas mídias e exportação manual.

import 'package:cadesystem/ui/utils/formatadores.dart';

import '../../data/services/midia_service.dart';
import '../../data/services/backup_service.dart';
import '../core/base_view_model.dart';

class ConfiguracoesViewModel extends BaseViewModel {
  ConfiguracoesViewModel({required this._midia, required this._backup});

  final MidiaService _midia;
  final BackupService _backup;

  int _espacoBytes = 0;
  bool _exportando = false;

  int get espacoBytes => _espacoBytes;
  bool get exportando => _exportando;

  /// Ex.: "12 MB", pronto para a View exibir.
  String get espacoFormatado => formatarBytes(_espacoBytes);

  Future<void> carregar() async {
    definirEstado(EstadoTela.carregando);
    try {
      _espacoBytes = await _midia.espacoTotalBytes();
      definirEstado(EstadoTela.sucesso);
    } catch (_) {
      definirEstado(
        EstadoTela.erro,
        erro: 'Não foi possível calcular o espaço usado.',
      );
    }
  }

  /// true se o usuário escolheu um destino, false se cancelou, null se falhou.
  Future<bool?> exportarBackup() async {
    if (_exportando) return null;
    _exportando = true;
    limparErro();
    notifyListeners();
    try {
      final destino = await _backup.exportar();
      return destino != null;
    } catch (_) {
      mostrarErro('Não foi possível exportar o backup. Tente novamente.');
      return null;
    } finally {
      _exportando = false;
      notifyListeners();
    }
  }
}
