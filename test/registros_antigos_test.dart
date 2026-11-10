import 'package:cadesystem/app.dart';
import 'package:cadesystem/data/services/cade_database.dart';
import 'package:cadesystem/data/services/midia_service.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _MidiaDeTeste implements MidiaService {
  @override
  Future<void> dispose() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('histórico indica e filtra locais possivelmente antigos', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final banco = CadeDatabase(NativeDatabase.memory());
    addTearDown(banco.close);
    await tester.runAsync(() async {
      final id = await banco.registrarObjeto(
        nome: 'Documento',
        nomeLocal: 'Gaveta',
      );
      await banco.registrarObjeto(nome: 'Chave', nomeLocal: 'Mesa');
      final antiga = DateTime.now()
          .subtract(const Duration(days: 400))
          .millisecondsSinceEpoch ~/ 1000;
      await banco.customStatement(
        'UPDATE objetos SET confirmado_em = ? WHERE id = ?',
        [antiga, id],
      );
    });

    await tester.pumpWidget(CadeApp(banco: banco, midia: _MidiaDeTeste()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Histórico'));
    await tester.pumpAndSettle();
    expect(find.text('Local pode estar desatualizado.'), findsOneWidget);

    await tester.tap(find.text('Para conferir (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Documento'), findsOneWidget);
    expect(find.text('Chave'), findsNothing);
  });
}
