import 'package:cadesystem/data/repositories/categoria_repository.dart';
import 'package:cadesystem/data/repositories/local_repository.dart';
import 'package:cadesystem/data/repositories/objeto_repository.dart';
import 'package:cadesystem/data/services/cade_database.dart';
import 'package:cadesystem/data/services/midia_service.dart';
import 'package:cadesystem/data/services/permissao_service.dart';
import 'package:cadesystem/ui/registrar/registrar_view_model.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class _MidiaDeTeste implements MidiaService {
  @override
  Future<int> tamanhoDe(String? relativo) async => 0;
  @override
  Future<void> apagar(String? relativo) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late CadeDatabase banco;
  late RegistrarViewModel viewModel;

  setUp(() {
    banco = CadeDatabase(NativeDatabase.memory());
    final midia = _MidiaDeTeste();
    final categorias = CategoriaRepository(banco: banco);
    viewModel = RegistrarViewModel(
      objetos: ObjetoRepository(
        banco: banco,
        midia: midia,
        categorias: categorias,
      ),
      locais: LocalRepository(banco: banco, midia: midia),
      categorias: categorias,
      midia: midia,
      permissoes: PermissaoService(),
    );
  });

  tearDown(() async {
    viewModel.dispose();
    await banco.close();
  });

  test('nome e local compostos apenas de espaços impedem salvar', () {
    viewModel.nomeAlterado('   ');
    viewModel.nomeLocalAlterado('Gaveta');
    expect(viewModel.podeSalvar, isFalse);
    viewModel.nomeAlterado('Documento');
    viewModel.nomeLocalAlterado('   ');
    expect(viewModel.podeSalvar, isFalse);
  });

  test('aceita 50 caracteres visíveis e rejeita 51', () {
    viewModel.nomeLocalAlterado('Gaveta');
    viewModel.nomeAlterado('📄' * 50);
    expect(viewModel.podeSalvar, isTrue);
    viewModel.nomeAlterado('a' * 51);
    expect(viewModel.podeSalvar, isFalse);
    expect(
      viewModel.validarNome(viewModel.nome),
      'Use no máximo 50 caracteres.',
    );
  });

  test('falha ao salvar mantém os campos para uma nova tentativa', () async {
    await banco.customStatement('PRAGMA query_only = ON');
    viewModel.nomeAlterado('Documento X');
    viewModel.nomeLocalAlterado('Gaveta');
    expect(await viewModel.salvar(), isFalse);
    expect(viewModel.nome, 'Documento X');
    expect(viewModel.nomeLocal, 'Gaveta');
    expect(viewModel.salvando, isFalse);
    expect(viewModel.mensagemErro, isNotNull);
  });

  test('remover áudio antigo e salvar elimina o vínculo do registro', () async {
    final id = await banco.registrarObjeto(
      nome: 'Documento',
      nomeLocal: 'Gaveta',
      audioPath: 'audios/antigo.m4a',
    );

    await viewModel.iniciar(objetoId: id);
    expect(viewModel.caminhoAudio, 'audios/antigo.m4a');
    await viewModel.removerAudio();
    expect(viewModel.caminhoAudio, isNull);
    expect(await viewModel.salvar(), isTrue);

    final salvo = await banco.obterObjeto(id);
    expect(salvo!.objeto.audioPath, isNull);
  });
}
