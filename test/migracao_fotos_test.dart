import 'dart:io';

import 'package:cadesystem/data/services/cade_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('migra banco anterior e preserva os objetos existentes', () async {
    final pasta = await Directory.systemTemp.createTemp('cade-migracao-');
    addTearDown(() => pasta.delete(recursive: true));
    final arquivo = File('${pasta.path}/cade.sqlite');

    final anterior = CadeDatabase(NativeDatabase(arquivo));
    final id = await anterior.registrarObjeto(
      nome: 'Documento',
      nomeLocal: 'Gaveta',
      fotoPath: 'fotos/antiga.jpg',
    );
    // Reproduz o estado do esquema 2 antes de abrir a nova versão.
    await anterior.customStatement('DROP TABLE fotos_objeto');
    await anterior.customStatement('PRAGMA user_version = 2');
    await anterior.close();

    final atualizado = CadeDatabase(NativeDatabase(arquivo));
    addTearDown(atualizado.close);
    final objeto = await atualizado.obterObjeto(id);
    expect(objeto!.objeto.fotoPath, 'fotos/antiga.jpg');
    expect(await atualizado.listarFotosExtras(id), isEmpty);
  });
}
