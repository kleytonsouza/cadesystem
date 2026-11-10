import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'cade_database.dart';
import 'midia_service.dart';

class BackupService {
  const BackupService({
    required this.banco,
    required this.midia,
    this.diretorioTemporario,
  });

  final CadeDatabase banco;
  final MidiaService midia;
  final Directory? diretorioTemporario;

  Future<Uint8List> gerarArquivo() async {
    final temporario =
        await (diretorioTemporario ?? await getTemporaryDirectory()).createTemp(
          'cade-backup-',
        );
    try {
      final arquivoBanco = p.join(temporario.path, 'cade.sqlite');
      // VACUUM INTO produz uma cópia completa mesmo quando o banco usa WAL.
      await banco.customStatement('VACUUM INTO ?', [arquivoBanco]);

      final zip = Archive();
      final bytesBanco = await File(arquivoBanco).readAsBytes();
      zip.addFile(ArchiveFile('cade.sqlite', bytesBanco.length, bytesBanco));

      final caminhos = await midia.listarArquivos();
      for (final caminho in caminhos) {
        final arquivo = midia.arquivo(caminho);
        final bytes = await arquivo.readAsBytes();
        zip.addFile(ArchiveFile('midias/$caminho', bytes.length, bytes));
      }

      final manifesto = utf8.encode(
        jsonEncode({
          'formato': 'cade-backup',
          'versao': 1,
          'criadoEm': DateTime.now().toUtc().toIso8601String(),
          'midias': caminhos,
        }),
      );
      zip.addFile(ArchiveFile('manifesto.json', manifesto.length, manifesto));
      return ZipEncoder().encodeBytes(zip);
    } finally {
      await temporario.delete(recursive: true);
    }
  }

  Future<Uri?> exportar() async {
    final bytes = await gerarArquivo();
    final data = DateTime.now();
    final nome =
        'cade-backup-${data.year}${data.month.toString().padLeft(2, '0')}${data.day.toString().padLeft(2, '0')}.zip';
    return FilePicker.saveFile(
      fileName: nome,
      bytes: bytes,
      mimeType: 'application/zip',
    );
  }
}
