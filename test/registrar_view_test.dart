import 'package:cadesystem/app.dart';
import 'package:cadesystem/data/services/cade_database.dart';
import 'package:cadesystem/data/services/midia_service.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// O teste usa SQLite real em memória e substitui apenas o acesso às mídias.
class _MidiaDeTeste implements MidiaService {
  @override
  Future<int> tamanhoDe(String? relativo) async => 0;
  @override
  Future<void> apagar(String? relativo) async {}

  @override
  Future<void> dispose() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<CadeDatabase> _abrirApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });

  final banco = CadeDatabase(NativeDatabase.memory());
  await tester.runAsync(() => banco.listarCategorias());
  await tester.pumpWidget(CadeApp(banco: banco, midia: _MidiaDeTeste()));
  await tester.pumpAndSettle();
  addTearDown(() => banco.close());
  return banco;
}

Future<void> _irParaCadastro(WidgetTester tester) async {
  await tester.tap(find.text('Registrar'));
  await tester.pumpAndSettle();
}

Future<void> _tocarEmSalvar(WidgetTester tester) async {
  final botao = find.text('Salvar objeto');
  await tester.ensureVisible(botao);
  await tester.tap(botao);
  await tester.pumpAndSettle();
}

void main() {
  for (final salvar in [false, true]) {
    testWidgets(
      'sair da edicao ${salvar ? "salvando" : "sem salvar"} permite novo cadastro sem sobrescrever',
      (tester) async {
        final banco = await _abrirApp(tester);
        final id = await tester.runAsync(
          () => banco.registrarObjeto(nome: 'Documento', nomeLocal: 'Gaveta'),
        );
        await tester.tap(find.text('Histórico'));
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip('Editar item'));
        await tester.pumpAndSettle();
        expect(find.text('Editar objeto'), findsOneWidget);
        await tester.enterText(
          find.byKey(const ValueKey('local-objeto')),
          'Armario',
        );
        if (salvar) {
          await tester.ensureVisible(find.text('Salvar alterações'));
          await tester.tap(find.text('Salvar alterações'));
          await tester.pumpAndSettle();
        } else {
          await tester.pageBack();
          await tester.pumpAndSettle();
        }
        await tester.pageBack();
        await tester.pumpAndSettle();
        await _irParaCadastro(tester);
        expect(find.text('Novo objeto'), findsOneWidget);
        await tester.enterText(
          find.byKey(const ValueKey('nome-objeto')),
          'Chave',
        );
        await tester.enterText(
          find.byKey(const ValueKey('local-objeto')),
          'Mesa',
        );
        await _tocarEmSalvar(tester);
        final linhas = await tester.runAsync(() => banco.buscarObjetos(''));
        expect(linhas, hasLength(2));
        final original = await tester.runAsync(() => banco.obterObjeto(id!));
        expect(original!.objeto.nome, 'Documento');
        expect(original.local.nome, salvar ? 'Armario' : 'Gaveta');
      },
    );
  }

  testWidgets('detalhes abre edicao com foco no local e recarrega historico', (
    tester,
  ) async {
    final banco = await _abrirApp(tester);
    await tester.runAsync(
      () => banco.registrarObjeto(nome: 'Documento', nomeLocal: 'Gaveta'),
    );
    await tester.tap(find.text('Histórico'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Documento'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Editar local'));
    await tester.pumpAndSettle();
    final campo = tester.widget<EditableText>(
      find.descendant(
        of: find.byKey(const ValueKey('local-objeto')),
        matching: find.byType(EditableText),
      ),
    );
    expect(campo.focusNode.hasFocus, isTrue);
    await tester.enterText(
      find.byKey(const ValueKey('local-objeto')),
      'Armario',
    );
    await tester.ensureVisible(find.text('Salvar alterações'));
    await tester.tap(find.text('Salvar alterações'));
    await tester.pumpAndSettle();
    expect(find.text('Gaveta → Armario'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Local: Armario'), findsOneWidget);
    expect(find.text('Local: Gaveta'), findsNothing);
  });

  testWidgets(
    'exclusao pede confirmacao e atualiza a lista apos excluir nos detalhes',
    (tester) async {
      final banco = await _abrirApp(tester);
      await tester.runAsync(
        () => banco.registrarObjeto(nome: 'Documento', nomeLocal: 'Gaveta'),
      );
      await tester.tap(find.text('Histórico'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Excluir item'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(find.text('Documento'), findsOneWidget);
      await tester.tap(find.text('Documento'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Excluir'));
      await tester.tap(find.text('Excluir'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Excluir'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Nenhum item no histórico.'), findsOneWidget);
      expect(await tester.runAsync(() => banco.buscarObjetos('')), isEmpty);
    },
  );

  testWidgets('abre a home e navega para o cadastro do Cadê', (tester) async {
    await _abrirApp(tester);
    expect(find.text('Cadê?'), findsOneWidget);
    expect(find.text('Registrar'), findsOneWidget);
    expect(find.text('Histórico'), findsOneWidget);

    await _irParaCadastro(tester);
    expect(find.text('Novo objeto'), findsOneWidget);
    expect(find.textContaining('Flutter Demo'), findsNothing);
  });

  testWidgets('rejeita campos obrigatórios vazios', (tester) async {
    final banco = await _abrirApp(tester);
    await _irParaCadastro(tester);

    await _tocarEmSalvar(tester);
    expect(find.text('Informe o nome do objeto.'), findsOneWidget);
    expect(find.text('Informe onde você guardou o objeto.'), findsOneWidget);
    final registros = await tester.runAsync(() => banco.buscarObjetos(''));
    expect(registros, isEmpty);
  });

  testWidgets('salva nome e local no banco sem foto e limpa o formulário', (
    tester,
  ) async {
    final banco = await _abrirApp(tester);
    await _irParaCadastro(tester);

    await tester.enterText(
      find.byKey(const ValueKey('nome-objeto')),
      'Documento X',
    );
    await tester.enterText(
      find.byKey(const ValueKey('local-objeto')),
      'Gaveta do escritório',
    );
    await _tocarEmSalvar(tester);

    final registros = await tester.runAsync(
      () => banco.buscarObjetos('Documento X'),
    );
    expect(registros, hasLength(1));
    expect(registros!.single.local.nome, 'Gaveta do escritório');
    expect(registros.single.objeto.fotoPath, isNull);
    expect(registros.single.objeto.registradoEm.year, DateTime.now().year);
    await tester.pumpAndSettle();
    expect(find.text('Objeto salvo no seu aparelho.'), findsOneWidget);

    final campos = tester.widgetList<TextFormField>(find.byType(TextFormField));
    expect(campos.every((campo) => campo.controller!.text.isEmpty), isTrue);
  });

  testWidgets('explica a câmera antes da solicitação e permite desistir', (
    tester,
  ) async {
    await _abrirApp(tester);
    await _irParaCadastro(tester);
    await tester.ensureVisible(find.text('Adicionar foto'));
    await tester.tap(find.text('Adicionar foto'));
    await tester.pumpAndSettle();

    expect(find.text('Usar câmera'), findsOneWidget);
    expect(
      find.textContaining('As fotos ficam só no seu aparelho.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Agora não'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Novo objeto'), findsOneWidget);
  });

  testWidgets('explica o microfone antes da solicitação e permite desistir', (
    tester,
  ) async {
    await _abrirApp(tester);
    await _irParaCadastro(tester);
    await tester.ensureVisible(find.text('Gravar áudio'));
    await tester.tap(find.text('Gravar áudio'));
    await tester.pumpAndSettle();

    expect(find.text('Usar microfone'), findsOneWidget);
    expect(
      find.textContaining('O áudio fica só no seu aparelho.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Agora não'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets(
    'cadastro continua funcional em tela estreita com texto ampliado',
    (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2;

      await _abrirApp(tester);
      await _irParaCadastro(tester);

      for (final rotulo in ['Nome do objeto *', 'Onde você guardou? *']) {
        final texto = tester.renderObject<RenderParagraph>(find.text(rotulo));
        expect(texto.didExceedMaxLines, isFalse, reason: rotulo);
      }

      await _tocarEmSalvar(tester);
      expect(find.text('Informe o nome do objeto.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
