// lib/data/services/cade_database.dart
//
// Banco local do Cadê? com Drift (SQLite).
// Sem cadastro de usuário: os dados ficam só no aparelho (US12).
//
// Depois de criar/alterar este arquivo, gere o código:
//   dart run build_runner build

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'cade_database.g.dart';

// ===================================================================
// TABELAS
// ===================================================================

/// US06: filtrar por categoria. Lista fixa criada junto com o banco.
@DataClassName('CategoriaRow')
class Categorias extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text().unique()();
  IntColumn get ordem => integer().withDefault(const Constant(0))();
}

/// US03: locais reaproveitados entre vários objetos.
@DataClassName('LocalRow')
class Locais extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text().unique()();
  TextColumn get fotoPath => text().nullable()();
  DateTimeColumn get criadoEm => dateTime().withDefault(currentDateAndTime)();
}

/// US01, US02, US04, US07: o objeto registrado.
@DataClassName('ObjetoRow')
@TableIndex(name: 'idx_objetos_nome', columns: {#nome})
@TableIndex(name: 'idx_objetos_local', columns: {#localId})
@TableIndex(name: 'idx_objetos_categoria', columns: {#categoriaId})
class Objetos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get fotoPath => text().nullable()();
  TextColumn get audioPath => text().nullable()();
  TextColumn get descricao => text().nullable()();
  IntColumn get localId =>
      integer().references(Locais, #id, onDelete: KeyAction.restrict)();
  IntColumn get categoriaId => integer().nullable().references(
    Categorias,
    #id,
    onDelete: KeyAction.setNull,
  )();

  /// US14: espaço ocupado pelas mídias.
  IntColumn get tamanhoBytes => integer().withDefault(const Constant(0))();

  /// US07: data do registro.
  DateTimeColumn get registradoEm =>
      dateTime().withDefault(currentDateAndTime)();

  /// US11: última vez que o usuário confirmou onde o objeto está.
  DateTimeColumn get confirmadoEm =>
      dateTime().withDefault(currentDateAndTime)();
}

/// US09: histórico de mudanças de local.
@DataClassName('HistoricoLocalRow')
class HistoricoLocal extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get objetoId =>
      integer().references(Objetos, #id, onDelete: KeyAction.cascade)();
  IntColumn get localAntigoId => integer().nullable().references(
    Locais,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get localNovoId =>
      integer().references(Locais, #id, onDelete: KeyAction.restrict)();
  DateTimeColumn get alteradoEm => dateTime().withDefault(currentDateAndTime)();
}

// ===================================================================
// RESULTADO DE CONSULTA COM JOIN
// ===================================================================

class ObjetoComLocal {
  final ObjetoRow objeto;
  final LocalRow local;
  const ObjetoComLocal(this.objeto, this.local);
}

// ===================================================================
// BANCO
// ===================================================================

@DriftDatabase(tables: [Categorias, Locais, Objetos, HistoricoLocal])
class CadeDatabase extends _$CadeDatabase {
  CadeDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'cade'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _semear();
    },
    // Quando mudar o esquema: aumente schemaVersion, rode
    //   dart run drift_dev make-migrations
    // e descomente o bloco abaixo (o arquivo .steps.dart é gerado):
    //
    // onUpgrade: stepByStep(
    //   from1To2: (m, schema) async { ... },
    // ),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Dados iniciais: categorias prontas para o usuário só escolher.
  Future<void> _semear() async {
    const iniciais = [
      'Documentos',
      'Chaves',
      'Ferramentas',
      'Eletrônicos',
      'Roupas',
      'Remédios',
      'Outros',
    ];

    await batch((b) {
      for (var i = 0; i < iniciais.length; i++) {
        b.insert(
          categorias,
          CategoriasCompanion.insert(nome: iniciais[i], ordem: Value(i)),
        );
      }
    });
  }

  // -----------------------------------------------------------------
  // Categorias
  // -----------------------------------------------------------------

  Future<List<CategoriaRow>> listarCategorias() {
    return (select(
      categorias,
    )..orderBy([(c) => OrderingTerm.asc(c.ordem)])).get();
  }

  // -----------------------------------------------------------------
  // Locais (US03)
  // -----------------------------------------------------------------

  /// Retorna o id do local com esse nome, criando-o se não existir.
  Future<int> obterOuCriarLocal(String nome, {String? fotoPath}) async {
    final limpo = nome.trim();
    final existente =
        await (select(locais)
              ..where((l) => l.nome.lower().equals(limpo.toLowerCase()))
              ..limit(1))
            .getSingleOrNull();
    if (existente != null) return existente.id;

    final criado = await into(locais).insertReturning(
      LocaisCompanion.insert(nome: limpo, fotoPath: Value(fotoPath)),
    );
    return criado.id;
  }

  Future<List<LocalRow>> listarLocais() {
    return (select(locais)..orderBy([(l) => OrderingTerm.asc(l.nome)])).get();
  }

  /// US10: só exclui se não houver objetos no local. Retorna false se em uso.
  Future<bool> excluirLocal(int id) async {
    final contagem = objetos.id.count();
    final emUso =
        await (selectOnly(objetos)
              ..addColumns([contagem])
              ..where(objetos.localId.equals(id)))
            .map((row) => row.read(contagem))
            .getSingle();
    if ((emUso ?? 0) > 0) return false;

    await (delete(locais)..where((l) => l.id.equals(id))).go();
    return true;
  }

  // -----------------------------------------------------------------
  // Objetos
  // -----------------------------------------------------------------

  /// US01 a US04: registra um objeto (reaproveitando o local, se existir).
  Future<int> registrarObjeto({
    required String nome,
    required String nomeLocal,
    String? fotoPath,
    String? fotoLocalPath,
    String? audioPath,
    String? descricao,
    int? categoriaId,
    int tamanhoBytes = 0,
  }) {
    return transaction(() async {
      final localId = await obterOuCriarLocal(
        nomeLocal,
        fotoPath: fotoLocalPath,
      );
      final criado = await into(objetos).insertReturning(
        ObjetosCompanion.insert(
          nome: nome.trim(),
          localId: localId,
          fotoPath: Value(fotoPath),
          audioPath: Value(audioPath),
          descricao: Value(descricao),
          categoriaId: Value(categoriaId),
          tamanhoBytes: Value(tamanhoBytes),
        ),
      );
      return criado.id;
    });
  }

  /// US05: busca por texto, já trazendo o local.
  /// Obs.: o LIKE do SQLite ignora maiúsculas só para letras sem acento.
  Future<List<ObjetoComLocal>> buscarObjetos(String termo) async {
    final consulta =
        select(objetos)
            .join([innerJoin(locais, locais.id.equalsExp(objetos.localId))])
          ..where(objetos.nome.like('%${termo.trim()}%'))
          ..orderBy([OrderingTerm.desc(objetos.registradoEm)]);

    final linhas = await consulta.get();
    return linhas
        .map((r) => ObjetoComLocal(r.readTable(objetos), r.readTable(locais)))
        .toList();
  }

  /// US07: detalhe de um objeto (item e local).
  Future<ObjetoComLocal?> obterObjeto(int id) async {
    final consulta = select(objetos).join([
      innerJoin(locais, locais.id.equalsExp(objetos.localId)),
    ])..where(objetos.id.equals(id));

    final linha = await consulta.getSingleOrNull();
    if (linha == null) return null;
    return ObjetoComLocal(linha.readTable(objetos), linha.readTable(locais));
  }

  /// US06: o que tem em determinado local?
  Future<List<ObjetoRow>> objetosDoLocal(int localId) {
    return (select(objetos)
          ..where((o) => o.localId.equals(localId))
          ..orderBy([(o) => OrderingTerm.asc(o.nome)]))
        .get();
  }

  /// US09: muda o local, guarda o histórico e renova a confirmação.
  Future<void> moverObjeto(int objetoId, String novoLocal) {
    return transaction(() async {
      final obj = await (select(
        objetos,
      )..where((o) => o.id.equals(objetoId))).getSingleOrNull();
      if (obj == null) return;

      final novoId = await obterOuCriarLocal(novoLocal);
      final agora = DateTime.now();

      // Mesmo local: apenas confirma que o objeto continua lá.
      if (novoId == obj.localId) {
        await (update(objetos)..where((o) => o.id.equals(objetoId))).write(
          ObjetosCompanion(confirmadoEm: Value(agora)),
        );
        return;
      }

      await (update(objetos)..where((o) => o.id.equals(objetoId))).write(
        ObjetosCompanion(localId: Value(novoId), confirmadoEm: Value(agora)),
      );
      await into(historicoLocal).insert(
        HistoricoLocalCompanion.insert(
          objetoId: objetoId,
          localAntigoId: Value(obj.localId),
          localNovoId: novoId,
        ),
      );
    });
  }

  /// US09: lista o histórico de movimentação do objeto em ordem mais recente.
  Future<List<HistoricoLocalRow>> historicoDoObjeto(int objetoId) {
    return (select(historicoLocal)
          ..where((h) => h.objetoId.equals(objetoId))
          ..orderBy([(h) => OrderingTerm.desc(h.alteradoEm)]))
        .get();
  }

  /// US10: exclui o objeto e devolve a linha apagada, para o repository
  /// poder remover os arquivos de foto e áudio do aparelho.
  Future<ObjetoRow?> excluirObjeto(int id) async {
    final obj = await (select(
      objetos,
    )..where((o) => o.id.equals(id))).getSingleOrNull();
    if (obj == null) return null;
    await (delete(objetos)..where((o) => o.id.equals(id))).go();
    return obj;
  }

  // -----------------------------------------------------------------
  // Confiança e manutenção
  // -----------------------------------------------------------------

  /// US11: objetos sem confirmação há mais de [meses] meses.
  Future<List<ObjetoRow>> objetosAntigos({int meses = 11}) {
    final limite = DateTime.now().subtract(Duration(days: meses * 30));
    return (select(
      objetos,
    )..where((o) => o.confirmadoEm.isSmallerThanValue(limite))).get();
  }

  /// US14: espaço total ocupado pelas mídias, em bytes.
  Future<int> espacoUsadoBytes() async {
    final soma = objetos.tamanhoBytes.sum();
    final total = await (selectOnly(
      objetos,
    )..addColumns([soma])).map((row) => row.read(soma)).getSingle();
    return total ?? 0;
  }
}
