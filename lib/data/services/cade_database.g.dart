// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cade_database.dart';

// ignore_for_file: type=lint
class $CategoriasTable extends Categorias
    with TableInfo<$CategoriasTable, CategoriaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _ordemMeta = const VerificationMeta('ordem');
  @override
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
    'ordem',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, nome, ordem];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorias';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoriaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('ordem')) {
      context.handle(
        _ordemMeta,
        ordem.isAcceptableOrUnknown(data['ordem']!, _ordemMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriaRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      ordem: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordem'],
      )!,
    );
  }

  @override
  $CategoriasTable createAlias(String alias) {
    return $CategoriasTable(attachedDatabase, alias);
  }
}

class CategoriaRow extends DataClass implements Insertable<CategoriaRow> {
  final int id;
  final String nome;
  final int ordem;
  const CategoriaRow({
    required this.id,
    required this.nome,
    required this.ordem,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['ordem'] = Variable<int>(ordem);
    return map;
  }

  CategoriasCompanion toCompanion(bool nullToAbsent) {
    return CategoriasCompanion(
      id: Value(id),
      nome: Value(nome),
      ordem: Value(ordem),
    );
  }

  factory CategoriaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriaRow(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      ordem: serializer.fromJson<int>(json['ordem']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'ordem': serializer.toJson<int>(ordem),
    };
  }

  CategoriaRow copyWith({int? id, String? nome, int? ordem}) => CategoriaRow(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    ordem: ordem ?? this.ordem,
  );
  CategoriaRow copyWithCompanion(CategoriasCompanion data) {
    return CategoriaRow(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      ordem: data.ordem.present ? data.ordem.value : this.ordem,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriaRow(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('ordem: $ordem')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, ordem);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriaRow &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.ordem == this.ordem);
}

class CategoriasCompanion extends UpdateCompanion<CategoriaRow> {
  final Value<int> id;
  final Value<String> nome;
  final Value<int> ordem;
  const CategoriasCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.ordem = const Value.absent(),
  });
  CategoriasCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    this.ordem = const Value.absent(),
  }) : nome = Value(nome);
  static Insertable<CategoriaRow> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<int>? ordem,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (ordem != null) 'ordem': ordem,
    });
  }

  CategoriasCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<int>? ordem,
  }) {
    return CategoriasCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      ordem: ordem ?? this.ordem,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (ordem.present) {
      map['ordem'] = Variable<int>(ordem.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriasCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('ordem: $ordem')
          ..write(')'))
        .toString();
  }
}

class $LocaisTable extends Locais with TableInfo<$LocaisTable, LocalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocaisTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _fotoPathMeta = const VerificationMeta(
    'fotoPath',
  );
  @override
  late final GeneratedColumn<String> fotoPath = GeneratedColumn<String>(
    'foto_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nome, fotoPath, criadoEm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'locais';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('foto_path')) {
      context.handle(
        _fotoPathMeta,
        fotoPath.isAcceptableOrUnknown(data['foto_path']!, _fotoPathMeta),
      );
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      fotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foto_path'],
      ),
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
    );
  }

  @override
  $LocaisTable createAlias(String alias) {
    return $LocaisTable(attachedDatabase, alias);
  }
}

class LocalRow extends DataClass implements Insertable<LocalRow> {
  final int id;
  final String nome;
  final String? fotoPath;
  final DateTime criadoEm;
  const LocalRow({
    required this.id,
    required this.nome,
    this.fotoPath,
    required this.criadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || fotoPath != null) {
      map['foto_path'] = Variable<String>(fotoPath);
    }
    map['criado_em'] = Variable<DateTime>(criadoEm);
    return map;
  }

  LocaisCompanion toCompanion(bool nullToAbsent) {
    return LocaisCompanion(
      id: Value(id),
      nome: Value(nome),
      fotoPath: fotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(fotoPath),
      criadoEm: Value(criadoEm),
    );
  }

  factory LocalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalRow(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      fotoPath: serializer.fromJson<String?>(json['fotoPath']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'fotoPath': serializer.toJson<String?>(fotoPath),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
    };
  }

  LocalRow copyWith({
    int? id,
    String? nome,
    Value<String?> fotoPath = const Value.absent(),
    DateTime? criadoEm,
  }) => LocalRow(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    fotoPath: fotoPath.present ? fotoPath.value : this.fotoPath,
    criadoEm: criadoEm ?? this.criadoEm,
  );
  LocalRow copyWithCompanion(LocaisCompanion data) {
    return LocalRow(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      fotoPath: data.fotoPath.present ? data.fotoPath.value : this.fotoPath,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalRow(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('fotoPath: $fotoPath, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, fotoPath, criadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalRow &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.fotoPath == this.fotoPath &&
          other.criadoEm == this.criadoEm);
}

class LocaisCompanion extends UpdateCompanion<LocalRow> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String?> fotoPath;
  final Value<DateTime> criadoEm;
  const LocaisCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.fotoPath = const Value.absent(),
    this.criadoEm = const Value.absent(),
  });
  LocaisCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    this.fotoPath = const Value.absent(),
    this.criadoEm = const Value.absent(),
  }) : nome = Value(nome);
  static Insertable<LocalRow> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? fotoPath,
    Expression<DateTime>? criadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (fotoPath != null) 'foto_path': fotoPath,
      if (criadoEm != null) 'criado_em': criadoEm,
    });
  }

  LocaisCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<String?>? fotoPath,
    Value<DateTime>? criadoEm,
  }) {
    return LocaisCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      fotoPath: fotoPath ?? this.fotoPath,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (fotoPath.present) {
      map['foto_path'] = Variable<String>(fotoPath.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocaisCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('fotoPath: $fotoPath, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }
}

class $ObjetosTable extends Objetos with TableInfo<$ObjetosTable, ObjetoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ObjetosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fotoPathMeta = const VerificationMeta(
    'fotoPath',
  );
  @override
  late final GeneratedColumn<String> fotoPath = GeneratedColumn<String>(
    'foto_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<int> localId = GeneratedColumn<int>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locais (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _tamanhoBytesMeta = const VerificationMeta(
    'tamanhoBytes',
  );
  @override
  late final GeneratedColumn<int> tamanhoBytes = GeneratedColumn<int>(
    'tamanho_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _registradoEmMeta = const VerificationMeta(
    'registradoEm',
  );
  @override
  late final GeneratedColumn<DateTime> registradoEm = GeneratedColumn<DateTime>(
    'registrado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _confirmadoEmMeta = const VerificationMeta(
    'confirmadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> confirmadoEm = GeneratedColumn<DateTime>(
    'confirmado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _excluidoEmMeta = const VerificationMeta(
    'excluidoEm',
  );
  @override
  late final GeneratedColumn<DateTime> excluidoEm = GeneratedColumn<DateTime>(
    'excluido_em',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    fotoPath,
    audioPath,
    descricao,
    localId,
    categoriaId,
    tamanhoBytes,
    registradoEm,
    confirmadoEm,
    excluidoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'objetos';
  @override
  VerificationContext validateIntegrity(
    Insertable<ObjetoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('foto_path')) {
      context.handle(
        _fotoPathMeta,
        fotoPath.isAcceptableOrUnknown(data['foto_path']!, _fotoPathMeta),
      );
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    }
    if (data.containsKey('tamanho_bytes')) {
      context.handle(
        _tamanhoBytesMeta,
        tamanhoBytes.isAcceptableOrUnknown(
          data['tamanho_bytes']!,
          _tamanhoBytesMeta,
        ),
      );
    }
    if (data.containsKey('registrado_em')) {
      context.handle(
        _registradoEmMeta,
        registradoEm.isAcceptableOrUnknown(
          data['registrado_em']!,
          _registradoEmMeta,
        ),
      );
    }
    if (data.containsKey('confirmado_em')) {
      context.handle(
        _confirmadoEmMeta,
        confirmadoEm.isAcceptableOrUnknown(
          data['confirmado_em']!,
          _confirmadoEmMeta,
        ),
      );
    }
    if (data.containsKey('excluido_em')) {
      context.handle(
        _excluidoEmMeta,
        excluidoEm.isAcceptableOrUnknown(
          data['excluido_em']!,
          _excluidoEmMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ObjetoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ObjetoRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      fotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foto_path'],
      ),
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      ),
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      ),
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_id'],
      )!,
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_id'],
      ),
      tamanhoBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tamanho_bytes'],
      )!,
      registradoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}registrado_em'],
      )!,
      confirmadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}confirmado_em'],
      )!,
      excluidoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}excluido_em'],
      ),
    );
  }

  @override
  $ObjetosTable createAlias(String alias) {
    return $ObjetosTable(attachedDatabase, alias);
  }
}

