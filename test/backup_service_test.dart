import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:cadesystem/data/services/backup_service.dart';
import 'package:cadesystem/data/services/cade_database.dart';
import 'package:cadesystem/data/services/midia_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class _MidiaDeTeste implements MidiaService {
  _MidiaDeTeste(this.pasta);

  final Directory pasta;

  @override
  Future<List<String>> listarArquivos() async => ['fotos/objeto.jpg'];

  @override
  File arquivo(String relativo) => File('${pasta.path}/$relativo');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('backup contém banco legível, mídia e manifesto', () async {
    final pasta = await Directory.systemTemp.createTemp('cade-backup-teste-');
    addTearDown(() => pasta.delete(recursive: true));
    final foto = File('${pasta.path}/fotos/objeto.jpg');
    await foto.parent.create(recursive: true);
    await foto.writeAsBytes([1, 2, 3]);

    final banco = CadeDatabase(NativeDatabase.memory());
    await banco.registrarObjeto(
      nome: 'Documento',
      nomeLocal: 'Gaveta',
      fotoPath: 'fotos/objeto.jpg',
    );

    final zip = ZipDecoder().decodeBytes(
      await BackupService(
        banco: banco,
        midia: _MidiaDeTeste(pasta),
        diretorioTemporario: pasta,
      ).gerarArquivo(),
    );

    expect(zip.findFile('midias/fotos/objeto.jpg')!.content, [1, 2, 3]);
    final manifesto = jsonDecode(
      utf8.decode(zip.findFile('manifesto.json')!.content),
    );
    expect(manifesto['formato'], 'cade-backup');
    expect(manifesto['midias'], ['fotos/objeto.jpg']);

    await banco.close();

    final copia = File('${pasta.path}/copia.sqlite');
    await copia.writeAsBytes(zip.findFile('cade.sqlite')!.content);
    final restaurado = CadeDatabase(NativeDatabase(copia));
    addTearDown(restaurado.close);
    final itens = await restaurado.buscarObjetos('Documento');
    expect(itens.single.local.nome, 'Gaveta');
    expect(itens.single.objeto.fotoPath, 'fotos/objeto.jpg');
  });
}
