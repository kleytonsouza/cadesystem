import 'dart:io';

import 'package:cadesystem/data/repositories/categoria_repository.dart';
import 'package:cadesystem/data/repositories/local_repository.dart';
import 'package:cadesystem/data/repositories/objeto_repository.dart';
import 'package:cadesystem/data/services/cade_database.dart';
import 'package:cadesystem/data/services/midia_service.dart';
import 'package:cadesystem/data/services/permissao_service.dart';
import 'package:cadesystem/ui/core/base_view_model.dart';
import 'package:cadesystem/ui/registrar/registrar_view_model.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class _MidiaDeTeste implements MidiaService {
  _MidiaDeTeste(this.base);
  final Directory base;
  @override
  String caminho(String relativo) => '${base.path}/$relativo';
  @override
  Future<int> tamanhoDe(String? relativo) async =>
      relativo == null ? 0 : File(caminho(relativo)).length();
  @override
  Future<void> apagar(String? relativo) async {
    if (relativo == null) return;
    final arquivo = File(caminho(relativo));
    if (await arquivo.exists()) await arquivo.delete();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late Directory temporarios;
  late CadeDatabase banco;
  late _MidiaDeTeste midia;
  late ObjetoRepository objetos;
  late RegistrarViewModel vm;

  setUp(() async {
    temporarios = await Directory.systemTemp.createTemp('cade-edicao-');
    banco = CadeDatabase(NativeDatabase.memory());
    midia = _MidiaDeTeste(temporarios);
    final categorias = CategoriaRepository(banco: banco);
    objetos = ObjetoRepository(
      banco: banco,
      categorias: categorias,
      midia: midia,
    );
    vm = RegistrarViewModel(
      objetos: objetos,
      locais: LocalRepository(banco: banco, midia: midia),
      categorias: categorias,
      midia: midia,
      permissoes: PermissaoService(),
    );
    await File(midia.caminho('foto.jpg')).writeAsBytes([1, 2, 3]);
    await File(midia.caminho('audio.m4a')).writeAsBytes([4, 5]);
  });
  tearDown(() async {
    vm.dispose();
    await banco.close();
    await temporarios.delete(recursive: true);
  });

  Future<int> cadastrar() => objetos.registrar(
    nome: 'Documento',
    nomeLocal: 'Gaveta',
    fotoPath: 'foto.jpg',
    audioPath: 'audio.m4a',
    tamanhoBytes: 5,
  );

  test(
    'editar local preserva foto, audio, data e registra uma movimentacao',
    () async {
      final id = await cadastrar();
      final anterior = await objetos.obter(id);
      await vm.prepararEdicao(id);
      expect(vm.caminhoFotoObjeto, midia.caminho('foto.jpg'));
      vm.nomeLocalAlterado('Armario');
      expect(await vm.salvar(), isTrue);
      final salvo = (await objetos.obter(id))!;
      expect(salvo.local.nome, 'Armario');
      expect(salvo.objeto.fotoPath, 'foto.jpg');
      expect(salvo.objeto.audioPath, 'audio.m4a');
      expect(salvo.objeto.tamanhoBytes, 5);
      expect(salvo.objeto.registradoEm, anterior!.objeto.registradoEm);
      expect(await File(midia.caminho('foto.jpg')).exists(), isTrue);
      expect(await banco.historicoDoObjeto(id), hasLength(1));
      expect(await vm.salvar(), isTrue);
      expect(await banco.historicoDoObjeto(id), hasLength(1));
    },
  );

  test('remover foto e cancelar preserva arquivo e vinculo original', () async {
    final id = await cadastrar();
    await vm.prepararEdicao(id);
    await vm.removerFotoDoObjeto();
    expect(vm.caminhoFotoObjeto, isNull);
    await vm.limparFormulario();
    expect((await objetos.obter(id))!.objeto.fotoPath, 'foto.jpg');
    expect(await File(midia.caminho('foto.jpg')).exists(), isTrue);
  });

  test('remover foto e salvar apaga somente a foto mantendo o audio', () async {
    final id = await cadastrar();
    await vm.prepararEdicao(id);
    await vm.removerFotoDoObjeto();
    expect(await vm.salvar(), isTrue);
    final salvo = (await objetos.obter(id))!;
    expect(salvo.objeto.fotoPath, isNull);
    expect(salvo.objeto.audioPath, 'audio.m4a');
    expect(salvo.objeto.tamanhoBytes, 2);
    expect(await File(midia.caminho('foto.jpg')).exists(), isFalse);
    expect(await File(midia.caminho('audio.m4a')).exists(), isTrue);
  });

  test(
    'fotos adicionais persistem e a primeira restante vira foto principal',
    () async {
      await File(midia.caminho('extra1.jpg')).writeAsBytes([6]);
      await File(midia.caminho('extra2.jpg')).writeAsBytes([7]);
      final id = await objetos.registrar(
        nome: 'Documento',
        nomeLocal: 'Gaveta',
        fotoPath: 'foto.jpg',
        fotosExtras: ['extra1.jpg', 'extra2.jpg'],
      );

      expect((await objetos.obter(id))!.fotosExtras, [
        'extra1.jpg',
        'extra2.jpg',
      ]);
      await vm.prepararEdicao(id);
      await vm.removerFotoDoObjeto();
      await vm.removerFoto('extra2.jpg');
      expect(await vm.salvar(), isTrue);

      final salvo = (await objetos.obter(id))!;
      expect(salvo.objeto.fotoPath, 'extra1.jpg');
      expect(salvo.fotosExtras, isEmpty);
      expect(await File(midia.caminho('foto.jpg')).exists(), isFalse);
      expect(await File(midia.caminho('extra1.jpg')).exists(), isTrue);
      expect(await File(midia.caminho('extra2.jpg')).exists(), isFalse);

      await objetos.excluir(id);
      expect(await File(midia.caminho('extra1.jpg')).exists(), isFalse);
    },
  );

  test('cancelar remoção de foto adicional preserva vínculo e arquivo', () async {
    await File(midia.caminho('extra.jpg')).writeAsBytes([6]);
    final id = await objetos.registrar(
      nome: 'Documento',
      nomeLocal: 'Gaveta',
      fotoPath: 'foto.jpg',
      fotosExtras: ['extra.jpg'],
    );

    await vm.prepararEdicao(id);
    await vm.removerFoto('extra.jpg');
    await vm.limparFormulario();

    expect((await objetos.obter(id))!.fotosExtras, ['extra.jpg']);
    expect(await File(midia.caminho('extra.jpg')).exists(), isTrue);
  });

  test('substituicao limpa arquivo antigo somente apos salvar', () async {
    final id = await cadastrar();
    await File(midia.caminho('nova.jpg')).writeAsBytes([9]);
    await objetos.atualizar(
      id: id,
      nome: 'Documento',
      nomeLocal: 'Gaveta',
      fotoPath: 'nova.jpg',
      audioPath: 'audio.m4a',
      tamanhoBytes: 3,
    );
    expect((await objetos.obter(id))!.objeto.fotoPath, 'nova.jpg');
    expect(await File(midia.caminho('foto.jpg')).exists(), isFalse);
    expect(await File(midia.caminho('nova.jpg')).exists(), isTrue);
  });

  test('falha na edicao preserva arquivo e permite tentar novamente', () async {
    final id = await cadastrar();
    await vm.prepararEdicao(id);
    await vm.removerFotoDoObjeto();
    await banco.customStatement('PRAGMA query_only = ON');
    expect(await vm.salvar(), isFalse);
    expect(await File(midia.caminho('foto.jpg')).exists(), isTrue);
    expect((await objetos.obter(id))!.objeto.fotoPath, 'foto.jpg');
    await banco.customStatement('PRAGMA query_only = OFF');
    expect(await vm.salvar(), isTrue);
    expect(await File(midia.caminho('foto.jpg')).exists(), isFalse);
  });

  test('exclusao remove registro, historico e arquivos sem apagar local compartilhado', () async {
    final id = await cadastrar();
    await banco.moverObjeto(id, 'Mesa');
    await File(midia.caminho('local.jpg')).writeAsBytes([8]);
    final outro = await objetos.registrar(nome: 'Chave', nomeLocal: 'Gaveta');
    await banco.customStatement(
      "UPDATE locais SET foto_path = 'local.jpg' WHERE nome = 'Gaveta'",
    );
    await objetos.excluir(id);
    expect(await objetos.obter(id), isNull);
    expect(await banco.historicoDoObjeto(id), isEmpty);
    expect(await banco.espacoUsadoBytes(), 0);
    expect(await File(midia.caminho('foto.jpg')).exists(), isFalse);
    expect(await File(midia.caminho('audio.m4a')).exists(), isFalse);
    expect(await File(midia.caminho('local.jpg')).exists(), isTrue);
    expect(await objetos.obter(outro), isNotNull);
    expect(
      (await banco
              .customSelect('SELECT COUNT(*) AS total FROM objetos')
              .getSingle())
          .read<int>('total'),
      1,
    );
    await objetos.excluir(id); // repetir a exclusao nao deve falhar
  });

  test(
    'edicao de registro inexistente mostra erro em vez de simular sucesso',
    () async {
      await vm.prepararEdicao(999);
      expect(vm.estado, EstadoTela.erro);
      expect(vm.mensagemErro, 'Este objeto não foi encontrado.');
      expect(await vm.salvar(), isFalse);
      expect(
        () => objetos.atualizar(id: 999, nome: 'X', nomeLocal: 'Mesa'),
        throwsStateError,
      );
    },
  );

  test('alteracao persiste ao fechar e reabrir banco do dispositivo', () async {
    await banco.close();
    final arquivo = File('${temporarios.path}/persistencia.sqlite');
    var persistente = CadeDatabase(NativeDatabase(arquivo));
    final id = await persistente.registrarObjeto(
      nome: 'Documento',
      nomeLocal: 'Gaveta',
    );
    await persistente.atualizarObjeto(
      objetoId: id,
      nome: 'Documento',
      nomeLocal: 'Armario',
    );
    await persistente.close();
    persistente = CadeDatabase(NativeDatabase(arquivo));
    try {
      expect((await persistente.obterObjeto(id))!.local.nome, 'Armario');
      expect(await persistente.historicoDoObjeto(id), hasLength(1));
      await persistente.excluirObjeto(id);
    } finally {
      await persistente.close();
    }
    persistente = CadeDatabase(NativeDatabase(arquivo));
    try {
      expect(await persistente.obterObjeto(id), isNull);
    } finally {
      await persistente.close();
    }
  });
}