class ObjetoRow extends DataClass implements Insertable<ObjetoRow> {
  final int id;
  final String nome;
  final String? fotoPath;
  final String? audioPath;
  final String? descricao;
  final int localId;
  final int? categoriaId;

  /// US14: espaço ocupado pelas mídias.
  final int tamanhoBytes;

  /// US07: data do registro.
  final DateTime registradoEm;

  /// US11: última vez que o usuário confirmou onde o objeto está.
  final DateTime confirmadoEm;

  /// Soft delete do objeto: quando preenchido, o item fica oculto da app.
  final DateTime? excluidoEm;
  const ObjetoRow({
    required this.id,
    required this.nome,
    this.fotoPath,
    this.audioPath,
    this.descricao,
    required this.localId,
    this.categoriaId,
    required this.tamanhoBytes,
    required this.registradoEm,
    required this.confirmadoEm,
    this.excluidoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || fotoPath != null) {
      map['foto_path'] = Variable<String>(fotoPath);
    }
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    if (!nullToAbsent || descricao != null) {
      map['descricao'] = Variable<String>(descricao);
    }
    map['local_id'] = Variable<int>(localId);
    if (!nullToAbsent || categoriaId != null) {
      map['categoria_id'] = Variable<int>(categoriaId);
    }
    map['tamanho_bytes'] = Variable<int>(tamanhoBytes);
    map['registrado_em'] = Variable<DateTime>(registradoEm);
    map['confirmado_em'] = Variable<DateTime>(confirmadoEm);
    if (!nullToAbsent || excluidoEm != null) {
      map['excluido_em'] = Variable<DateTime>(excluidoEm);
    }
    return map;
  }

