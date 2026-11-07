// lib/ui/configuracoes/configuracoes_view_model.dart
//
// Tela de configurações. Por enquanto: espaço usado pelas mídias (US14).
// O backup manual (US15) entra aqui na R2, com um BackupService próprio.

import 'package:cadesystem/ui/utils/formatadores.dart';

import '../../data/services/midia_service.dart';
import '../core/base_view_model.dart';

class ConfiguracoesViewModel extends BaseViewModel {
  ConfiguracoesViewModel({required this._midia});

  final MidiaService _midia;

  int _espacoBytes = 0;

  int get espacoBytes => _espacoBytes;

  /// Ex.: "12 MB", pronto para a View exibir.
  String get espacoFormatado => formatarBytes(_espacoBytes);

  Future<void> carregar() async {
    definirEstado(EstadoTela.carregando);
    try {
      _espacoBytes = await _midia.espacoTotalBytes();
      definirEstado(EstadoTela.sucesso);
    } catch (_) {
      definirEstado(EstadoTela.erro,
          erro: 'Não foi possível calcular o espaço usado.');
    }
  }
}