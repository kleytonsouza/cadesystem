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
  testWidgets('navega pelos objetos de um local e limpa o filtro', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final banco = CadeDatabase(NativeDatabase.memory());
    addTearDown(banco.close);
    await tester.runAsync(() async {
      await banco.registrarObjeto(nome: 'Chave', nomeLocal: 'Gaveta');
      await banco.registrarObjeto(nome: 'Documento', nomeLocal: 'Mesa');
    });

    await tester.pumpWidget(CadeApp(banco: banco, midia: _MidiaDeTeste()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Histórico'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Buscar objetos'));
    await tester.pumpAndSettle();

    expect(find.text('Chave'), findsOneWidget);
    expect(find.text('Documento'), findsOneWidget);

    await tester.tap(find.text('Todos os locais'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gaveta').last);
    await tester.pumpAndSettle();

    expect(find.text('Chave'), findsOneWidget);
    expect(find.text('Documento'), findsNothing);

    await tester.tap(find.text('Limpar filtros'));
    await tester.pumpAndSettle();
    expect(find.text('Documento'), findsOneWidget);
  });
}
