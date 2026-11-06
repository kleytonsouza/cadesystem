import 'dart:io';

import 'package:cadesystem/app.dart';
import 'package:cadesystem/data/services/cade_database.dart';
import 'package:cadesystem/data/services/midia_service.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _MidiaDeTeste implements MidiaService {
  @override
  String caminho(String relativo) => '${Directory.systemTemp.path}/$relativo';
  @override
  Future<void> dispose() async {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late CadeDatabase banco;
  setUp(() => banco = CadeDatabase(NativeDatabase.memory()));
  tearDown(() => banco.close());

  test('busca parcial ignora caixa e acentos compostos ou separados', () async {
    await banco.registrarObjeto(
      nome: 'CARTÃO de vacinação',
      nomeLocal: 'Gaveta',
    );
    await banco.registrarObjeto(
      nome: 'Carto\u0303es antigos',
      nomeLocal: 'Mesa',
    );
    expect(await banco.buscarObjetos('  cartao  '), hasLength(1));
    expect(await banco.buscarObjetos('vacinação'), hasLength(1));
    expect(await banco.buscarObjetos('VACINACAO'), hasLength(1));
    expect(await banco.buscarObjetos('carto\u0303es'), hasLength(1));
    expect(await banco.buscarObjetos('CARTÕES'), hasLength(1));
    expect(await banco.buscarObjetos('inexistente'), isEmpty);
    expect(await banco.buscarObjetos(''), hasLength(2));
  });

  test('busca em 200 registros termina em menos de um segundo', () async {
    await banco.transaction(() async {
      for (var i = 0; i < 200; i++) {
        await banco.registrarObjeto(
          nome: 'Cartão número $i',
          nomeLocal: 'Gaveta',
        );
      }
    });
    final tempo = Stopwatch()..start();
    final encontrados = await banco.buscarObjetos('CARTAO');
    tempo.stop();
    expect(encontrados, hasLength(200));
    expect(tempo.elapsedMilliseconds, lessThan(1000));
    // Evidência local; o desempenho também deve ser observado no aparelho.
    // ignore: avoid_print
    print('SCRUM-17: 200 resultados em ${tempo.elapsedMicroseconds / 1000} ms');
  });

  testWidgets(
    'historico da acesso a busca e mostra resultados e estado vazio',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      await tester.runAsync(
        () => banco.registrarObjeto(
          nome: 'Cartão',
          nomeLocal: 'Gaveta',
          fotoPath: 'foto.jpg',
        ),
      );
      await tester.runAsync(
        () => banco.registrarObjeto(nome: 'Chave', nomeLocal: 'Mesa'),
      );
      await tester.pumpWidget(CadeApp(banco: banco, midia: _MidiaDeTeste()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Histórico'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Buscar objetos'));
      await tester.pumpAndSettle();
      expect(find.text('Itens salvos'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'cartao');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(find.text('Cartão'), findsOneWidget);
      expect(find.text('Chave'), findsNothing);
      expect(find.text('Local: Gaveta'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'inexistente');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(
        find.text('Nenhum item encontrado no seu histórico.'),
        findsOneWidget,
      );
    },
  );
}
