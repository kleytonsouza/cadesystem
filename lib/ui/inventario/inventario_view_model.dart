import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/services/midia_service.dart';
import '../../data/services/reconhecimento_service.dart';

class InventarioViewModel extends ChangeNotifier {
  InventarioViewModel({required this._midia, required this._reconhecimento});

  final MidiaService _midia;
  final ReconhecimentoService _reconhecimento;
  MidiaSalva? _foto;
  List<SugestaoObjeto> _sugestoes = [];
  bool _ocupado = false;
  String? _erro;

  MidiaSalva? get foto => _foto;
  List<SugestaoObjeto> get sugestoes => List.unmodifiable(_sugestoes);
  bool get ocupado => _ocupado;
  String? get erro => _erro;

  Future<void> escolherFoto() async {
    if (_ocupado) return;
    _ocupado = true;
    _erro = null;
    notifyListeners();
    try {
      final nova = await _midia.escolherFotoDaGaleria();
      if (nova == null) return;
      await _midia.apagar(_foto?.caminhoRelativo);
      _foto = nova;
      _sugestoes = [];
      notifyListeners();
      _sugestoes = await _reconhecimento.analisar(
        _midia.caminho(nova.caminhoRelativo),
      );
    } catch (_) {
      _erro = 'Não foi possível analisar a foto. Você pode informar o nome manualmente.';
    } finally {
      _ocupado = false;
      notifyListeners();
    }
  }

  /// Transfere a foto ao formulário, que passa a cuidar da limpeza e do salvamento.
  MidiaSalva? transferirFoto() {
    final foto = _foto;
    _foto = null;
    notifyListeners();
    return foto;
  }

  @override
  void dispose() {
    unawaited(_midia.apagar(_foto?.caminhoRelativo));
    super.dispose();
  }
}
