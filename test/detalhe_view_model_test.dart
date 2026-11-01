import 'package:cadesystem/data/repositories/categoria_repository.dart';
import 'package:cadesystem/data/repositories/objeto_repository.dart';
import 'package:cadesystem/data/services/cade_database.dart';
import 'package:cadesystem/data/services/midia_service.dart';
import 'package:cadesystem/domain/models/historico_local.dart' as model;
import 'package:cadesystem/ui/detalhe/detalhe_view_model.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class _MidiaDeTeste implements MidiaService {
  @override
  Future<void> apagar(String? relativo) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late CadeDatabase banco;
  late CategoriaRepository categorias;
  late ObjetoRepository objetos;

  setUp(() {
    banco = CadeDatabase(NativeDatabase.memory());
    categorias = CategoriaRepository(banco: banco);
    objetos = ObjetoRepository(
      banco: banco,
      midia: _MidiaDeTeste(),
      categorias: categorias,
    );
  });

  tearDown(() async {
    await banco.close();
  });

  test('carrega o detalhe, move o objeto e exclui depois', () async {
    final categoriaId = (await categorias.listar()).first.id;
    final objetoId = await objetos.registrar(
      nome: 'Chave da porta',
      nomeLocal: 'Mesa do escritório',
      categoriaId: categoriaId,
    );

    final viewModel = DetalheViewModel(objetoId: objetoId, objetos: objetos);
    await viewModel.carregar();

    expect(viewModel.detalhe, isNotNull);
    expect(viewModel.historico, isEmpty);
    expect(viewModel.registroAntigo, isFalse);

    final movido = await viewModel.mover('Gaveta da cozinha');
    expect(movido, isTrue);
    expect(viewModel.detalhe, isNotNull);
    expect(viewModel.detalhe!.local.nome, 'Gaveta da cozinha');
    expect(viewModel.historico, hasLength(1));
    expect(viewModel.historico.first.localAntigo, 'Mesa do escritório');
    expect(viewModel.historico.first.localNovo, 'Gaveta da cozinha');

    final confirmado = await viewModel.confirmarLocal();
    expect(confirmado, isTrue);
    expect(viewModel.historico, isNotEmpty);

    final excluiu = await viewModel.excluir();
    expect(excluiu, isTrue);
    expect(viewModel.excluido, isTrue);
    expect(await objetos.obter(objetoId), isNull);
  });

  test('historico local compara por id e objeto', () {
    final primeiro = model.HistoricoLocal(
      id: 7,
      objetoId: 13,
      localAntigo: 'Mesa',
      localNovo: 'Gaveta',
      alteradoEm: DateTime(2024, 1, 10),
    );
    final segundo = model.HistoricoLocal(
      id: 7,
      objetoId: 13,
      localAntigo: 'Outros',
      localNovo: 'Outro',
      alteradoEm: DateTime(2024, 1, 12),
    );

    expect(primeiro, equals(segundo));
    expect(primeiro.hashCode, equals(segundo.hashCode));
  });
}