  ObjetosCompanion toCompanion(bool nullToAbsent) {
    return ObjetosCompanion(
      id: Value(id),
      nome: Value(nome),
      fotoPath: fotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(fotoPath),
      audioPath: audioPath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPath),
      descricao: descricao == null && nullToAbsent
          ? const Value.absent()
          : Value(descricao),
      localId: Value(localId),
      categoriaId: categoriaId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoriaId),
      tamanhoBytes: Value(tamanhoBytes),
      registradoEm: Value(registradoEm),
      confirmadoEm: Value(confirmadoEm),
      excluidoEm: excluidoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(excluidoEm),
    );
  }

  factory ObjetoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ObjetoRow(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      fotoPath: serializer.fromJson<String?>(json['fotoPath']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
      descricao: serializer.fromJson<String?>(json['descricao']),
      localId: serializer.fromJson<int>(json['localId']),
      categoriaId: serializer.fromJson<int?>(json['categoriaId']),
      tamanhoBytes: serializer.fromJson<int>(json['tamanhoBytes']),
      registradoEm: serializer.fromJson<DateTime>(json['registradoEm']),
      confirmadoEm: serializer.fromJson<DateTime>(json['confirmadoEm']),
      excluidoEm: serializer.fromJson<DateTime?>(json['excluidoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'fotoPath': serializer.toJson<String?>(fotoPath),
      'audioPath': serializer.toJson<String?>(audioPath),
      'descricao': serializer.toJson<String?>(descricao),
      'localId': serializer.toJson<int>(localId),
      'categoriaId': serializer.toJson<int?>(categoriaId),
      'tamanhoBytes': serializer.toJson<int>(tamanhoBytes),
      'registradoEm': serializer.toJson<DateTime>(registradoEm),
      'confirmadoEm': serializer.toJson<DateTime>(confirmadoEm),
      'excluidoEm': serializer.toJson<DateTime?>(excluidoEm),
    };
  }

  ObjetoRow copyWith({
    int? id,
    String? nome,
    Value<String?> fotoPath = const Value.absent(),
    Value<String?> audioPath = const Value.absent(),
    Value<String?> descricao = const Value.absent(),
    int? localId,
    Value<int?> categoriaId = const Value.absent(),
    int? tamanhoBytes,
    DateTime? registradoEm,
    DateTime? confirmadoEm,
    Value<DateTime?> excluidoEm = const Value.absent(),
  }) => ObjetoRow(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    fotoPath: fotoPath.present ? fotoPath.value : this.fotoPath,
    audioPath: audioPath.present ? audioPath.value : this.audioPath,
    descricao: descricao.present ? descricao.value : this.descricao,
    localId: localId ?? this.localId,
    categoriaId: categoriaId.present ? categoriaId.value : this.categoriaId,
    tamanhoBytes: tamanhoBytes ?? this.tamanhoBytes,
    registradoEm: registradoEm ?? this.registradoEm,
    confirmadoEm: confirmadoEm ?? this.confirmadoEm,
    excluidoEm: excluidoEm.present ? excluidoEm.value : this.excluidoEm,
  );
  ObjetoRow copyWithCompanion(ObjetosCompanion data) {
    return ObjetoRow(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      fotoPath: data.fotoPath.present ? data.fotoPath.value : this.fotoPath,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      localId: data.localId.present ? data.localId.value : this.localId,
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
      tamanhoBytes: data.tamanhoBytes.present
          ? data.tamanhoBytes.value
          : this.tamanhoBytes,
      registradoEm: data.registradoEm.present
          ? data.registradoEm.value
          : this.registradoEm,
      confirmadoEm: data.confirmadoEm.present
          ? data.confirmadoEm.value
          : this.confirmadoEm,
      excluidoEm: data.excluidoEm.present
          ? data.excluidoEm.value
          : this.excluidoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ObjetoRow(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('fotoPath: $fotoPath, ')
          ..write('audioPath: $audioPath, ')
          ..write('descricao: $descricao, ')
          ..write('localId: $localId, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('tamanhoBytes: $tamanhoBytes, ')
          ..write('registradoEm: $registradoEm, ')
          ..write('confirmadoEm: $confirmadoEm, ')
          ..write('excluidoEm: $excluidoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nome,
    fotoPath,
    audioPath,
    descricao,
    localId,
    categoriaId,
    tamanhoBytes,
    registradoEm,
    confirmadoEm,
    excluidoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ObjetoRow &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.fotoPath == this.fotoPath &&
          other.audioPath == this.audioPath &&
          other.descricao == this.descricao &&
          other.localId == this.localId &&
          other.categoriaId == this.categoriaId &&
          other.tamanhoBytes == this.tamanhoBytes &&
          other.registradoEm == this.registradoEm &&
          other.confirmadoEm == this.confirmadoEm &&
          other.excluidoEm == this.excluidoEm);
}

class ObjetosCompanion extends UpdateCompanion<ObjetoRow> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String?> fotoPath;
  final Value<String?> audioPath;
  final Value<String?> descricao;
  final Value<int> localId;
  final Value<int?> categoriaId;
  final Value<int> tamanhoBytes;
  final Value<DateTime> registradoEm;
  final Value<DateTime> confirmadoEm;
  final Value<DateTime?> excluidoEm;
  const ObjetosCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.fotoPath = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.descricao = const Value.absent(),
    this.localId = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.tamanhoBytes = const Value.absent(),
    this.registradoEm = const Value.absent(),
    this.confirmadoEm = const Value.absent(),
    this.excluidoEm = const Value.absent(),
  });
  ObjetosCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    this.fotoPath = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.descricao = const Value.absent(),
    required int localId,
    this.categoriaId = const Value.absent(),
    this.tamanhoBytes = const Value.absent(),
    this.registradoEm = const Value.absent(),
    this.confirmadoEm = const Value.absent(),
    this.excluidoEm = const Value.absent(),
  }) : nome = Value(nome),
       localId = Value(localId);
  static Insertable<ObjetoRow> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? fotoPath,
    Expression<String>? audioPath,
    Expression<String>? descricao,
    Expression<int>? localId,
    Expression<int>? categoriaId,
    Expression<int>? tamanhoBytes,
    Expression<DateTime>? registradoEm,
    Expression<DateTime>? confirmadoEm,
    Expression<DateTime>? excluidoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (fotoPath != null) 'foto_path': fotoPath,
      if (audioPath != null) 'audio_path': audioPath,
      if (descricao != null) 'descricao': descricao,
      if (localId != null) 'local_id': localId,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (tamanhoBytes != null) 'tamanho_bytes': tamanhoBytes,
      if (registradoEm != null) 'registrado_em': registradoEm,
      if (confirmadoEm != null) 'confirmado_em': confirmadoEm,
      if (excluidoEm != null) 'excluido_em': excluidoEm,
    });
  }

  ObjetosCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<String?>? fotoPath,
    Value<String?>? audioPath,
    Value<String?>? descricao,
    Value<int>? localId,
    Value<int?>? categoriaId,
    Value<int>? tamanhoBytes,
    Value<DateTime>? registradoEm,
    Value<DateTime>? confirmadoEm,
    Value<DateTime?>? excluidoEm,
  }) {
    return ObjetosCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      fotoPath: fotoPath ?? this.fotoPath,
      audioPath: audioPath ?? this.audioPath,
      descricao: descricao ?? this.descricao,
      localId: localId ?? this.localId,
      categoriaId: categoriaId ?? this.categoriaId,
      tamanhoBytes: tamanhoBytes ?? this.tamanhoBytes,
      registradoEm: registradoEm ?? this.registradoEm,
      confirmadoEm: confirmadoEm ?? this.confirmadoEm,
      excluidoEm: excluidoEm ?? this.excluidoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (fotoPath.present) {
      map['foto_path'] = Variable<String>(fotoPath.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    if (tamanhoBytes.present) {
      map['tamanho_bytes'] = Variable<int>(tamanhoBytes.value);
    }
    if (registradoEm.present) {
      map['registrado_em'] = Variable<DateTime>(registradoEm.value);
    }
    if (confirmadoEm.present) {
      map['confirmado_em'] = Variable<DateTime>(confirmadoEm.value);
    }
    if (excluidoEm.present) {
      map['excluido_em'] = Variable<DateTime>(excluidoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ObjetosCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('fotoPath: $fotoPath, ')
          ..write('audioPath: $audioPath, ')
          ..write('descricao: $descricao, ')
          ..write('localId: $localId, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('tamanhoBytes: $tamanhoBytes, ')
          ..write('registradoEm: $registradoEm, ')
          ..write('confirmadoEm: $confirmadoEm, ')
          ..write('excluidoEm: $excluidoEm')
          ..write(')'))
        .toString();
  }
}

class $HistoricoLocalTable extends HistoricoLocal
    with TableInfo<$HistoricoLocalTable, HistoricoLocalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoricoLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _objetoIdMeta = const VerificationMeta(
    'objetoId',
  );
  @override
  late final GeneratedColumn<int> objetoId = GeneratedColumn<int>(
    'objeto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES objetos (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _localAntigoIdMeta = const VerificationMeta(
    'localAntigoId',
  );
  @override
  late final GeneratedColumn<int> localAntigoId = GeneratedColumn<int>(
    'local_antigo_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locais (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _localNovoIdMeta = const VerificationMeta(
    'localNovoId',
  );
  @override
  late final GeneratedColumn<int> localNovoId = GeneratedColumn<int>(
    'local_novo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locais (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _alteradoEmMeta = const VerificationMeta(
    'alteradoEm',
  );
  @override
  late final GeneratedColumn<DateTime> alteradoEm = GeneratedColumn<DateTime>(
    'alterado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    objetoId,
    localAntigoId,
    localNovoId,
    alteradoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'historico_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistoricoLocalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('objeto_id')) {
      context.handle(
        _objetoIdMeta,
        objetoId.isAcceptableOrUnknown(data['objeto_id']!, _objetoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_objetoIdMeta);
    }
    if (data.containsKey('local_antigo_id')) {
      context.handle(
        _localAntigoIdMeta,
        localAntigoId.isAcceptableOrUnknown(
          data['local_antigo_id']!,
          _localAntigoIdMeta,
        ),
      );
    }
    if (data.containsKey('local_novo_id')) {
      context.handle(
        _localNovoIdMeta,
        localNovoId.isAcceptableOrUnknown(
          data['local_novo_id']!,
          _localNovoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localNovoIdMeta);
    }
    if (data.containsKey('alterado_em')) {
      context.handle(
        _alteradoEmMeta,
        alteradoEm.isAcceptableOrUnknown(data['alterado_em']!, _alteradoEmMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistoricoLocalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoricoLocalRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      objetoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}objeto_id'],
      )!,
      localAntigoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_antigo_id'],
      ),
      localNovoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_novo_id'],
      )!,
      alteradoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}alterado_em'],
      )!,
    );
  }

  @override
  $HistoricoLocalTable createAlias(String alias) {
    return $HistoricoLocalTable(attachedDatabase, alias);
  }
}

