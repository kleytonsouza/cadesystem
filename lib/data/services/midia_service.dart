import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Resultado de salvar uma mídia: o que vai para o banco.
class MidiaSalva {
  /// Caminho relativo à pasta de mídias do app.
  final String caminhoRelativo;
  final int tamanhoBytes;

  const MidiaSalva({required this.caminhoRelativo, required this.tamanhoBytes});
}

class MidiaService {
  MidiaService._(this._base, this._picker, this._gravador);

  final Directory _base;
  final ImagePicker _picker;
  final AudioRecorder _gravador;

  /// Caminho relativo do áudio em gravação (null se não estiver gravando).
  String? _gravandoEm;

  // Compressão (US14): suficiente para reconhecer o objeto e ocupar pouco.
  static const _qualidadeFoto = 70;
  static const _ladoMaximoFoto = 1280.0;
  static const _bitRateAudio = 64000;
  static const _sampleRateAudio = 22050;

  /// Cria o service. Chame uma vez ao iniciar o app (ex.: no main/app.dart),
  /// para que [caminho] possa ser síncrono depois.
  static Future<MidiaService> criar({
    ImagePicker? picker,
    AudioRecorder? gravador,
  }) async {
    final docs = await getApplicationDocumentsDirectory();
    final base = Directory(p.join(docs.path, 'midias'));
    await Directory(p.join(base.path, 'fotos')).create(recursive: true);
    await Directory(p.join(base.path, 'audios')).create(recursive: true);
    return MidiaService._(
      base,
      picker ?? ImagePicker(),
      gravador ?? AudioRecorder(),
    );
  }

  // -----------------------------------------------------------------
  // Caminhos
  // -----------------------------------------------------------------

  /// Converte o caminho relativo guardado no banco no caminho real do arquivo.
  String caminho(String relativo) =>
      p.joinAll([_base.path, ...relativo.split('/')]);

  File arquivo(String relativo) => File(caminho(relativo));

  String _novoNome(String pasta, String extensao) =>
      '$pasta/${DateTime.now().microsecondsSinceEpoch}.$extensao';

  // -----------------------------------------------------------------
  // Fotos (US01, US03)
  // -----------------------------------------------------------------

  /// Tira uma foto com a câmera. Devolve null se o usuário cancelar.
  Future<MidiaSalva?> tirarFoto() => _capturarFoto(ImageSource.camera);

  /// Escolhe uma foto da galeria. Devolve null se o usuário cancelar.
  Future<MidiaSalva?> escolherFotoDaGaleria() =>
      _capturarFoto(ImageSource.gallery);

  Future<MidiaSalva?> _capturarFoto(ImageSource origem) async {
    // O próprio image_picker já reduz e comprime a imagem.
    final capturada = await _picker.pickImage(
      source: origem,
      maxWidth: _ladoMaximoFoto,
      maxHeight: _ladoMaximoFoto,
      imageQuality: _qualidadeFoto,
    );
    if (capturada == null) return null;

    final relativo = _novoNome('fotos', 'jpg');
    final destino = File(caminho(relativo));
    await File(capturada.path).copy(destino.path);
    await _apagarTemporario(capturada.path);

    return MidiaSalva(
      caminhoRelativo: relativo,
      tamanhoBytes: await destino.length(),
    );
  }

  Future<void> _apagarTemporario(String path) async {
    try {
      final f = File(path);
      // Só apaga se for cópia temporária, nunca um arquivo da galeria do usuário.
      if (p.isWithin((await getTemporaryDirectory()).path, f.path) &&
          await f.exists()) {
        await f.delete();
      }
    } catch (_) {
      // Limpeza é opcional: falhar aqui não deve atrapalhar o registro.
    }
  }

  // -----------------------------------------------------------------
  // Áudio (US04)
  // -----------------------------------------------------------------

  bool get gravando => _gravandoEm != null;

  /// O sistema já concedeu o microfone? (Peça antes com o PermissaoService.)
  Future<bool> microfoneDisponivel() => _gravador.hasPermission();

  /// Começa a gravar. Devolve false se não houver permissão.
  Future<bool> iniciarGravacao() async {
    if (gravando) return true;
    if (!await _gravador.hasPermission()) return false;

    final relativo = _novoNome('audios', 'm4a');
    await _gravador.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: _bitRateAudio,
        sampleRate: _sampleRateAudio,
        numChannels: 1,
      ),
      path: caminho(relativo),
    );
    _gravandoEm = relativo;
    return true;
  }

  /// Para a gravação e devolve o áudio salvo (null se não estava gravando).
  Future<MidiaSalva?> pararGravacao() async {
    final relativo = _gravandoEm;
    if (relativo == null) return null;
    _gravandoEm = null;

    await _gravador.stop();
    final arq = arquivo(relativo);
    if (!await arq.exists()) return null;

    return MidiaSalva(
      caminhoRelativo: relativo,
      tamanhoBytes: await arq.length(),
    );
  }

  /// Interrompe e descarta a gravação em andamento.
  Future<void> cancelarGravacao() async {
    final relativo = _gravandoEm;
    if (relativo == null) return;
    _gravandoEm = null;
    await _gravador.stop();
    await apagar(relativo);
  }

  // -----------------------------------------------------------------
  // Manutenção (US10, US14)
  // -----------------------------------------------------------------

  /// Apaga um arquivo de mídia. Aceita null e não falha se ele não existir.
  Future<void> apagar(String? relativo) async {
    if (relativo == null) return;
    try {
      final arq = arquivo(relativo);
      if (await arq.exists()) await arq.delete();
    } catch (_) {
      // Arquivo travado ou já removido: não deve impedir a exclusão do registro.
    }
  }

  /// Tamanho de um arquivo em bytes (0 se não existir).
  Future<int> tamanhoDe(String? relativo) async {
    if (relativo == null) return 0;
    final arq = arquivo(relativo);
    return await arq.exists() ? arq.length() : 0;
  }

  /// US14: espaço real ocupado por todas as mídias no aparelho.
  Future<int> espacoTotalBytes() async {
    var total = 0;
    await for (final item in _base.list(recursive: true)) {
      if (item is File) total += await item.length();
    }
    return total;
  }

  /// Caminhos relativos das mídias que acompanham a cópia do banco.
  Future<List<String>> listarArquivos() async {
    final caminhos = <String>[];
    await for (final item in _base.list(recursive: true)) {
      if (item is File) {
        caminhos.add(
          p.relative(item.path, from: _base.path).replaceAll('\\', '/'),
        );
      }
    }
    caminhos.sort();
    return caminhos;
  }

  /// Libere ao encerrar o app (ou no dispose do provider).
  Future<void> dispose() async {
    await _gravador.dispose();
  }
}