class HistoricoLocalRow extends DataClass
    implements Insertable<HistoricoLocalRow> {
  final int id;
  final int objetoId;
  final int? localAntigoId;
  final int localNovoId;
  final DateTime alteradoEm;
  const HistoricoLocalRow({
    required this.id,
    required this.objetoId,
    this.localAntigoId,
    required this.localNovoId,
    required this.alteradoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['objeto_id'] = Variable<int>(objetoId);
    if (!nullToAbsent || localAntigoId != null) {
      map['local_antigo_id'] = Variable<int>(localAntigoId);
    }
    map['local_novo_id'] = Variable<int>(localNovoId);
    map['alterado_em'] = Variable<DateTime>(alteradoEm);
    return map;
  }

  HistoricoLocalCompanion toCompanion(bool nullToAbsent) {
    return HistoricoLocalCompanion(
      id: Value(id),
      objetoId: Value(objetoId),
      localAntigoId: localAntigoId == null && nullToAbsent
          ? const Value.absent()
          : Value(localAntigoId),
      localNovoId: Value(localNovoId),
      alteradoEm: Value(alteradoEm),
    );
  }

  factory HistoricoLocalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoricoLocalRow(
      id: serializer.fromJson<int>(json['id']),
      objetoId: serializer.fromJson<int>(json['objetoId']),
      localAntigoId: serializer.fromJson<int?>(json['localAntigoId']),
      localNovoId: serializer.fromJson<int>(json['localNovoId']),
      alteradoEm: serializer.fromJson<DateTime>(json['alteradoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'objetoId': serializer.toJson<int>(objetoId),
      'localAntigoId': serializer.toJson<int?>(localAntigoId),
      'localNovoId': serializer.toJson<int>(localNovoId),
      'alteradoEm': serializer.toJson<DateTime>(alteradoEm),
    };
  }

  HistoricoLocalRow copyWith({
    int? id,
    int? objetoId,
    Value<int?> localAntigoId = const Value.absent(),
    int? localNovoId,
    DateTime? alteradoEm,
  }) => HistoricoLocalRow(
    id: id ?? this.id,
    objetoId: objetoId ?? this.objetoId,
    localAntigoId: localAntigoId.present
        ? localAntigoId.value
        : this.localAntigoId,
    localNovoId: localNovoId ?? this.localNovoId,
    alteradoEm: alteradoEm ?? this.alteradoEm,
  );
  HistoricoLocalRow copyWithCompanion(HistoricoLocalCompanion data) {
    return HistoricoLocalRow(
      id: data.id.present ? data.id.value : this.id,
      objetoId: data.objetoId.present ? data.objetoId.value : this.objetoId,
      localAntigoId: data.localAntigoId.present
          ? data.localAntigoId.value
          : this.localAntigoId,
      localNovoId: data.localNovoId.present
          ? data.localNovoId.value
          : this.localNovoId,
      alteradoEm: data.alteradoEm.present
          ? data.alteradoEm.value
          : this.alteradoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoricoLocalRow(')
          ..write('id: $id, ')
          ..write('objetoId: $objetoId, ')
          ..write('localAntigoId: $localAntigoId, ')
          ..write('localNovoId: $localNovoId, ')
          ..write('alteradoEm: $alteradoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, objetoId, localAntigoId, localNovoId, alteradoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoricoLocalRow &&
          other.id == this.id &&
          other.objetoId == this.objetoId &&
          other.localAntigoId == this.localAntigoId &&
          other.localNovoId == this.localNovoId &&
          other.alteradoEm == this.alteradoEm);
}

class HistoricoLocalCompanion extends UpdateCompanion<HistoricoLocalRow> {
  final Value<int> id;
  final Value<int> objetoId;
  final Value<int?> localAntigoId;
  final Value<int> localNovoId;
  final Value<DateTime> alteradoEm;
  const HistoricoLocalCompanion({
    this.id = const Value.absent(),
    this.objetoId = const Value.absent(),
    this.localAntigoId = const Value.absent(),
    this.localNovoId = const Value.absent(),
    this.alteradoEm = const Value.absent(),
  });
  HistoricoLocalCompanion.insert({
    this.id = const Value.absent(),
    required int objetoId,
    this.localAntigoId = const Value.absent(),
    required int localNovoId,
    this.alteradoEm = const Value.absent(),
  }) : objetoId = Value(objetoId),
       localNovoId = Value(localNovoId);
  static Insertable<HistoricoLocalRow> custom({
    Expression<int>? id,
    Expression<int>? objetoId,
    Expression<int>? localAntigoId,
    Expression<int>? localNovoId,
    Expression<DateTime>? alteradoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (objetoId != null) 'objeto_id': objetoId,
      if (localAntigoId != null) 'local_antigo_id': localAntigoId,
      if (localNovoId != null) 'local_novo_id': localNovoId,
      if (alteradoEm != null) 'alterado_em': alteradoEm,
    });
  }

  HistoricoLocalCompanion copyWith({
    Value<int>? id,
    Value<int>? objetoId,
    Value<int?>? localAntigoId,
    Value<int>? localNovoId,
    Value<DateTime>? alteradoEm,
  }) {
    return HistoricoLocalCompanion(
      id: id ?? this.id,
      objetoId: objetoId ?? this.objetoId,
      localAntigoId: localAntigoId ?? this.localAntigoId,
      localNovoId: localNovoId ?? this.localNovoId,
      alteradoEm: alteradoEm ?? this.alteradoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (objetoId.present) {
      map['objeto_id'] = Variable<int>(objetoId.value);
    }
    if (localAntigoId.present) {
      map['local_antigo_id'] = Variable<int>(localAntigoId.value);
    }
    if (localNovoId.present) {
      map['local_novo_id'] = Variable<int>(localNovoId.value);
    }
    if (alteradoEm.present) {
      map['alterado_em'] = Variable<DateTime>(alteradoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoricoLocalCompanion(')
          ..write('id: $id, ')
          ..write('objetoId: $objetoId, ')
          ..write('localAntigoId: $localAntigoId, ')
          ..write('localNovoId: $localNovoId, ')
          ..write('alteradoEm: $alteradoEm')
          ..write(')'))
        .toString();
  }
}

abstract class _$CadeDatabase extends GeneratedDatabase {
  _$CadeDatabase(QueryExecutor e) : super(e);
  $CadeDatabaseManager get managers => $CadeDatabaseManager(this);
  late final $CategoriasTable categorias = $CategoriasTable(this);
  late final $LocaisTable locais = $LocaisTable(this);
  late final $ObjetosTable objetos = $ObjetosTable(this);
  late final $HistoricoLocalTable historicoLocal = $HistoricoLocalTable(this);
  late final Index idxObjetosNome = Index(
    'idx_objetos_nome',
    'CREATE INDEX idx_objetos_nome ON objetos (nome)',
  );
  late final Index idxObjetosLocal = Index(
    'idx_objetos_local',
    'CREATE INDEX idx_objetos_local ON objetos (local_id)',
  );
  late final Index idxObjetosCategoria = Index(
    'idx_objetos_categoria',
    'CREATE INDEX idx_objetos_categoria ON objetos (categoria_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categorias,
    locais,
    objetos,
    historicoLocal,
    idxObjetosNome,
    idxObjetosLocal,
    idxObjetosCategoria,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categorias',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('objetos', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'objetos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('historico_local', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'locais',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('historico_local', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$CategoriasTableCreateCompanionBuilder = CategoriasCompanion Function({
  Value<int> id,
  required String nome,
  Value<int> ordem,
});
typedef $$CategoriasTableUpdateCompanionBuilder = CategoriasCompanion Function({
  Value<int> id,
  Value<String> nome,
  Value<int> ordem,
});

final class $$CategoriasTableReferences
    extends BaseReferences<_$CadeDatabase, $CategoriasTable, CategoriaRow> {
  $$CategoriasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ObjetosTable, List<ObjetoRow>> _objetosRefsTable(
    _$CadeDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.objetos,
    aliasName: 'categorias__id__objetos__categoria_id',
  );

  $$ObjetosTableProcessedTableManager get objetosRefs {
    final manager = $$ObjetosTableTableManager(
      $_db,
      $_db.objetos,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_objetosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriasTableFilterComposer
    extends Composer<_$CadeDatabase, $CategoriasTable> {
  $$CategoriasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> objetosRefs(
    Expression<bool> Function($$ObjetosTableFilterComposer f) f,
  ) {
    final $$ObjetosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.objetos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObjetosTableFilterComposer(
            $db: $db,
            $table: $db.objetos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasTableOrderingComposer
    extends Composer<_$CadeDatabase, $CategoriasTable> {
  $$CategoriasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriasTableAnnotationComposer
    extends Composer<_$CadeDatabase, $CategoriasTable> {
  $$CategoriasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<int> get ordem =>
      $composableBuilder(column: $table.ordem, builder: (column) => column);

  Expression<T> objetosRefs<T extends Object>(
    Expression<T> Function($$ObjetosTableAnnotationComposer a) f,
  ) {
    final $$ObjetosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.objetos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObjetosTableAnnotationComposer(
            $db: $db,
            $table: $db.objetos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasTableTableManager
    extends
        RootTableManager<
          _$CadeDatabase,
          $CategoriasTable,
          CategoriaRow,
          $$CategoriasTableFilterComposer,
          $$CategoriasTableOrderingComposer,
          $$CategoriasTableAnnotationComposer,
          $$CategoriasTableCreateCompanionBuilder,
          $$CategoriasTableUpdateCompanionBuilder,
          (CategoriaRow, $$CategoriasTableReferences),
          CategoriaRow,
          PrefetchHooks Function({bool objetosRefs})
        > {
  $$CategoriasTableTableManager(_$CadeDatabase db, $CategoriasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<int> ordem = const Value.absent(),
          }) => CategoriasCompanion(id: id, nome: nome, ordem: ordem),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nome,
            Value<int> ordem = const Value.absent(),
          }) => CategoriasCompanion.insert(id: id, nome: nome, ordem: ordem),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriasTable, CategoriaRow>(table),
                  $$CategoriasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({objetosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (objetosRefs) db.objetos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (objetosRefs)
                    await $_getPrefetchedDataByColumns<
                      CategoriaRow,
                      $CategoriasTable,
                      ObjetoRow,
                      $ObjetosTable
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriasTableReferences
                          ._objetosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriasTableReferences(
                            db,
                            table,
                            p0,
                          ).objetosRefs,
                      currentColumn: 'id',
                      referencedColumn: 'categoria_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriasTableProcessedTableManager =
    ProcessedTableManager<
      _$CadeDatabase,
      $CategoriasTable,
      CategoriaRow,
      $$CategoriasTableFilterComposer,
      $$CategoriasTableOrderingComposer,
      $$CategoriasTableAnnotationComposer,
      $$CategoriasTableCreateCompanionBuilder,
      $$CategoriasTableUpdateCompanionBuilder,
      (CategoriaRow, $$CategoriasTableReferences),
      CategoriaRow,
      PrefetchHooks Function({bool objetosRefs})
    >;
typedef $$LocaisTableCreateCompanionBuilder = LocaisCompanion Function({
  Value<int> id,
  required String nome,
  Value<String?> fotoPath,
  Value<DateTime> criadoEm,
});
typedef $$LocaisTableUpdateCompanionBuilder = LocaisCompanion Function({
  Value<int> id,
  Value<String> nome,
  Value<String?> fotoPath,
  Value<DateTime> criadoEm,
});

final class $$LocaisTableReferences
    extends BaseReferences<_$CadeDatabase, $LocaisTable, LocalRow> {
  $$LocaisTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ObjetosTable, List<ObjetoRow>> _objetosRefsTable(
    _$CadeDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.objetos,
    aliasName: 'locais__id__objetos__local_id',
  );

  $$ObjetosTableProcessedTableManager get objetosRefs {
    final manager = $$ObjetosTableTableManager(
      $_db,
      $_db.objetos,
    ).filter((f) => f.localId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_objetosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocaisTableFilterComposer
    extends Composer<_$CadeDatabase, $LocaisTable> {
  $$LocaisTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fotoPath => $composableBuilder(
    column: $table.fotoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> objetosRefs(
    Expression<bool> Function($$ObjetosTableFilterComposer f) f,
  ) {
    final $$ObjetosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.objetos,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObjetosTableFilterComposer(
            $db: $db,
            $table: $db.objetos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocaisTableOrderingComposer
    extends Composer<_$CadeDatabase, $LocaisTable> {
  $$LocaisTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fotoPath => $composableBuilder(
    column: $table.fotoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocaisTableAnnotationComposer
    extends Composer<_$CadeDatabase, $LocaisTable> {
  $$LocaisTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get fotoPath =>
      $composableBuilder(column: $table.fotoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  Expression<T> objetosRefs<T extends Object>(
    Expression<T> Function($$ObjetosTableAnnotationComposer a) f,
  ) {
    final $$ObjetosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.objetos,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObjetosTableAnnotationComposer(
            $db: $db,
            $table: $db.objetos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocaisTableTableManager
    extends
        RootTableManager<
          _$CadeDatabase,
          $LocaisTable,
          LocalRow,
          $$LocaisTableFilterComposer,
          $$LocaisTableOrderingComposer,
          $$LocaisTableAnnotationComposer,
          $$LocaisTableCreateCompanionBuilder,
          $$LocaisTableUpdateCompanionBuilder,
          (LocalRow, $$LocaisTableReferences),
          LocalRow,
          PrefetchHooks Function({bool objetosRefs})
        > {
  $$LocaisTableTableManager(_$CadeDatabase db, $LocaisTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocaisTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocaisTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocaisTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String?> fotoPath = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
              }) => LocaisCompanion(
                id: id,
                nome: nome,
                fotoPath: fotoPath,
                criadoEm: criadoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                Value<String?> fotoPath = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
              }) => LocaisCompanion.insert(
                id: id,
                nome: nome,
                fotoPath: fotoPath,
                criadoEm: criadoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocaisTable, LocalRow>(table),
                  $$LocaisTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({objetosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (objetosRefs) db.objetos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (objetosRefs)
                    await $_getPrefetchedDataByColumns<
                      LocalRow,
                      $LocaisTable,
                      ObjetoRow,
                      $ObjetosTable
                    >(
                      currentTable: table,
                      referencedTable: $$LocaisTableReferences
                          ._objetosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LocaisTableReferences(db, table, p0).objetosRefs,
                      currentColumn: 'id',
                      referencedColumn: 'local_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LocaisTableProcessedTableManager =
    ProcessedTableManager<
      _$CadeDatabase,
      $LocaisTable,
      LocalRow,
      $$LocaisTableFilterComposer,
      $$LocaisTableOrderingComposer,
      $$LocaisTableAnnotationComposer,
      $$LocaisTableCreateCompanionBuilder,
      $$LocaisTableUpdateCompanionBuilder,
      (LocalRow, $$LocaisTableReferences),
      LocalRow,
      PrefetchHooks Function({bool objetosRefs})
    >;
typedef $$ObjetosTableCreateCompanionBuilder = ObjetosCompanion Function({
  Value<int> id,
  required String nome,
  Value<String?> fotoPath,
  Value<String?> audioPath,
  Value<String?> descricao,
  required int localId,
  Value<int?> categoriaId,
  Value<int> tamanhoBytes,
  Value<DateTime> registradoEm,
  Value<DateTime> confirmadoEm,
});
typedef $$ObjetosTableUpdateCompanionBuilder = ObjetosCompanion Function({
  Value<int> id,
  Value<String> nome,
  Value<String?> fotoPath,
  Value<String?> audioPath,
  Value<String?> descricao,
  Value<int> localId,
  Value<int?> categoriaId,
  Value<int> tamanhoBytes,
  Value<DateTime> registradoEm,
  Value<DateTime> confirmadoEm,
});

final class $$ObjetosTableReferences
    extends BaseReferences<_$CadeDatabase, $ObjetosTable, ObjetoRow> {
  $$ObjetosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LocaisTable _localIdTable(_$CadeDatabase db) =>
      db.locais.createAlias('objetos__local_id__locais__id');

  $$LocaisTableProcessedTableManager get localId {
    final $_column = $_itemColumn<int>('local_id')!;

    final manager = $$LocaisTableTableManager(
      $_db,
      $_db.locais,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_localIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriasTable _categoriaIdTable(_$CadeDatabase db) =>
      db.categorias.createAlias('objetos__categoria_id__categorias__id');

  $$CategoriasTableProcessedTableManager? get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id');
    if ($_column == null) return null;
    final manager = $$CategoriasTableTableManager(
      $_db,
      $_db.categorias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$HistoricoLocalTable, List<HistoricoLocalRow>>
  _historicoLocalRefsTable(_$CadeDatabase db) => MultiTypedResultKey.fromTable(
    db.historicoLocal,
    aliasName: 'objetos__id__historico_local__objeto_id',
  );

  $$HistoricoLocalTableProcessedTableManager get historicoLocalRefs {
    final manager = $$HistoricoLocalTableTableManager(
      $_db,
      $_db.historicoLocal,
    ).filter((f) => f.objetoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_historicoLocalRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ObjetosTableFilterComposer
    extends Composer<_$CadeDatabase, $ObjetosTable> {
  $$ObjetosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fotoPath => $composableBuilder(
    column: $table.fotoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tamanhoBytes => $composableBuilder(
    column: $table.tamanhoBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get registradoEm => $composableBuilder(
    column: $table.registradoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get confirmadoEm => $composableBuilder(
    column: $table.confirmadoEm,
    builder: (column) => ColumnFilters(column),
  );

  $$LocaisTableFilterComposer get localId {
    final $$LocaisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocaisTableFilterComposer(
            $db: $db,
            $table: $db.locais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableFilterComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> historicoLocalRefs(
    Expression<bool> Function($$HistoricoLocalTableFilterComposer f) f,
  ) {
    final $$HistoricoLocalTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.historicoLocal,
      getReferencedColumn: (t) => t.objetoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HistoricoLocalTableFilterComposer(
            $db: $db,
            $table: $db.historicoLocal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ObjetosTableOrderingComposer
    extends Composer<_$CadeDatabase, $ObjetosTable> {
  $$ObjetosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fotoPath => $composableBuilder(
    column: $table.fotoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tamanhoBytes => $composableBuilder(
    column: $table.tamanhoBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get registradoEm => $composableBuilder(
    column: $table.registradoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get confirmadoEm => $composableBuilder(
    column: $table.confirmadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocaisTableOrderingComposer get localId {
    final $$LocaisTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocaisTableOrderingComposer(
            $db: $db,
            $table: $db.locais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableOrderingComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ObjetosTableAnnotationComposer
    extends Composer<_$CadeDatabase, $ObjetosTable> {
  $$ObjetosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get fotoPath =>
      $composableBuilder(column: $table.fotoPath, builder: (column) => column);

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumn<int> get tamanhoBytes => $composableBuilder(
    column: $table.tamanhoBytes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get registradoEm => $composableBuilder(
    column: $table.registradoEm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get confirmadoEm => $composableBuilder(
    column: $table.confirmadoEm,
    builder: (column) => column,
  );

  $$LocaisTableAnnotationComposer get localId {
    final $$LocaisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocaisTableAnnotationComposer(
            $db: $db,
            $table: $db.locais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> historicoLocalRefs<T extends Object>(
    Expression<T> Function($$HistoricoLocalTableAnnotationComposer a) f,
  ) {
    final $$HistoricoLocalTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.historicoLocal,
      getReferencedColumn: (t) => t.objetoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HistoricoLocalTableAnnotationComposer(
            $db: $db,
            $table: $db.historicoLocal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ObjetosTableTableManager
    extends
        RootTableManager<
          _$CadeDatabase,
          $ObjetosTable,
          ObjetoRow,
          $$ObjetosTableFilterComposer,
          $$ObjetosTableOrderingComposer,
          $$ObjetosTableAnnotationComposer,
          $$ObjetosTableCreateCompanionBuilder,
          $$ObjetosTableUpdateCompanionBuilder,
          (ObjetoRow, $$ObjetosTableReferences),
          ObjetoRow,
          PrefetchHooks Function({
            bool localId,
            bool categoriaId,
            bool historicoLocalRefs,
          })
        > {
  $$ObjetosTableTableManager(_$CadeDatabase db, $ObjetosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ObjetosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ObjetosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ObjetosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String?> fotoPath = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                Value<String?> descricao = const Value.absent(),
                Value<int> localId = const Value.absent(),
                Value<int?> categoriaId = const Value.absent(),
                Value<int> tamanhoBytes = const Value.absent(),
                Value<DateTime> registradoEm = const Value.absent(),
                Value<DateTime> confirmadoEm = const Value.absent(),
              }) => ObjetosCompanion(
                id: id,
                nome: nome,
                fotoPath: fotoPath,
                audioPath: audioPath,
                descricao: descricao,
                localId: localId,
                categoriaId: categoriaId,
                tamanhoBytes: tamanhoBytes,
                registradoEm: registradoEm,
                confirmadoEm: confirmadoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                Value<String?> fotoPath = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                Value<String?> descricao = const Value.absent(),
                required int localId,
                Value<int?> categoriaId = const Value.absent(),
                Value<int> tamanhoBytes = const Value.absent(),
                Value<DateTime> registradoEm = const Value.absent(),
                Value<DateTime> confirmadoEm = const Value.absent(),
              }) => ObjetosCompanion.insert(
                id: id,
                nome: nome,
                fotoPath: fotoPath,
                audioPath: audioPath,
                descricao: descricao,
                localId: localId,
                categoriaId: categoriaId,
                tamanhoBytes: tamanhoBytes,
                registradoEm: registradoEm,
                confirmadoEm: confirmadoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ObjetosTable, ObjetoRow>(table),
                  $$ObjetosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                localId = false,
                categoriaId = false,
                historicoLocalRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (historicoLocalRefs) db.historicoLocal,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (localId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.localId,
                            referencedTable: $$ObjetosTableReferences
                                ._localIdTable(db),
                            referencedColumn: $$ObjetosTableReferences
                                ._localIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (categoriaId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoriaId,
                            referencedTable: $$ObjetosTableReferences
                                ._categoriaIdTable(db),
                            referencedColumn: $$ObjetosTableReferences
                                ._categoriaIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (historicoLocalRefs)
                        await $_getPrefetchedDataByColumns<
                          ObjetoRow,
                          $ObjetosTable,
                          HistoricoLocalRow,
                          $HistoricoLocalTable
                        >(
                          currentTable: table,
                          referencedTable: $$ObjetosTableReferences
                              ._historicoLocalRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ObjetosTableReferences(
                                db,
                                table,
                                p0,
                              ).historicoLocalRefs,
                          currentColumn: 'id',
                          referencedColumn: 'objeto_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ObjetosTableProcessedTableManager =
    ProcessedTableManager<
      _$CadeDatabase,
      $ObjetosTable,
      ObjetoRow,
      $$ObjetosTableFilterComposer,
      $$ObjetosTableOrderingComposer,
      $$ObjetosTableAnnotationComposer,
      $$ObjetosTableCreateCompanionBuilder,
      $$ObjetosTableUpdateCompanionBuilder,
      (ObjetoRow, $$ObjetosTableReferences),
      ObjetoRow,
      PrefetchHooks Function({
        bool localId,
        bool categoriaId,
        bool historicoLocalRefs,
      })
    >;
typedef $$HistoricoLocalTableCreateCompanionBuilder =
    HistoricoLocalCompanion Function({
      Value<int> id,
      required int objetoId,
      Value<int?> localAntigoId,
      required int localNovoId,
      Value<DateTime> alteradoEm,
    });
typedef $$HistoricoLocalTableUpdateCompanionBuilder =
    HistoricoLocalCompanion Function({
      Value<int> id,
      Value<int> objetoId,
      Value<int?> localAntigoId,
      Value<int> localNovoId,
      Value<DateTime> alteradoEm,
    });

final class $$HistoricoLocalTableReferences
    extends
        BaseReferences<
          _$CadeDatabase,
          $HistoricoLocalTable,
          HistoricoLocalRow
        > {
  $$HistoricoLocalTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ObjetosTable _objetoIdTable(_$CadeDatabase db) =>
      db.objetos.createAlias('historico_local__objeto_id__objetos__id');

  $$ObjetosTableProcessedTableManager get objetoId {
    final $_column = $_itemColumn<int>('objeto_id')!;

    final manager = $$ObjetosTableTableManager(
      $_db,
      $_db.objetos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_objetoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocaisTable _localAntigoIdTable(_$CadeDatabase db) =>
      db.locais.createAlias('historico_local__local_antigo_id__locais__id');

  $$LocaisTableProcessedTableManager? get localAntigoId {
    final $_column = $_itemColumn<int>('local_antigo_id');
    if ($_column == null) return null;
    final manager = $$LocaisTableTableManager(
      $_db,
      $_db.locais,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_localAntigoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocaisTable _localNovoIdTable(_$CadeDatabase db) =>
      db.locais.createAlias('historico_local__local_novo_id__locais__id');

  $$LocaisTableProcessedTableManager get localNovoId {
    final $_column = $_itemColumn<int>('local_novo_id')!;

    final manager = $$LocaisTableTableManager(
      $_db,
      $_db.locais,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_localNovoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HistoricoLocalTableFilterComposer
    extends Composer<_$CadeDatabase, $HistoricoLocalTable> {
  $$HistoricoLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get alteradoEm => $composableBuilder(
    column: $table.alteradoEm,
    builder: (column) => ColumnFilters(column),
  );

  $$ObjetosTableFilterComposer get objetoId {
    final $$ObjetosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.objetoId,
      referencedTable: $db.objetos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObjetosTableFilterComposer(
            $db: $db,
            $table: $db.objetos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocaisTableFilterComposer get localAntigoId {
    final $$LocaisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localAntigoId,
      referencedTable: $db.locais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocaisTableFilterComposer(
            $db: $db,
            $table: $db.locais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocaisTableFilterComposer get localNovoId {
    final $$LocaisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localNovoId,
      referencedTable: $db.locais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocaisTableFilterComposer(
            $db: $db,
            $table: $db.locais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HistoricoLocalTableOrderingComposer
    extends Composer<_$CadeDatabase, $HistoricoLocalTable> {
  $$HistoricoLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get alteradoEm => $composableBuilder(
    column: $table.alteradoEm,
    builder: (column) => ColumnOrderings(column),
  );

  $$ObjetosTableOrderingComposer get objetoId {
    final $$ObjetosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.objetoId,
      referencedTable: $db.objetos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObjetosTableOrderingComposer(
            $db: $db,
            $table: $db.objetos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocaisTableOrderingComposer get localAntigoId {
    final $$LocaisTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localAntigoId,
      referencedTable: $db.locais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocaisTableOrderingComposer(
            $db: $db,
            $table: $db.locais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocaisTableOrderingComposer get localNovoId {
    final $$LocaisTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localNovoId,
      referencedTable: $db.locais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocaisTableOrderingComposer(
            $db: $db,
            $table: $db.locais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HistoricoLocalTableAnnotationComposer
    extends Composer<_$CadeDatabase, $HistoricoLocalTable> {
  $$HistoricoLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get alteradoEm => $composableBuilder(
    column: $table.alteradoEm,
    builder: (column) => column,
  );

  $$ObjetosTableAnnotationComposer get objetoId {
    final $$ObjetosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.objetoId,
      referencedTable: $db.objetos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObjetosTableAnnotationComposer(
            $db: $db,
            $table: $db.objetos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocaisTableAnnotationComposer get localAntigoId {
    final $$LocaisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localAntigoId,
      referencedTable: $db.locais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocaisTableAnnotationComposer(
            $db: $db,
            $table: $db.locais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocaisTableAnnotationComposer get localNovoId {
    final $$LocaisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localNovoId,
      referencedTable: $db.locais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocaisTableAnnotationComposer(
            $db: $db,
            $table: $db.locais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HistoricoLocalTableTableManager
    extends
        RootTableManager<
          _$CadeDatabase,
          $HistoricoLocalTable,
          HistoricoLocalRow,
          $$HistoricoLocalTableFilterComposer,
          $$HistoricoLocalTableOrderingComposer,
          $$HistoricoLocalTableAnnotationComposer,
          $$HistoricoLocalTableCreateCompanionBuilder,
          $$HistoricoLocalTableUpdateCompanionBuilder,
          (HistoricoLocalRow, $$HistoricoLocalTableReferences),
          HistoricoLocalRow,
          PrefetchHooks Function({
            bool objetoId,
            bool localAntigoId,
            bool localNovoId,
          })
        > {
  $$HistoricoLocalTableTableManager(
    _$CadeDatabase db,
    $HistoricoLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoricoLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoricoLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistoricoLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> objetoId = const Value.absent(),
                Value<int?> localAntigoId = const Value.absent(),
                Value<int> localNovoId = const Value.absent(),
                Value<DateTime> alteradoEm = const Value.absent(),
              }) => HistoricoLocalCompanion(
                id: id,
                objetoId: objetoId,
                localAntigoId: localAntigoId,
                localNovoId: localNovoId,
                alteradoEm: alteradoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int objetoId,
                Value<int?> localAntigoId = const Value.absent(),
                required int localNovoId,
                Value<DateTime> alteradoEm = const Value.absent(),
              }) => HistoricoLocalCompanion.insert(
                id: id,
                objetoId: objetoId,
                localAntigoId: localAntigoId,
                localNovoId: localNovoId,
                alteradoEm: alteradoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HistoricoLocalTable, HistoricoLocalRow>(table),
                  $$HistoricoLocalTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({objetoId = false, localAntigoId = false, localNovoId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (objetoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.objetoId,
                            referencedTable: $$HistoricoLocalTableReferences
                                ._objetoIdTable(db),
                            referencedColumn: $$HistoricoLocalTableReferences
                                ._objetoIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (localAntigoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.localAntigoId,
                            referencedTable: $$HistoricoLocalTableReferences
                                ._localAntigoIdTable(db),
                            referencedColumn: $$HistoricoLocalTableReferences
                                ._localAntigoIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (localNovoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.localNovoId,
                            referencedTable: $$HistoricoLocalTableReferences
                                ._localNovoIdTable(db),
                            referencedColumn: $$HistoricoLocalTableReferences
                                ._localNovoIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$HistoricoLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$CadeDatabase,
      $HistoricoLocalTable,
      HistoricoLocalRow,
      $$HistoricoLocalTableFilterComposer,
      $$HistoricoLocalTableOrderingComposer,
      $$HistoricoLocalTableAnnotationComposer,
      $$HistoricoLocalTableCreateCompanionBuilder,
      $$HistoricoLocalTableUpdateCompanionBuilder,
      (HistoricoLocalRow, $$HistoricoLocalTableReferences),
      HistoricoLocalRow,
      PrefetchHooks Function({
        bool objetoId,
        bool localAntigoId,
        bool localNovoId,
      })
    >;

class $CadeDatabaseManager {
  final _$CadeDatabase _db;
  $CadeDatabaseManager(this._db);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db, _db.categorias);
  $$LocaisTableTableManager get locais =>
      $$LocaisTableTableManager(_db, _db.locais);
  $$ObjetosTableTableManager get objetos =>
      $$ObjetosTableTableManager(_db, _db.objetos);
  $$HistoricoLocalTableTableManager get historicoLocal =>
      $$HistoricoLocalTableTableManager(_db, _db.historicoLocal);
}
