// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TeamsTable extends Teams with TableInfo<$TeamsTable, Team> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeamsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 6,
      maxTextLength: 9,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, colorHex, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'teams';
  @override
  VerificationContext validateIntegrity(
    Insertable<Team> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Team map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Team(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TeamsTable createAlias(String alias) {
    return $TeamsTable(attachedDatabase, alias);
  }
}

class Team extends DataClass implements Insertable<Team> {
  final int id;
  final String name;
  final String? colorHex;
  final DateTime createdAt;
  const Team({
    required this.id,
    required this.name,
    this.colorHex,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || colorHex != null) {
      map['color_hex'] = Variable<String>(colorHex);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TeamsCompanion toCompanion(bool nullToAbsent) {
    return TeamsCompanion(
      id: Value(id),
      name: Value(name),
      colorHex: colorHex == null && nullToAbsent
          ? const Value.absent()
          : Value(colorHex),
      createdAt: Value(createdAt),
    );
  }

  factory Team.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Team(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorHex: serializer.fromJson<String?>(json['colorHex']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'colorHex': serializer.toJson<String?>(colorHex),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Team copyWith({
    int? id,
    String? name,
    Value<String?> colorHex = const Value.absent(),
    DateTime? createdAt,
  }) => Team(
    id: id ?? this.id,
    name: name ?? this.name,
    colorHex: colorHex.present ? colorHex.value : this.colorHex,
    createdAt: createdAt ?? this.createdAt,
  );
  Team copyWithCompanion(TeamsCompanion data) {
    return Team(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Team(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorHex, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Team &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorHex == this.colorHex &&
          other.createdAt == this.createdAt);
}

class TeamsCompanion extends UpdateCompanion<Team> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> colorHex;
  final Value<DateTime> createdAt;
  const TeamsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TeamsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.colorHex = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Team> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? colorHex,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorHex != null) 'color_hex': colorHex,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TeamsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? colorHex,
    Value<DateTime>? createdAt,
  }) {
    return TeamsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeamsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PlayersTable extends Players with TableInfo<$PlayersTable, Player> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _primaryNumberMeta = const VerificationMeta(
    'primaryNumber',
  );
  @override
  late final GeneratedColumn<int> primaryNumber = GeneratedColumn<int>(
    'primary_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<int> teamId = GeneratedColumn<int>(
    'team_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id)',
    ),
  );
  static const VerificationMeta _preferredPositionsMeta =
      const VerificationMeta('preferredPositions');
  @override
  late final GeneratedColumn<String> preferredPositions =
      GeneratedColumn<String>(
        'preferred_positions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _dobMeta = const VerificationMeta('dob');
  @override
  late final GeneratedColumn<DateTime> dob = GeneratedColumn<DateTime>(
    'dob',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<int> heightCm = GeneratedColumn<int>(
    'height_cm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    firstName,
    lastName,
    nickname,
    primaryNumber,
    teamId,
    preferredPositions,
    dob,
    heightCm,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'players';
  @override
  VerificationContext validateIntegrity(
    Insertable<Player> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    }
    if (data.containsKey('primary_number')) {
      context.handle(
        _primaryNumberMeta,
        primaryNumber.isAcceptableOrUnknown(
          data['primary_number']!,
          _primaryNumberMeta,
        ),
      );
    }
    if (data.containsKey('team_id')) {
      context.handle(
        _teamIdMeta,
        teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta),
      );
    }
    if (data.containsKey('preferred_positions')) {
      context.handle(
        _preferredPositionsMeta,
        preferredPositions.isAcceptableOrUnknown(
          data['preferred_positions']!,
          _preferredPositionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_preferredPositionsMeta);
    }
    if (data.containsKey('dob')) {
      context.handle(
        _dobMeta,
        dob.isAcceptableOrUnknown(data['dob']!, _dobMeta),
      );
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Player map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Player(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      ),
      primaryNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}primary_number'],
      ),
      teamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}team_id'],
      ),
      preferredPositions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_positions'],
      )!,
      dob: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dob'],
      ),
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height_cm'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PlayersTable createAlias(String alias) {
    return $PlayersTable(attachedDatabase, alias);
  }
}

class Player extends DataClass implements Insertable<Player> {
  final int id;
  final String firstName;
  final String lastName;
  final String? nickname;
  final int? primaryNumber;
  final int? teamId;
  final String preferredPositions;
  final DateTime? dob;
  final int? heightCm;
  final DateTime createdAt;
  const Player({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.nickname,
    this.primaryNumber,
    this.teamId,
    required this.preferredPositions,
    this.dob,
    this.heightCm,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || nickname != null) {
      map['nickname'] = Variable<String>(nickname);
    }
    if (!nullToAbsent || primaryNumber != null) {
      map['primary_number'] = Variable<int>(primaryNumber);
    }
    if (!nullToAbsent || teamId != null) {
      map['team_id'] = Variable<int>(teamId);
    }
    map['preferred_positions'] = Variable<String>(preferredPositions);
    if (!nullToAbsent || dob != null) {
      map['dob'] = Variable<DateTime>(dob);
    }
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<int>(heightCm);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PlayersCompanion toCompanion(bool nullToAbsent) {
    return PlayersCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      nickname: nickname == null && nullToAbsent
          ? const Value.absent()
          : Value(nickname),
      primaryNumber: primaryNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryNumber),
      teamId: teamId == null && nullToAbsent
          ? const Value.absent()
          : Value(teamId),
      preferredPositions: Value(preferredPositions),
      dob: dob == null && nullToAbsent ? const Value.absent() : Value(dob),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      createdAt: Value(createdAt),
    );
  }

  factory Player.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Player(
      id: serializer.fromJson<int>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      nickname: serializer.fromJson<String?>(json['nickname']),
      primaryNumber: serializer.fromJson<int?>(json['primaryNumber']),
      teamId: serializer.fromJson<int?>(json['teamId']),
      preferredPositions: serializer.fromJson<String>(
        json['preferredPositions'],
      ),
      dob: serializer.fromJson<DateTime?>(json['dob']),
      heightCm: serializer.fromJson<int?>(json['heightCm']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'nickname': serializer.toJson<String?>(nickname),
      'primaryNumber': serializer.toJson<int?>(primaryNumber),
      'teamId': serializer.toJson<int?>(teamId),
      'preferredPositions': serializer.toJson<String>(preferredPositions),
      'dob': serializer.toJson<DateTime?>(dob),
      'heightCm': serializer.toJson<int?>(heightCm),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Player copyWith({
    int? id,
    String? firstName,
    String? lastName,
    Value<String?> nickname = const Value.absent(),
    Value<int?> primaryNumber = const Value.absent(),
    Value<int?> teamId = const Value.absent(),
    String? preferredPositions,
    Value<DateTime?> dob = const Value.absent(),
    Value<int?> heightCm = const Value.absent(),
    DateTime? createdAt,
  }) => Player(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    nickname: nickname.present ? nickname.value : this.nickname,
    primaryNumber: primaryNumber.present
        ? primaryNumber.value
        : this.primaryNumber,
    teamId: teamId.present ? teamId.value : this.teamId,
    preferredPositions: preferredPositions ?? this.preferredPositions,
    dob: dob.present ? dob.value : this.dob,
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    createdAt: createdAt ?? this.createdAt,
  );
  Player copyWithCompanion(PlayersCompanion data) {
    return Player(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      primaryNumber: data.primaryNumber.present
          ? data.primaryNumber.value
          : this.primaryNumber,
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
      preferredPositions: data.preferredPositions.present
          ? data.preferredPositions.value
          : this.preferredPositions,
      dob: data.dob.present ? data.dob.value : this.dob,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Player(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('nickname: $nickname, ')
          ..write('primaryNumber: $primaryNumber, ')
          ..write('teamId: $teamId, ')
          ..write('preferredPositions: $preferredPositions, ')
          ..write('dob: $dob, ')
          ..write('heightCm: $heightCm, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    firstName,
    lastName,
    nickname,
    primaryNumber,
    teamId,
    preferredPositions,
    dob,
    heightCm,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Player &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.nickname == this.nickname &&
          other.primaryNumber == this.primaryNumber &&
          other.teamId == this.teamId &&
          other.preferredPositions == this.preferredPositions &&
          other.dob == this.dob &&
          other.heightCm == this.heightCm &&
          other.createdAt == this.createdAt);
}

class PlayersCompanion extends UpdateCompanion<Player> {
  final Value<int> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> nickname;
  final Value<int?> primaryNumber;
  final Value<int?> teamId;
  final Value<String> preferredPositions;
  final Value<DateTime?> dob;
  final Value<int?> heightCm;
  final Value<DateTime> createdAt;
  const PlayersCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.nickname = const Value.absent(),
    this.primaryNumber = const Value.absent(),
    this.teamId = const Value.absent(),
    this.preferredPositions = const Value.absent(),
    this.dob = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PlayersCompanion.insert({
    this.id = const Value.absent(),
    required String firstName,
    required String lastName,
    this.nickname = const Value.absent(),
    this.primaryNumber = const Value.absent(),
    this.teamId = const Value.absent(),
    required String preferredPositions,
    this.dob = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : firstName = Value(firstName),
       lastName = Value(lastName),
       preferredPositions = Value(preferredPositions);
  static Insertable<Player> custom({
    Expression<int>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? nickname,
    Expression<int>? primaryNumber,
    Expression<int>? teamId,
    Expression<String>? preferredPositions,
    Expression<DateTime>? dob,
    Expression<int>? heightCm,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (nickname != null) 'nickname': nickname,
      if (primaryNumber != null) 'primary_number': primaryNumber,
      if (teamId != null) 'team_id': teamId,
      if (preferredPositions != null) 'preferred_positions': preferredPositions,
      if (dob != null) 'dob': dob,
      if (heightCm != null) 'height_cm': heightCm,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PlayersCompanion copyWith({
    Value<int>? id,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String?>? nickname,
    Value<int?>? primaryNumber,
    Value<int?>? teamId,
    Value<String>? preferredPositions,
    Value<DateTime?>? dob,
    Value<int?>? heightCm,
    Value<DateTime>? createdAt,
  }) {
    return PlayersCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickname: nickname ?? this.nickname,
      primaryNumber: primaryNumber ?? this.primaryNumber,
      teamId: teamId ?? this.teamId,
      preferredPositions: preferredPositions ?? this.preferredPositions,
      dob: dob ?? this.dob,
      heightCm: heightCm ?? this.heightCm,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (primaryNumber.present) {
      map['primary_number'] = Variable<int>(primaryNumber.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<int>(teamId.value);
    }
    if (preferredPositions.present) {
      map['preferred_positions'] = Variable<String>(preferredPositions.value);
    }
    if (dob.present) {
      map['dob'] = Variable<DateTime>(dob.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<int>(heightCm.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayersCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('nickname: $nickname, ')
          ..write('primaryNumber: $primaryNumber, ')
          ..write('teamId: $teamId, ')
          ..write('preferredPositions: $preferredPositions, ')
          ..write('dob: $dob, ')
          ..write('heightCm: $heightCm, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $GamesTable extends Games with TableInfo<$GamesTable, GameEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _homeTeamNameMeta = const VerificationMeta(
    'homeTeamName',
  );
  @override
  late final GeneratedColumn<String> homeTeamName = GeneratedColumn<String>(
    'home_team_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('OUR TEAM'),
  );
  static const VerificationMeta _opponentNameMeta = const VerificationMeta(
    'opponentName',
  );
  @override
  late final GeneratedColumn<String> opponentName = GeneratedColumn<String>(
    'opponent_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _competitionNameMeta = const VerificationMeta(
    'competitionName',
  );
  @override
  late final GeneratedColumn<String> competitionName = GeneratedColumn<String>(
    'competition_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _venueNameMeta = const VerificationMeta(
    'venueName',
  );
  @override
  late final GeneratedColumn<String> venueName = GeneratedColumn<String>(
    'venue_name',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _competitionIdMeta = const VerificationMeta(
    'competitionId',
  );
  @override
  late final GeneratedColumn<int> competitionId = GeneratedColumn<int>(
    'competition_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _venueIdMeta = const VerificationMeta(
    'venueId',
  );
  @override
  late final GeneratedColumn<int> venueId = GeneratedColumn<int>(
    'venue_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _homeTeamIdMeta = const VerificationMeta(
    'homeTeamId',
  );
  @override
  late final GeneratedColumn<int> homeTeamId = GeneratedColumn<int>(
    'home_team_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _opponentTeamIdMeta = const VerificationMeta(
    'opponentTeamId',
  );
  @override
  late final GeneratedColumn<int> opponentTeamId = GeneratedColumn<int>(
    'opponent_team_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumn<String> format = GeneratedColumn<String>(
    'format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackingModeMeta = const VerificationMeta(
    'trackingMode',
  );
  @override
  late final GeneratedColumn<String> trackingMode = GeneratedColumn<String>(
    'tracking_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('fullStatistics'),
  );
  static const VerificationMeta _ourFirstCentrePassMeta =
      const VerificationMeta('ourFirstCentrePass');
  @override
  late final GeneratedColumn<bool> ourFirstCentrePass = GeneratedColumn<bool>(
    'our_first_centre_pass',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("our_first_centre_pass" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isSuperShotMeta = const VerificationMeta(
    'isSuperShot',
  );
  @override
  late final GeneratedColumn<bool> isSuperShot = GeneratedColumn<bool>(
    'is_super_shot',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_super_shot" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fast5PowerPlayModeMeta =
      const VerificationMeta('fast5PowerPlayMode');
  @override
  late final GeneratedColumn<String> fast5PowerPlayMode =
      GeneratedColumn<String>(
        'fast5_power_play_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('contested'),
      );
  static const VerificationMeta _homePowerPlayQuarterMeta =
      const VerificationMeta('homePowerPlayQuarter');
  @override
  late final GeneratedColumn<int> homePowerPlayQuarter = GeneratedColumn<int>(
    'home_power_play_quarter',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _awayPowerPlayQuarterMeta =
      const VerificationMeta('awayPowerPlayQuarter');
  @override
  late final GeneratedColumn<int> awayPowerPlayQuarter = GeneratedColumn<int>(
    'away_power_play_quarter',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _homeScoreMeta = const VerificationMeta(
    'homeScore',
  );
  @override
  late final GeneratedColumn<int> homeScore = GeneratedColumn<int>(
    'home_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _awayScoreMeta = const VerificationMeta(
    'awayScore',
  );
  @override
  late final GeneratedColumn<int> awayScore = GeneratedColumn<int>(
    'away_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quarterDurationMinutesMeta =
      const VerificationMeta('quarterDurationMinutes');
  @override
  late final GeneratedColumn<int> quarterDurationMinutes = GeneratedColumn<int>(
    'quarter_duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _totalQuartersMeta = const VerificationMeta(
    'totalQuarters',
  );
  @override
  late final GeneratedColumn<int> totalQuarters = GeneratedColumn<int>(
    'total_quarters',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    homeTeamName,
    opponentName,
    competitionName,
    venueName,
    scheduledAt,
    competitionId,
    venueId,
    homeTeamId,
    opponentTeamId,
    format,
    status,
    trackingMode,
    ourFirstCentrePass,
    isSuperShot,
    fast5PowerPlayMode,
    homePowerPlayQuarter,
    awayPowerPlayQuarter,
    homeScore,
    awayScore,
    quarterDurationMinutes,
    totalQuarters,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('home_team_name')) {
      context.handle(
        _homeTeamNameMeta,
        homeTeamName.isAcceptableOrUnknown(
          data['home_team_name']!,
          _homeTeamNameMeta,
        ),
      );
    }
    if (data.containsKey('opponent_name')) {
      context.handle(
        _opponentNameMeta,
        opponentName.isAcceptableOrUnknown(
          data['opponent_name']!,
          _opponentNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_opponentNameMeta);
    }
    if (data.containsKey('competition_name')) {
      context.handle(
        _competitionNameMeta,
        competitionName.isAcceptableOrUnknown(
          data['competition_name']!,
          _competitionNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_competitionNameMeta);
    }
    if (data.containsKey('venue_name')) {
      context.handle(
        _venueNameMeta,
        venueName.isAcceptableOrUnknown(data['venue_name']!, _venueNameMeta),
      );
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('competition_id')) {
      context.handle(
        _competitionIdMeta,
        competitionId.isAcceptableOrUnknown(
          data['competition_id']!,
          _competitionIdMeta,
        ),
      );
    }
    if (data.containsKey('venue_id')) {
      context.handle(
        _venueIdMeta,
        venueId.isAcceptableOrUnknown(data['venue_id']!, _venueIdMeta),
      );
    }
    if (data.containsKey('home_team_id')) {
      context.handle(
        _homeTeamIdMeta,
        homeTeamId.isAcceptableOrUnknown(
          data['home_team_id']!,
          _homeTeamIdMeta,
        ),
      );
    }
    if (data.containsKey('opponent_team_id')) {
      context.handle(
        _opponentTeamIdMeta,
        opponentTeamId.isAcceptableOrUnknown(
          data['opponent_team_id']!,
          _opponentTeamIdMeta,
        ),
      );
    }
    if (data.containsKey('format')) {
      context.handle(
        _formatMeta,
        format.isAcceptableOrUnknown(data['format']!, _formatMeta),
      );
    } else if (isInserting) {
      context.missing(_formatMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('tracking_mode')) {
      context.handle(
        _trackingModeMeta,
        trackingMode.isAcceptableOrUnknown(
          data['tracking_mode']!,
          _trackingModeMeta,
        ),
      );
    }
    if (data.containsKey('our_first_centre_pass')) {
      context.handle(
        _ourFirstCentrePassMeta,
        ourFirstCentrePass.isAcceptableOrUnknown(
          data['our_first_centre_pass']!,
          _ourFirstCentrePassMeta,
        ),
      );
    }
    if (data.containsKey('is_super_shot')) {
      context.handle(
        _isSuperShotMeta,
        isSuperShot.isAcceptableOrUnknown(
          data['is_super_shot']!,
          _isSuperShotMeta,
        ),
      );
    }
    if (data.containsKey('fast5_power_play_mode')) {
      context.handle(
        _fast5PowerPlayModeMeta,
        fast5PowerPlayMode.isAcceptableOrUnknown(
          data['fast5_power_play_mode']!,
          _fast5PowerPlayModeMeta,
        ),
      );
    }
    if (data.containsKey('home_power_play_quarter')) {
      context.handle(
        _homePowerPlayQuarterMeta,
        homePowerPlayQuarter.isAcceptableOrUnknown(
          data['home_power_play_quarter']!,
          _homePowerPlayQuarterMeta,
        ),
      );
    }
    if (data.containsKey('away_power_play_quarter')) {
      context.handle(
        _awayPowerPlayQuarterMeta,
        awayPowerPlayQuarter.isAcceptableOrUnknown(
          data['away_power_play_quarter']!,
          _awayPowerPlayQuarterMeta,
        ),
      );
    }
    if (data.containsKey('home_score')) {
      context.handle(
        _homeScoreMeta,
        homeScore.isAcceptableOrUnknown(data['home_score']!, _homeScoreMeta),
      );
    }
    if (data.containsKey('away_score')) {
      context.handle(
        _awayScoreMeta,
        awayScore.isAcceptableOrUnknown(data['away_score']!, _awayScoreMeta),
      );
    }
    if (data.containsKey('quarter_duration_minutes')) {
      context.handle(
        _quarterDurationMinutesMeta,
        quarterDurationMinutes.isAcceptableOrUnknown(
          data['quarter_duration_minutes']!,
          _quarterDurationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('total_quarters')) {
      context.handle(
        _totalQuartersMeta,
        totalQuarters.isAcceptableOrUnknown(
          data['total_quarters']!,
          _totalQuartersMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      homeTeamName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}home_team_name'],
      )!,
      opponentName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opponent_name'],
      )!,
      competitionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}competition_name'],
      )!,
      venueName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}venue_name'],
      ),
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      )!,
      competitionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}competition_id'],
      ),
      venueId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}venue_id'],
      ),
      homeTeamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}home_team_id'],
      ),
      opponentTeamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opponent_team_id'],
      ),
      format: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      trackingMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracking_mode'],
      )!,
      ourFirstCentrePass: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}our_first_centre_pass'],
      )!,
      isSuperShot: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_super_shot'],
      )!,
      fast5PowerPlayMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fast5_power_play_mode'],
      )!,
      homePowerPlayQuarter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}home_power_play_quarter'],
      ),
      awayPowerPlayQuarter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}away_power_play_quarter'],
      ),
      homeScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}home_score'],
      ),
      awayScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}away_score'],
      ),
      quarterDurationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quarter_duration_minutes'],
      )!,
      totalQuarters: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_quarters'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GamesTable createAlias(String alias) {
    return $GamesTable(attachedDatabase, alias);
  }
}

class GameEntry extends DataClass implements Insertable<GameEntry> {
  final int id;
  final String homeTeamName;
  final String opponentName;
  final String competitionName;
  final String? venueName;
  final DateTime scheduledAt;
  final int? competitionId;
  final int? venueId;
  final int? homeTeamId;
  final int? opponentTeamId;
  final String format;
  final String status;
  final String trackingMode;
  final bool ourFirstCentrePass;
  final bool isSuperShot;
  final String fast5PowerPlayMode;
  final int? homePowerPlayQuarter;
  final int? awayPowerPlayQuarter;
  final int? homeScore;
  final int? awayScore;
  final int quarterDurationMinutes;
  final int totalQuarters;
  final DateTime createdAt;
  const GameEntry({
    required this.id,
    required this.homeTeamName,
    required this.opponentName,
    required this.competitionName,
    this.venueName,
    required this.scheduledAt,
    this.competitionId,
    this.venueId,
    this.homeTeamId,
    this.opponentTeamId,
    required this.format,
    required this.status,
    required this.trackingMode,
    required this.ourFirstCentrePass,
    required this.isSuperShot,
    required this.fast5PowerPlayMode,
    this.homePowerPlayQuarter,
    this.awayPowerPlayQuarter,
    this.homeScore,
    this.awayScore,
    required this.quarterDurationMinutes,
    required this.totalQuarters,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['home_team_name'] = Variable<String>(homeTeamName);
    map['opponent_name'] = Variable<String>(opponentName);
    map['competition_name'] = Variable<String>(competitionName);
    if (!nullToAbsent || venueName != null) {
      map['venue_name'] = Variable<String>(venueName);
    }
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    if (!nullToAbsent || competitionId != null) {
      map['competition_id'] = Variable<int>(competitionId);
    }
    if (!nullToAbsent || venueId != null) {
      map['venue_id'] = Variable<int>(venueId);
    }
    if (!nullToAbsent || homeTeamId != null) {
      map['home_team_id'] = Variable<int>(homeTeamId);
    }
    if (!nullToAbsent || opponentTeamId != null) {
      map['opponent_team_id'] = Variable<int>(opponentTeamId);
    }
    map['format'] = Variable<String>(format);
    map['status'] = Variable<String>(status);
    map['tracking_mode'] = Variable<String>(trackingMode);
    map['our_first_centre_pass'] = Variable<bool>(ourFirstCentrePass);
    map['is_super_shot'] = Variable<bool>(isSuperShot);
    map['fast5_power_play_mode'] = Variable<String>(fast5PowerPlayMode);
    if (!nullToAbsent || homePowerPlayQuarter != null) {
      map['home_power_play_quarter'] = Variable<int>(homePowerPlayQuarter);
    }
    if (!nullToAbsent || awayPowerPlayQuarter != null) {
      map['away_power_play_quarter'] = Variable<int>(awayPowerPlayQuarter);
    }
    if (!nullToAbsent || homeScore != null) {
      map['home_score'] = Variable<int>(homeScore);
    }
    if (!nullToAbsent || awayScore != null) {
      map['away_score'] = Variable<int>(awayScore);
    }
    map['quarter_duration_minutes'] = Variable<int>(quarterDurationMinutes);
    map['total_quarters'] = Variable<int>(totalQuarters);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(
      id: Value(id),
      homeTeamName: Value(homeTeamName),
      opponentName: Value(opponentName),
      competitionName: Value(competitionName),
      venueName: venueName == null && nullToAbsent
          ? const Value.absent()
          : Value(venueName),
      scheduledAt: Value(scheduledAt),
      competitionId: competitionId == null && nullToAbsent
          ? const Value.absent()
          : Value(competitionId),
      venueId: venueId == null && nullToAbsent
          ? const Value.absent()
          : Value(venueId),
      homeTeamId: homeTeamId == null && nullToAbsent
          ? const Value.absent()
          : Value(homeTeamId),
      opponentTeamId: opponentTeamId == null && nullToAbsent
          ? const Value.absent()
          : Value(opponentTeamId),
      format: Value(format),
      status: Value(status),
      trackingMode: Value(trackingMode),
      ourFirstCentrePass: Value(ourFirstCentrePass),
      isSuperShot: Value(isSuperShot),
      fast5PowerPlayMode: Value(fast5PowerPlayMode),
      homePowerPlayQuarter: homePowerPlayQuarter == null && nullToAbsent
          ? const Value.absent()
          : Value(homePowerPlayQuarter),
      awayPowerPlayQuarter: awayPowerPlayQuarter == null && nullToAbsent
          ? const Value.absent()
          : Value(awayPowerPlayQuarter),
      homeScore: homeScore == null && nullToAbsent
          ? const Value.absent()
          : Value(homeScore),
      awayScore: awayScore == null && nullToAbsent
          ? const Value.absent()
          : Value(awayScore),
      quarterDurationMinutes: Value(quarterDurationMinutes),
      totalQuarters: Value(totalQuarters),
      createdAt: Value(createdAt),
    );
  }

  factory GameEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameEntry(
      id: serializer.fromJson<int>(json['id']),
      homeTeamName: serializer.fromJson<String>(json['homeTeamName']),
      opponentName: serializer.fromJson<String>(json['opponentName']),
      competitionName: serializer.fromJson<String>(json['competitionName']),
      venueName: serializer.fromJson<String?>(json['venueName']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      competitionId: serializer.fromJson<int?>(json['competitionId']),
      venueId: serializer.fromJson<int?>(json['venueId']),
      homeTeamId: serializer.fromJson<int?>(json['homeTeamId']),
      opponentTeamId: serializer.fromJson<int?>(json['opponentTeamId']),
      format: serializer.fromJson<String>(json['format']),
      status: serializer.fromJson<String>(json['status']),
      trackingMode: serializer.fromJson<String>(json['trackingMode']),
      ourFirstCentrePass: serializer.fromJson<bool>(json['ourFirstCentrePass']),
      isSuperShot: serializer.fromJson<bool>(json['isSuperShot']),
      fast5PowerPlayMode: serializer.fromJson<String>(
        json['fast5PowerPlayMode'],
      ),
      homePowerPlayQuarter: serializer.fromJson<int?>(
        json['homePowerPlayQuarter'],
      ),
      awayPowerPlayQuarter: serializer.fromJson<int?>(
        json['awayPowerPlayQuarter'],
      ),
      homeScore: serializer.fromJson<int?>(json['homeScore']),
      awayScore: serializer.fromJson<int?>(json['awayScore']),
      quarterDurationMinutes: serializer.fromJson<int>(
        json['quarterDurationMinutes'],
      ),
      totalQuarters: serializer.fromJson<int>(json['totalQuarters']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'homeTeamName': serializer.toJson<String>(homeTeamName),
      'opponentName': serializer.toJson<String>(opponentName),
      'competitionName': serializer.toJson<String>(competitionName),
      'venueName': serializer.toJson<String?>(venueName),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'competitionId': serializer.toJson<int?>(competitionId),
      'venueId': serializer.toJson<int?>(venueId),
      'homeTeamId': serializer.toJson<int?>(homeTeamId),
      'opponentTeamId': serializer.toJson<int?>(opponentTeamId),
      'format': serializer.toJson<String>(format),
      'status': serializer.toJson<String>(status),
      'trackingMode': serializer.toJson<String>(trackingMode),
      'ourFirstCentrePass': serializer.toJson<bool>(ourFirstCentrePass),
      'isSuperShot': serializer.toJson<bool>(isSuperShot),
      'fast5PowerPlayMode': serializer.toJson<String>(fast5PowerPlayMode),
      'homePowerPlayQuarter': serializer.toJson<int?>(homePowerPlayQuarter),
      'awayPowerPlayQuarter': serializer.toJson<int?>(awayPowerPlayQuarter),
      'homeScore': serializer.toJson<int?>(homeScore),
      'awayScore': serializer.toJson<int?>(awayScore),
      'quarterDurationMinutes': serializer.toJson<int>(quarterDurationMinutes),
      'totalQuarters': serializer.toJson<int>(totalQuarters),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GameEntry copyWith({
    int? id,
    String? homeTeamName,
    String? opponentName,
    String? competitionName,
    Value<String?> venueName = const Value.absent(),
    DateTime? scheduledAt,
    Value<int?> competitionId = const Value.absent(),
    Value<int?> venueId = const Value.absent(),
    Value<int?> homeTeamId = const Value.absent(),
    Value<int?> opponentTeamId = const Value.absent(),
    String? format,
    String? status,
    String? trackingMode,
    bool? ourFirstCentrePass,
    bool? isSuperShot,
    String? fast5PowerPlayMode,
    Value<int?> homePowerPlayQuarter = const Value.absent(),
    Value<int?> awayPowerPlayQuarter = const Value.absent(),
    Value<int?> homeScore = const Value.absent(),
    Value<int?> awayScore = const Value.absent(),
    int? quarterDurationMinutes,
    int? totalQuarters,
    DateTime? createdAt,
  }) => GameEntry(
    id: id ?? this.id,
    homeTeamName: homeTeamName ?? this.homeTeamName,
    opponentName: opponentName ?? this.opponentName,
    competitionName: competitionName ?? this.competitionName,
    venueName: venueName.present ? venueName.value : this.venueName,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    competitionId: competitionId.present
        ? competitionId.value
        : this.competitionId,
    venueId: venueId.present ? venueId.value : this.venueId,
    homeTeamId: homeTeamId.present ? homeTeamId.value : this.homeTeamId,
    opponentTeamId: opponentTeamId.present
        ? opponentTeamId.value
        : this.opponentTeamId,
    format: format ?? this.format,
    status: status ?? this.status,
    trackingMode: trackingMode ?? this.trackingMode,
    ourFirstCentrePass: ourFirstCentrePass ?? this.ourFirstCentrePass,
    isSuperShot: isSuperShot ?? this.isSuperShot,
    fast5PowerPlayMode: fast5PowerPlayMode ?? this.fast5PowerPlayMode,
    homePowerPlayQuarter: homePowerPlayQuarter.present
        ? homePowerPlayQuarter.value
        : this.homePowerPlayQuarter,
    awayPowerPlayQuarter: awayPowerPlayQuarter.present
        ? awayPowerPlayQuarter.value
        : this.awayPowerPlayQuarter,
    homeScore: homeScore.present ? homeScore.value : this.homeScore,
    awayScore: awayScore.present ? awayScore.value : this.awayScore,
    quarterDurationMinutes:
        quarterDurationMinutes ?? this.quarterDurationMinutes,
    totalQuarters: totalQuarters ?? this.totalQuarters,
    createdAt: createdAt ?? this.createdAt,
  );
  GameEntry copyWithCompanion(GamesCompanion data) {
    return GameEntry(
      id: data.id.present ? data.id.value : this.id,
      homeTeamName: data.homeTeamName.present
          ? data.homeTeamName.value
          : this.homeTeamName,
      opponentName: data.opponentName.present
          ? data.opponentName.value
          : this.opponentName,
      competitionName: data.competitionName.present
          ? data.competitionName.value
          : this.competitionName,
      venueName: data.venueName.present ? data.venueName.value : this.venueName,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      competitionId: data.competitionId.present
          ? data.competitionId.value
          : this.competitionId,
      venueId: data.venueId.present ? data.venueId.value : this.venueId,
      homeTeamId: data.homeTeamId.present
          ? data.homeTeamId.value
          : this.homeTeamId,
      opponentTeamId: data.opponentTeamId.present
          ? data.opponentTeamId.value
          : this.opponentTeamId,
      format: data.format.present ? data.format.value : this.format,
      status: data.status.present ? data.status.value : this.status,
      trackingMode: data.trackingMode.present
          ? data.trackingMode.value
          : this.trackingMode,
      ourFirstCentrePass: data.ourFirstCentrePass.present
          ? data.ourFirstCentrePass.value
          : this.ourFirstCentrePass,
      isSuperShot: data.isSuperShot.present
          ? data.isSuperShot.value
          : this.isSuperShot,
      fast5PowerPlayMode: data.fast5PowerPlayMode.present
          ? data.fast5PowerPlayMode.value
          : this.fast5PowerPlayMode,
      homePowerPlayQuarter: data.homePowerPlayQuarter.present
          ? data.homePowerPlayQuarter.value
          : this.homePowerPlayQuarter,
      awayPowerPlayQuarter: data.awayPowerPlayQuarter.present
          ? data.awayPowerPlayQuarter.value
          : this.awayPowerPlayQuarter,
      homeScore: data.homeScore.present ? data.homeScore.value : this.homeScore,
      awayScore: data.awayScore.present ? data.awayScore.value : this.awayScore,
      quarterDurationMinutes: data.quarterDurationMinutes.present
          ? data.quarterDurationMinutes.value
          : this.quarterDurationMinutes,
      totalQuarters: data.totalQuarters.present
          ? data.totalQuarters.value
          : this.totalQuarters,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameEntry(')
          ..write('id: $id, ')
          ..write('homeTeamName: $homeTeamName, ')
          ..write('opponentName: $opponentName, ')
          ..write('competitionName: $competitionName, ')
          ..write('venueName: $venueName, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('competitionId: $competitionId, ')
          ..write('venueId: $venueId, ')
          ..write('homeTeamId: $homeTeamId, ')
          ..write('opponentTeamId: $opponentTeamId, ')
          ..write('format: $format, ')
          ..write('status: $status, ')
          ..write('trackingMode: $trackingMode, ')
          ..write('ourFirstCentrePass: $ourFirstCentrePass, ')
          ..write('isSuperShot: $isSuperShot, ')
          ..write('fast5PowerPlayMode: $fast5PowerPlayMode, ')
          ..write('homePowerPlayQuarter: $homePowerPlayQuarter, ')
          ..write('awayPowerPlayQuarter: $awayPowerPlayQuarter, ')
          ..write('homeScore: $homeScore, ')
          ..write('awayScore: $awayScore, ')
          ..write('quarterDurationMinutes: $quarterDurationMinutes, ')
          ..write('totalQuarters: $totalQuarters, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    homeTeamName,
    opponentName,
    competitionName,
    venueName,
    scheduledAt,
    competitionId,
    venueId,
    homeTeamId,
    opponentTeamId,
    format,
    status,
    trackingMode,
    ourFirstCentrePass,
    isSuperShot,
    fast5PowerPlayMode,
    homePowerPlayQuarter,
    awayPowerPlayQuarter,
    homeScore,
    awayScore,
    quarterDurationMinutes,
    totalQuarters,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameEntry &&
          other.id == this.id &&
          other.homeTeamName == this.homeTeamName &&
          other.opponentName == this.opponentName &&
          other.competitionName == this.competitionName &&
          other.venueName == this.venueName &&
          other.scheduledAt == this.scheduledAt &&
          other.competitionId == this.competitionId &&
          other.venueId == this.venueId &&
          other.homeTeamId == this.homeTeamId &&
          other.opponentTeamId == this.opponentTeamId &&
          other.format == this.format &&
          other.status == this.status &&
          other.trackingMode == this.trackingMode &&
          other.ourFirstCentrePass == this.ourFirstCentrePass &&
          other.isSuperShot == this.isSuperShot &&
          other.fast5PowerPlayMode == this.fast5PowerPlayMode &&
          other.homePowerPlayQuarter == this.homePowerPlayQuarter &&
          other.awayPowerPlayQuarter == this.awayPowerPlayQuarter &&
          other.homeScore == this.homeScore &&
          other.awayScore == this.awayScore &&
          other.quarterDurationMinutes == this.quarterDurationMinutes &&
          other.totalQuarters == this.totalQuarters &&
          other.createdAt == this.createdAt);
}

class GamesCompanion extends UpdateCompanion<GameEntry> {
  final Value<int> id;
  final Value<String> homeTeamName;
  final Value<String> opponentName;
  final Value<String> competitionName;
  final Value<String?> venueName;
  final Value<DateTime> scheduledAt;
  final Value<int?> competitionId;
  final Value<int?> venueId;
  final Value<int?> homeTeamId;
  final Value<int?> opponentTeamId;
  final Value<String> format;
  final Value<String> status;
  final Value<String> trackingMode;
  final Value<bool> ourFirstCentrePass;
  final Value<bool> isSuperShot;
  final Value<String> fast5PowerPlayMode;
  final Value<int?> homePowerPlayQuarter;
  final Value<int?> awayPowerPlayQuarter;
  final Value<int?> homeScore;
  final Value<int?> awayScore;
  final Value<int> quarterDurationMinutes;
  final Value<int> totalQuarters;
  final Value<DateTime> createdAt;
  const GamesCompanion({
    this.id = const Value.absent(),
    this.homeTeamName = const Value.absent(),
    this.opponentName = const Value.absent(),
    this.competitionName = const Value.absent(),
    this.venueName = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.competitionId = const Value.absent(),
    this.venueId = const Value.absent(),
    this.homeTeamId = const Value.absent(),
    this.opponentTeamId = const Value.absent(),
    this.format = const Value.absent(),
    this.status = const Value.absent(),
    this.trackingMode = const Value.absent(),
    this.ourFirstCentrePass = const Value.absent(),
    this.isSuperShot = const Value.absent(),
    this.fast5PowerPlayMode = const Value.absent(),
    this.homePowerPlayQuarter = const Value.absent(),
    this.awayPowerPlayQuarter = const Value.absent(),
    this.homeScore = const Value.absent(),
    this.awayScore = const Value.absent(),
    this.quarterDurationMinutes = const Value.absent(),
    this.totalQuarters = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GamesCompanion.insert({
    this.id = const Value.absent(),
    this.homeTeamName = const Value.absent(),
    required String opponentName,
    required String competitionName,
    this.venueName = const Value.absent(),
    required DateTime scheduledAt,
    this.competitionId = const Value.absent(),
    this.venueId = const Value.absent(),
    this.homeTeamId = const Value.absent(),
    this.opponentTeamId = const Value.absent(),
    required String format,
    required String status,
    this.trackingMode = const Value.absent(),
    this.ourFirstCentrePass = const Value.absent(),
    this.isSuperShot = const Value.absent(),
    this.fast5PowerPlayMode = const Value.absent(),
    this.homePowerPlayQuarter = const Value.absent(),
    this.awayPowerPlayQuarter = const Value.absent(),
    this.homeScore = const Value.absent(),
    this.awayScore = const Value.absent(),
    this.quarterDurationMinutes = const Value.absent(),
    this.totalQuarters = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : opponentName = Value(opponentName),
       competitionName = Value(competitionName),
       scheduledAt = Value(scheduledAt),
       format = Value(format),
       status = Value(status);
  static Insertable<GameEntry> custom({
    Expression<int>? id,
    Expression<String>? homeTeamName,
    Expression<String>? opponentName,
    Expression<String>? competitionName,
    Expression<String>? venueName,
    Expression<DateTime>? scheduledAt,
    Expression<int>? competitionId,
    Expression<int>? venueId,
    Expression<int>? homeTeamId,
    Expression<int>? opponentTeamId,
    Expression<String>? format,
    Expression<String>? status,
    Expression<String>? trackingMode,
    Expression<bool>? ourFirstCentrePass,
    Expression<bool>? isSuperShot,
    Expression<String>? fast5PowerPlayMode,
    Expression<int>? homePowerPlayQuarter,
    Expression<int>? awayPowerPlayQuarter,
    Expression<int>? homeScore,
    Expression<int>? awayScore,
    Expression<int>? quarterDurationMinutes,
    Expression<int>? totalQuarters,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (homeTeamName != null) 'home_team_name': homeTeamName,
      if (opponentName != null) 'opponent_name': opponentName,
      if (competitionName != null) 'competition_name': competitionName,
      if (venueName != null) 'venue_name': venueName,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (competitionId != null) 'competition_id': competitionId,
      if (venueId != null) 'venue_id': venueId,
      if (homeTeamId != null) 'home_team_id': homeTeamId,
      if (opponentTeamId != null) 'opponent_team_id': opponentTeamId,
      if (format != null) 'format': format,
      if (status != null) 'status': status,
      if (trackingMode != null) 'tracking_mode': trackingMode,
      if (ourFirstCentrePass != null)
        'our_first_centre_pass': ourFirstCentrePass,
      if (isSuperShot != null) 'is_super_shot': isSuperShot,
      if (fast5PowerPlayMode != null)
        'fast5_power_play_mode': fast5PowerPlayMode,
      if (homePowerPlayQuarter != null)
        'home_power_play_quarter': homePowerPlayQuarter,
      if (awayPowerPlayQuarter != null)
        'away_power_play_quarter': awayPowerPlayQuarter,
      if (homeScore != null) 'home_score': homeScore,
      if (awayScore != null) 'away_score': awayScore,
      if (quarterDurationMinutes != null)
        'quarter_duration_minutes': quarterDurationMinutes,
      if (totalQuarters != null) 'total_quarters': totalQuarters,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  GamesCompanion copyWith({
    Value<int>? id,
    Value<String>? homeTeamName,
    Value<String>? opponentName,
    Value<String>? competitionName,
    Value<String?>? venueName,
    Value<DateTime>? scheduledAt,
    Value<int?>? competitionId,
    Value<int?>? venueId,
    Value<int?>? homeTeamId,
    Value<int?>? opponentTeamId,
    Value<String>? format,
    Value<String>? status,
    Value<String>? trackingMode,
    Value<bool>? ourFirstCentrePass,
    Value<bool>? isSuperShot,
    Value<String>? fast5PowerPlayMode,
    Value<int?>? homePowerPlayQuarter,
    Value<int?>? awayPowerPlayQuarter,
    Value<int?>? homeScore,
    Value<int?>? awayScore,
    Value<int>? quarterDurationMinutes,
    Value<int>? totalQuarters,
    Value<DateTime>? createdAt,
  }) {
    return GamesCompanion(
      id: id ?? this.id,
      homeTeamName: homeTeamName ?? this.homeTeamName,
      opponentName: opponentName ?? this.opponentName,
      competitionName: competitionName ?? this.competitionName,
      venueName: venueName ?? this.venueName,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      competitionId: competitionId ?? this.competitionId,
      venueId: venueId ?? this.venueId,
      homeTeamId: homeTeamId ?? this.homeTeamId,
      opponentTeamId: opponentTeamId ?? this.opponentTeamId,
      format: format ?? this.format,
      status: status ?? this.status,
      trackingMode: trackingMode ?? this.trackingMode,
      ourFirstCentrePass: ourFirstCentrePass ?? this.ourFirstCentrePass,
      isSuperShot: isSuperShot ?? this.isSuperShot,
      fast5PowerPlayMode: fast5PowerPlayMode ?? this.fast5PowerPlayMode,
      homePowerPlayQuarter: homePowerPlayQuarter ?? this.homePowerPlayQuarter,
      awayPowerPlayQuarter: awayPowerPlayQuarter ?? this.awayPowerPlayQuarter,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      quarterDurationMinutes:
          quarterDurationMinutes ?? this.quarterDurationMinutes,
      totalQuarters: totalQuarters ?? this.totalQuarters,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (homeTeamName.present) {
      map['home_team_name'] = Variable<String>(homeTeamName.value);
    }
    if (opponentName.present) {
      map['opponent_name'] = Variable<String>(opponentName.value);
    }
    if (competitionName.present) {
      map['competition_name'] = Variable<String>(competitionName.value);
    }
    if (venueName.present) {
      map['venue_name'] = Variable<String>(venueName.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (competitionId.present) {
      map['competition_id'] = Variable<int>(competitionId.value);
    }
    if (venueId.present) {
      map['venue_id'] = Variable<int>(venueId.value);
    }
    if (homeTeamId.present) {
      map['home_team_id'] = Variable<int>(homeTeamId.value);
    }
    if (opponentTeamId.present) {
      map['opponent_team_id'] = Variable<int>(opponentTeamId.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(format.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (trackingMode.present) {
      map['tracking_mode'] = Variable<String>(trackingMode.value);
    }
    if (ourFirstCentrePass.present) {
      map['our_first_centre_pass'] = Variable<bool>(ourFirstCentrePass.value);
    }
    if (isSuperShot.present) {
      map['is_super_shot'] = Variable<bool>(isSuperShot.value);
    }
    if (fast5PowerPlayMode.present) {
      map['fast5_power_play_mode'] = Variable<String>(fast5PowerPlayMode.value);
    }
    if (homePowerPlayQuarter.present) {
      map['home_power_play_quarter'] = Variable<int>(
        homePowerPlayQuarter.value,
      );
    }
    if (awayPowerPlayQuarter.present) {
      map['away_power_play_quarter'] = Variable<int>(
        awayPowerPlayQuarter.value,
      );
    }
    if (homeScore.present) {
      map['home_score'] = Variable<int>(homeScore.value);
    }
    if (awayScore.present) {
      map['away_score'] = Variable<int>(awayScore.value);
    }
    if (quarterDurationMinutes.present) {
      map['quarter_duration_minutes'] = Variable<int>(
        quarterDurationMinutes.value,
      );
    }
    if (totalQuarters.present) {
      map['total_quarters'] = Variable<int>(totalQuarters.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCompanion(')
          ..write('id: $id, ')
          ..write('homeTeamName: $homeTeamName, ')
          ..write('opponentName: $opponentName, ')
          ..write('competitionName: $competitionName, ')
          ..write('venueName: $venueName, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('competitionId: $competitionId, ')
          ..write('venueId: $venueId, ')
          ..write('homeTeamId: $homeTeamId, ')
          ..write('opponentTeamId: $opponentTeamId, ')
          ..write('format: $format, ')
          ..write('status: $status, ')
          ..write('trackingMode: $trackingMode, ')
          ..write('ourFirstCentrePass: $ourFirstCentrePass, ')
          ..write('isSuperShot: $isSuperShot, ')
          ..write('fast5PowerPlayMode: $fast5PowerPlayMode, ')
          ..write('homePowerPlayQuarter: $homePowerPlayQuarter, ')
          ..write('awayPowerPlayQuarter: $awayPowerPlayQuarter, ')
          ..write('homeScore: $homeScore, ')
          ..write('awayScore: $awayScore, ')
          ..write('quarterDurationMinutes: $quarterDurationMinutes, ')
          ..write('totalQuarters: $totalQuarters, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LineupsTable extends Lineups with TableInfo<$LineupsTable, LineupEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LineupsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id)',
    ),
  );
  static const VerificationMeta _positionMappingMeta = const VerificationMeta(
    'positionMapping',
  );
  @override
  late final GeneratedColumn<String> positionMapping = GeneratedColumn<String>(
    'position_mapping',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    positionMapping,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lineups';
  @override
  VerificationContext validateIntegrity(
    Insertable<LineupEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('position_mapping')) {
      context.handle(
        _positionMappingMeta,
        positionMapping.isAcceptableOrUnknown(
          data['position_mapping']!,
          _positionMappingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_positionMappingMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LineupEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LineupEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      positionMapping: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}position_mapping'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LineupsTable createAlias(String alias) {
    return $LineupsTable(attachedDatabase, alias);
  }
}

class LineupEntry extends DataClass implements Insertable<LineupEntry> {
  final int id;
  final int gameId;
  final String positionMapping;
  final DateTime createdAt;
  const LineupEntry({
    required this.id,
    required this.gameId,
    required this.positionMapping,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game_id'] = Variable<int>(gameId);
    map['position_mapping'] = Variable<String>(positionMapping);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LineupsCompanion toCompanion(bool nullToAbsent) {
    return LineupsCompanion(
      id: Value(id),
      gameId: Value(gameId),
      positionMapping: Value(positionMapping),
      createdAt: Value(createdAt),
    );
  }

  factory LineupEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LineupEntry(
      id: serializer.fromJson<int>(json['id']),
      gameId: serializer.fromJson<int>(json['gameId']),
      positionMapping: serializer.fromJson<String>(json['positionMapping']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gameId': serializer.toJson<int>(gameId),
      'positionMapping': serializer.toJson<String>(positionMapping),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LineupEntry copyWith({
    int? id,
    int? gameId,
    String? positionMapping,
    DateTime? createdAt,
  }) => LineupEntry(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    positionMapping: positionMapping ?? this.positionMapping,
    createdAt: createdAt ?? this.createdAt,
  );
  LineupEntry copyWithCompanion(LineupsCompanion data) {
    return LineupEntry(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      positionMapping: data.positionMapping.present
          ? data.positionMapping.value
          : this.positionMapping,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LineupEntry(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('positionMapping: $positionMapping, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, gameId, positionMapping, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LineupEntry &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.positionMapping == this.positionMapping &&
          other.createdAt == this.createdAt);
}

class LineupsCompanion extends UpdateCompanion<LineupEntry> {
  final Value<int> id;
  final Value<int> gameId;
  final Value<String> positionMapping;
  final Value<DateTime> createdAt;
  const LineupsCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.positionMapping = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LineupsCompanion.insert({
    this.id = const Value.absent(),
    required int gameId,
    required String positionMapping,
    this.createdAt = const Value.absent(),
  }) : gameId = Value(gameId),
       positionMapping = Value(positionMapping);
  static Insertable<LineupEntry> custom({
    Expression<int>? id,
    Expression<int>? gameId,
    Expression<String>? positionMapping,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (positionMapping != null) 'position_mapping': positionMapping,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LineupsCompanion copyWith({
    Value<int>? id,
    Value<int>? gameId,
    Value<String>? positionMapping,
    Value<DateTime>? createdAt,
  }) {
    return LineupsCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      positionMapping: positionMapping ?? this.positionMapping,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (positionMapping.present) {
      map['position_mapping'] = Variable<String>(positionMapping.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LineupsCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('positionMapping: $positionMapping, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MatchEventsTable extends MatchEvents
    with TableInfo<$MatchEventsTable, MatchEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MatchEventsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id)',
    ),
  );
  static const VerificationMeta _quarterMeta = const VerificationMeta(
    'quarter',
  );
  @override
  late final GeneratedColumn<int> quarter = GeneratedColumn<int>(
    'quarter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _matchTimeSecondsMeta = const VerificationMeta(
    'matchTimeSeconds',
  );
  @override
  late final GeneratedColumn<int> matchTimeSeconds = GeneratedColumn<int>(
    'match_time_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<int> playerId = GeneratedColumn<int>(
    'player_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES players (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<String> position = GeneratedColumn<String>(
    'position',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSpecialScoringMeta = const VerificationMeta(
    'isSpecialScoring',
  );
  @override
  late final GeneratedColumn<bool> isSpecialScoring = GeneratedColumn<bool>(
    'is_special_scoring',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_special_scoring" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isHomeTeamMeta = const VerificationMeta(
    'isHomeTeam',
  );
  @override
  late final GeneratedColumn<bool> isHomeTeam = GeneratedColumn<bool>(
    'is_home_team',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_home_team" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _shotXMeta = const VerificationMeta('shotX');
  @override
  late final GeneratedColumn<double> shotX = GeneratedColumn<double>(
    'shot_x',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shotYMeta = const VerificationMeta('shotY');
  @override
  late final GeneratedColumn<double> shotY = GeneratedColumn<double>(
    'shot_y',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    quarter,
    matchTimeSeconds,
    timestamp,
    type,
    playerId,
    position,
    isSpecialScoring,
    isHomeTeam,
    shotX,
    shotY,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'match_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<MatchEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('quarter')) {
      context.handle(
        _quarterMeta,
        quarter.isAcceptableOrUnknown(data['quarter']!, _quarterMeta),
      );
    } else if (isInserting) {
      context.missing(_quarterMeta);
    }
    if (data.containsKey('match_time_seconds')) {
      context.handle(
        _matchTimeSecondsMeta,
        matchTimeSeconds.isAcceptableOrUnknown(
          data['match_time_seconds']!,
          _matchTimeSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_matchTimeSecondsMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    if (data.containsKey('is_special_scoring')) {
      context.handle(
        _isSpecialScoringMeta,
        isSpecialScoring.isAcceptableOrUnknown(
          data['is_special_scoring']!,
          _isSpecialScoringMeta,
        ),
      );
    }
    if (data.containsKey('is_home_team')) {
      context.handle(
        _isHomeTeamMeta,
        isHomeTeam.isAcceptableOrUnknown(
          data['is_home_team']!,
          _isHomeTeamMeta,
        ),
      );
    }
    if (data.containsKey('shot_x')) {
      context.handle(
        _shotXMeta,
        shotX.isAcceptableOrUnknown(data['shot_x']!, _shotXMeta),
      );
    }
    if (data.containsKey('shot_y')) {
      context.handle(
        _shotYMeta,
        shotY.isAcceptableOrUnknown(data['shot_y']!, _shotYMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MatchEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MatchEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      quarter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quarter'],
      )!,
      matchTimeSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}match_time_seconds'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}player_id'],
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}position'],
      ),
      isSpecialScoring: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_special_scoring'],
      )!,
      isHomeTeam: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_home_team'],
      )!,
      shotX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}shot_x'],
      ),
      shotY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}shot_y'],
      ),
    );
  }

  @override
  $MatchEventsTable createAlias(String alias) {
    return $MatchEventsTable(attachedDatabase, alias);
  }
}

class MatchEvent extends DataClass implements Insertable<MatchEvent> {
  final int id;
  final int gameId;
  final int quarter;
  final int matchTimeSeconds;
  final DateTime timestamp;
  final String type;
  final int? playerId;
  final String? position;
  final bool isSpecialScoring;
  final bool isHomeTeam;
  final double? shotX;
  final double? shotY;
  const MatchEvent({
    required this.id,
    required this.gameId,
    required this.quarter,
    required this.matchTimeSeconds,
    required this.timestamp,
    required this.type,
    this.playerId,
    this.position,
    required this.isSpecialScoring,
    required this.isHomeTeam,
    this.shotX,
    this.shotY,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game_id'] = Variable<int>(gameId);
    map['quarter'] = Variable<int>(quarter);
    map['match_time_seconds'] = Variable<int>(matchTimeSeconds);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || playerId != null) {
      map['player_id'] = Variable<int>(playerId);
    }
    if (!nullToAbsent || position != null) {
      map['position'] = Variable<String>(position);
    }
    map['is_special_scoring'] = Variable<bool>(isSpecialScoring);
    map['is_home_team'] = Variable<bool>(isHomeTeam);
    if (!nullToAbsent || shotX != null) {
      map['shot_x'] = Variable<double>(shotX);
    }
    if (!nullToAbsent || shotY != null) {
      map['shot_y'] = Variable<double>(shotY);
    }
    return map;
  }

  MatchEventsCompanion toCompanion(bool nullToAbsent) {
    return MatchEventsCompanion(
      id: Value(id),
      gameId: Value(gameId),
      quarter: Value(quarter),
      matchTimeSeconds: Value(matchTimeSeconds),
      timestamp: Value(timestamp),
      type: Value(type),
      playerId: playerId == null && nullToAbsent
          ? const Value.absent()
          : Value(playerId),
      position: position == null && nullToAbsent
          ? const Value.absent()
          : Value(position),
      isSpecialScoring: Value(isSpecialScoring),
      isHomeTeam: Value(isHomeTeam),
      shotX: shotX == null && nullToAbsent
          ? const Value.absent()
          : Value(shotX),
      shotY: shotY == null && nullToAbsent
          ? const Value.absent()
          : Value(shotY),
    );
  }

  factory MatchEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MatchEvent(
      id: serializer.fromJson<int>(json['id']),
      gameId: serializer.fromJson<int>(json['gameId']),
      quarter: serializer.fromJson<int>(json['quarter']),
      matchTimeSeconds: serializer.fromJson<int>(json['matchTimeSeconds']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      type: serializer.fromJson<String>(json['type']),
      playerId: serializer.fromJson<int?>(json['playerId']),
      position: serializer.fromJson<String?>(json['position']),
      isSpecialScoring: serializer.fromJson<bool>(json['isSpecialScoring']),
      isHomeTeam: serializer.fromJson<bool>(json['isHomeTeam']),
      shotX: serializer.fromJson<double?>(json['shotX']),
      shotY: serializer.fromJson<double?>(json['shotY']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gameId': serializer.toJson<int>(gameId),
      'quarter': serializer.toJson<int>(quarter),
      'matchTimeSeconds': serializer.toJson<int>(matchTimeSeconds),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'type': serializer.toJson<String>(type),
      'playerId': serializer.toJson<int?>(playerId),
      'position': serializer.toJson<String?>(position),
      'isSpecialScoring': serializer.toJson<bool>(isSpecialScoring),
      'isHomeTeam': serializer.toJson<bool>(isHomeTeam),
      'shotX': serializer.toJson<double?>(shotX),
      'shotY': serializer.toJson<double?>(shotY),
    };
  }

  MatchEvent copyWith({
    int? id,
    int? gameId,
    int? quarter,
    int? matchTimeSeconds,
    DateTime? timestamp,
    String? type,
    Value<int?> playerId = const Value.absent(),
    Value<String?> position = const Value.absent(),
    bool? isSpecialScoring,
    bool? isHomeTeam,
    Value<double?> shotX = const Value.absent(),
    Value<double?> shotY = const Value.absent(),
  }) => MatchEvent(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    quarter: quarter ?? this.quarter,
    matchTimeSeconds: matchTimeSeconds ?? this.matchTimeSeconds,
    timestamp: timestamp ?? this.timestamp,
    type: type ?? this.type,
    playerId: playerId.present ? playerId.value : this.playerId,
    position: position.present ? position.value : this.position,
    isSpecialScoring: isSpecialScoring ?? this.isSpecialScoring,
    isHomeTeam: isHomeTeam ?? this.isHomeTeam,
    shotX: shotX.present ? shotX.value : this.shotX,
    shotY: shotY.present ? shotY.value : this.shotY,
  );
  MatchEvent copyWithCompanion(MatchEventsCompanion data) {
    return MatchEvent(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      quarter: data.quarter.present ? data.quarter.value : this.quarter,
      matchTimeSeconds: data.matchTimeSeconds.present
          ? data.matchTimeSeconds.value
          : this.matchTimeSeconds,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      type: data.type.present ? data.type.value : this.type,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      position: data.position.present ? data.position.value : this.position,
      isSpecialScoring: data.isSpecialScoring.present
          ? data.isSpecialScoring.value
          : this.isSpecialScoring,
      isHomeTeam: data.isHomeTeam.present
          ? data.isHomeTeam.value
          : this.isHomeTeam,
      shotX: data.shotX.present ? data.shotX.value : this.shotX,
      shotY: data.shotY.present ? data.shotY.value : this.shotY,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MatchEvent(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('quarter: $quarter, ')
          ..write('matchTimeSeconds: $matchTimeSeconds, ')
          ..write('timestamp: $timestamp, ')
          ..write('type: $type, ')
          ..write('playerId: $playerId, ')
          ..write('position: $position, ')
          ..write('isSpecialScoring: $isSpecialScoring, ')
          ..write('isHomeTeam: $isHomeTeam, ')
          ..write('shotX: $shotX, ')
          ..write('shotY: $shotY')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gameId,
    quarter,
    matchTimeSeconds,
    timestamp,
    type,
    playerId,
    position,
    isSpecialScoring,
    isHomeTeam,
    shotX,
    shotY,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MatchEvent &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.quarter == this.quarter &&
          other.matchTimeSeconds == this.matchTimeSeconds &&
          other.timestamp == this.timestamp &&
          other.type == this.type &&
          other.playerId == this.playerId &&
          other.position == this.position &&
          other.isSpecialScoring == this.isSpecialScoring &&
          other.isHomeTeam == this.isHomeTeam &&
          other.shotX == this.shotX &&
          other.shotY == this.shotY);
}

class MatchEventsCompanion extends UpdateCompanion<MatchEvent> {
  final Value<int> id;
  final Value<int> gameId;
  final Value<int> quarter;
  final Value<int> matchTimeSeconds;
  final Value<DateTime> timestamp;
  final Value<String> type;
  final Value<int?> playerId;
  final Value<String?> position;
  final Value<bool> isSpecialScoring;
  final Value<bool> isHomeTeam;
  final Value<double?> shotX;
  final Value<double?> shotY;
  const MatchEventsCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.quarter = const Value.absent(),
    this.matchTimeSeconds = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.type = const Value.absent(),
    this.playerId = const Value.absent(),
    this.position = const Value.absent(),
    this.isSpecialScoring = const Value.absent(),
    this.isHomeTeam = const Value.absent(),
    this.shotX = const Value.absent(),
    this.shotY = const Value.absent(),
  });
  MatchEventsCompanion.insert({
    this.id = const Value.absent(),
    required int gameId,
    required int quarter,
    required int matchTimeSeconds,
    required DateTime timestamp,
    required String type,
    this.playerId = const Value.absent(),
    this.position = const Value.absent(),
    this.isSpecialScoring = const Value.absent(),
    this.isHomeTeam = const Value.absent(),
    this.shotX = const Value.absent(),
    this.shotY = const Value.absent(),
  }) : gameId = Value(gameId),
       quarter = Value(quarter),
       matchTimeSeconds = Value(matchTimeSeconds),
       timestamp = Value(timestamp),
       type = Value(type);
  static Insertable<MatchEvent> custom({
    Expression<int>? id,
    Expression<int>? gameId,
    Expression<int>? quarter,
    Expression<int>? matchTimeSeconds,
    Expression<DateTime>? timestamp,
    Expression<String>? type,
    Expression<int>? playerId,
    Expression<String>? position,
    Expression<bool>? isSpecialScoring,
    Expression<bool>? isHomeTeam,
    Expression<double>? shotX,
    Expression<double>? shotY,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (quarter != null) 'quarter': quarter,
      if (matchTimeSeconds != null) 'match_time_seconds': matchTimeSeconds,
      if (timestamp != null) 'timestamp': timestamp,
      if (type != null) 'type': type,
      if (playerId != null) 'player_id': playerId,
      if (position != null) 'position': position,
      if (isSpecialScoring != null) 'is_special_scoring': isSpecialScoring,
      if (isHomeTeam != null) 'is_home_team': isHomeTeam,
      if (shotX != null) 'shot_x': shotX,
      if (shotY != null) 'shot_y': shotY,
    });
  }

  MatchEventsCompanion copyWith({
    Value<int>? id,
    Value<int>? gameId,
    Value<int>? quarter,
    Value<int>? matchTimeSeconds,
    Value<DateTime>? timestamp,
    Value<String>? type,
    Value<int?>? playerId,
    Value<String?>? position,
    Value<bool>? isSpecialScoring,
    Value<bool>? isHomeTeam,
    Value<double?>? shotX,
    Value<double?>? shotY,
  }) {
    return MatchEventsCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      quarter: quarter ?? this.quarter,
      matchTimeSeconds: matchTimeSeconds ?? this.matchTimeSeconds,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      playerId: playerId ?? this.playerId,
      position: position ?? this.position,
      isSpecialScoring: isSpecialScoring ?? this.isSpecialScoring,
      isHomeTeam: isHomeTeam ?? this.isHomeTeam,
      shotX: shotX ?? this.shotX,
      shotY: shotY ?? this.shotY,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (quarter.present) {
      map['quarter'] = Variable<int>(quarter.value);
    }
    if (matchTimeSeconds.present) {
      map['match_time_seconds'] = Variable<int>(matchTimeSeconds.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<int>(playerId.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(position.value);
    }
    if (isSpecialScoring.present) {
      map['is_special_scoring'] = Variable<bool>(isSpecialScoring.value);
    }
    if (isHomeTeam.present) {
      map['is_home_team'] = Variable<bool>(isHomeTeam.value);
    }
    if (shotX.present) {
      map['shot_x'] = Variable<double>(shotX.value);
    }
    if (shotY.present) {
      map['shot_y'] = Variable<double>(shotY.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MatchEventsCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('quarter: $quarter, ')
          ..write('matchTimeSeconds: $matchTimeSeconds, ')
          ..write('timestamp: $timestamp, ')
          ..write('type: $type, ')
          ..write('playerId: $playerId, ')
          ..write('position: $position, ')
          ..write('isSpecialScoring: $isSpecialScoring, ')
          ..write('isHomeTeam: $isHomeTeam, ')
          ..write('shotX: $shotX, ')
          ..write('shotY: $shotY')
          ..write(')'))
        .toString();
  }
}

class $CompetitionsTable extends Competitions
    with TableInfo<$CompetitionsTable, Competition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompetitionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seasonYearMeta = const VerificationMeta(
    'seasonYear',
  );
  @override
  late final GeneratedColumn<int> seasonYear = GeneratedColumn<int>(
    'season_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pointsWinMeta = const VerificationMeta(
    'pointsWin',
  );
  @override
  late final GeneratedColumn<int> pointsWin = GeneratedColumn<int>(
    'points_win',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _pointsDrawMeta = const VerificationMeta(
    'pointsDraw',
  );
  @override
  late final GeneratedColumn<int> pointsDraw = GeneratedColumn<int>(
    'points_draw',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _pointsLossMeta = const VerificationMeta(
    'pointsLoss',
  );
  @override
  late final GeneratedColumn<int> pointsLoss = GeneratedColumn<int>(
    'points_loss',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    seasonYear,
    pointsWin,
    pointsDraw,
    pointsLoss,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'competitions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Competition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('season_year')) {
      context.handle(
        _seasonYearMeta,
        seasonYear.isAcceptableOrUnknown(data['season_year']!, _seasonYearMeta),
      );
    }
    if (data.containsKey('points_win')) {
      context.handle(
        _pointsWinMeta,
        pointsWin.isAcceptableOrUnknown(data['points_win']!, _pointsWinMeta),
      );
    }
    if (data.containsKey('points_draw')) {
      context.handle(
        _pointsDrawMeta,
        pointsDraw.isAcceptableOrUnknown(data['points_draw']!, _pointsDrawMeta),
      );
    }
    if (data.containsKey('points_loss')) {
      context.handle(
        _pointsLossMeta,
        pointsLoss.isAcceptableOrUnknown(data['points_loss']!, _pointsLossMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Competition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Competition(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      seasonYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}season_year'],
      ),
      pointsWin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points_win'],
      )!,
      pointsDraw: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points_draw'],
      )!,
      pointsLoss: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points_loss'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $CompetitionsTable createAlias(String alias) {
    return $CompetitionsTable(attachedDatabase, alias);
  }
}

class Competition extends DataClass implements Insertable<Competition> {
  final int id;
  final String name;
  final int? seasonYear;
  final int pointsWin;
  final int pointsDraw;
  final int pointsLoss;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Competition({
    required this.id,
    required this.name,
    this.seasonYear,
    required this.pointsWin,
    required this.pointsDraw,
    required this.pointsLoss,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || seasonYear != null) {
      map['season_year'] = Variable<int>(seasonYear);
    }
    map['points_win'] = Variable<int>(pointsWin);
    map['points_draw'] = Variable<int>(pointsDraw);
    map['points_loss'] = Variable<int>(pointsLoss);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  CompetitionsCompanion toCompanion(bool nullToAbsent) {
    return CompetitionsCompanion(
      id: Value(id),
      name: Value(name),
      seasonYear: seasonYear == null && nullToAbsent
          ? const Value.absent()
          : Value(seasonYear),
      pointsWin: Value(pointsWin),
      pointsDraw: Value(pointsDraw),
      pointsLoss: Value(pointsLoss),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Competition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Competition(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      seasonYear: serializer.fromJson<int?>(json['seasonYear']),
      pointsWin: serializer.fromJson<int>(json['pointsWin']),
      pointsDraw: serializer.fromJson<int>(json['pointsDraw']),
      pointsLoss: serializer.fromJson<int>(json['pointsLoss']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'seasonYear': serializer.toJson<int?>(seasonYear),
      'pointsWin': serializer.toJson<int>(pointsWin),
      'pointsDraw': serializer.toJson<int>(pointsDraw),
      'pointsLoss': serializer.toJson<int>(pointsLoss),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Competition copyWith({
    int? id,
    String? name,
    Value<int?> seasonYear = const Value.absent(),
    int? pointsWin,
    int? pointsDraw,
    int? pointsLoss,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Competition(
    id: id ?? this.id,
    name: name ?? this.name,
    seasonYear: seasonYear.present ? seasonYear.value : this.seasonYear,
    pointsWin: pointsWin ?? this.pointsWin,
    pointsDraw: pointsDraw ?? this.pointsDraw,
    pointsLoss: pointsLoss ?? this.pointsLoss,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Competition copyWithCompanion(CompetitionsCompanion data) {
    return Competition(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      seasonYear: data.seasonYear.present
          ? data.seasonYear.value
          : this.seasonYear,
      pointsWin: data.pointsWin.present ? data.pointsWin.value : this.pointsWin,
      pointsDraw: data.pointsDraw.present
          ? data.pointsDraw.value
          : this.pointsDraw,
      pointsLoss: data.pointsLoss.present
          ? data.pointsLoss.value
          : this.pointsLoss,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Competition(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('seasonYear: $seasonYear, ')
          ..write('pointsWin: $pointsWin, ')
          ..write('pointsDraw: $pointsDraw, ')
          ..write('pointsLoss: $pointsLoss, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    seasonYear,
    pointsWin,
    pointsDraw,
    pointsLoss,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Competition &&
          other.id == this.id &&
          other.name == this.name &&
          other.seasonYear == this.seasonYear &&
          other.pointsWin == this.pointsWin &&
          other.pointsDraw == this.pointsDraw &&
          other.pointsLoss == this.pointsLoss &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CompetitionsCompanion extends UpdateCompanion<Competition> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> seasonYear;
  final Value<int> pointsWin;
  final Value<int> pointsDraw;
  final Value<int> pointsLoss;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const CompetitionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.seasonYear = const Value.absent(),
    this.pointsWin = const Value.absent(),
    this.pointsDraw = const Value.absent(),
    this.pointsLoss = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CompetitionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.seasonYear = const Value.absent(),
    this.pointsWin = const Value.absent(),
    this.pointsDraw = const Value.absent(),
    this.pointsLoss = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Competition> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? seasonYear,
    Expression<int>? pointsWin,
    Expression<int>? pointsDraw,
    Expression<int>? pointsLoss,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (seasonYear != null) 'season_year': seasonYear,
      if (pointsWin != null) 'points_win': pointsWin,
      if (pointsDraw != null) 'points_draw': pointsDraw,
      if (pointsLoss != null) 'points_loss': pointsLoss,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CompetitionsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int?>? seasonYear,
    Value<int>? pointsWin,
    Value<int>? pointsDraw,
    Value<int>? pointsLoss,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return CompetitionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      seasonYear: seasonYear ?? this.seasonYear,
      pointsWin: pointsWin ?? this.pointsWin,
      pointsDraw: pointsDraw ?? this.pointsDraw,
      pointsLoss: pointsLoss ?? this.pointsLoss,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (seasonYear.present) {
      map['season_year'] = Variable<int>(seasonYear.value);
    }
    if (pointsWin.present) {
      map['points_win'] = Variable<int>(pointsWin.value);
    }
    if (pointsDraw.present) {
      map['points_draw'] = Variable<int>(pointsDraw.value);
    }
    if (pointsLoss.present) {
      map['points_loss'] = Variable<int>(pointsLoss.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompetitionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('seasonYear: $seasonYear, ')
          ..write('pointsWin: $pointsWin, ')
          ..write('pointsDraw: $pointsDraw, ')
          ..write('pointsLoss: $pointsLoss, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $VenuesTable extends Venues with TableInfo<$VenuesTable, Venue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VenuesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _indoorMeta = const VerificationMeta('indoor');
  @override
  late final GeneratedColumn<bool> indoor = GeneratedColumn<bool>(
    'indoor',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("indoor" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    address,
    indoor,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'venues';
  @override
  VerificationContext validateIntegrity(
    Insertable<Venue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('indoor')) {
      context.handle(
        _indoorMeta,
        indoor.isAcceptableOrUnknown(data['indoor']!, _indoorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Venue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Venue(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      indoor: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}indoor'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $VenuesTable createAlias(String alias) {
    return $VenuesTable(attachedDatabase, alias);
  }
}

class Venue extends DataClass implements Insertable<Venue> {
  final int id;
  final String name;
  final String? address;
  final bool indoor;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Venue({
    required this.id,
    required this.name,
    this.address,
    required this.indoor,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['indoor'] = Variable<bool>(indoor);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  VenuesCompanion toCompanion(bool nullToAbsent) {
    return VenuesCompanion(
      id: Value(id),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      indoor: Value(indoor),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Venue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Venue(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      indoor: serializer.fromJson<bool>(json['indoor']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'indoor': serializer.toJson<bool>(indoor),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Venue copyWith({
    int? id,
    String? name,
    Value<String?> address = const Value.absent(),
    bool? indoor,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Venue(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address.present ? address.value : this.address,
    indoor: indoor ?? this.indoor,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Venue copyWithCompanion(VenuesCompanion data) {
    return Venue(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      indoor: data.indoor.present ? data.indoor.value : this.indoor,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Venue(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('indoor: $indoor, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, address, indoor, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Venue &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.indoor == this.indoor &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VenuesCompanion extends UpdateCompanion<Venue> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> address;
  final Value<bool> indoor;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const VenuesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.indoor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  VenuesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.address = const Value.absent(),
    this.indoor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Venue> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<bool>? indoor,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (indoor != null) 'indoor': indoor,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  VenuesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? address,
    Value<bool>? indoor,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return VenuesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      indoor: indoor ?? this.indoor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (indoor.present) {
      map['indoor'] = Variable<bool>(indoor.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VenuesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('indoor: $indoor, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TeamsTable teams = $TeamsTable(this);
  late final $PlayersTable players = $PlayersTable(this);
  late final $GamesTable games = $GamesTable(this);
  late final $LineupsTable lineups = $LineupsTable(this);
  late final $MatchEventsTable matchEvents = $MatchEventsTable(this);
  late final $CompetitionsTable competitions = $CompetitionsTable(this);
  late final $VenuesTable venues = $VenuesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    teams,
    players,
    games,
    lineups,
    matchEvents,
    competitions,
    venues,
  ];
}

typedef $$TeamsTableCreateCompanionBuilder =
    TeamsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> colorHex,
      Value<DateTime> createdAt,
    });
typedef $$TeamsTableUpdateCompanionBuilder =
    TeamsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> colorHex,
      Value<DateTime> createdAt,
    });

final class $$TeamsTableReferences
    extends BaseReferences<_$AppDatabase, $TeamsTable, Team> {
  $$TeamsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlayersTable, List<Player>> _playersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.players,
    aliasName: $_aliasNameGenerator(db.teams.id, db.players.teamId),
  );

  $$PlayersTableProcessedTableManager get playersRefs {
    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.teamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TeamsTableFilterComposer extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> playersRefs(
    Expression<bool> Function($$PlayersTableFilterComposer f) f,
  ) {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TeamsTableOrderingComposer
    extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TeamsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> playersRefs<T extends Object>(
    Expression<T> Function($$PlayersTableAnnotationComposer a) f,
  ) {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TeamsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TeamsTable,
          Team,
          $$TeamsTableFilterComposer,
          $$TeamsTableOrderingComposer,
          $$TeamsTableAnnotationComposer,
          $$TeamsTableCreateCompanionBuilder,
          $$TeamsTableUpdateCompanionBuilder,
          (Team, $$TeamsTableReferences),
          Team,
          PrefetchHooks Function({bool playersRefs})
        > {
  $$TeamsTableTableManager(_$AppDatabase db, $TeamsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeamsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeamsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeamsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TeamsCompanion(
                id: id,
                name: name,
                colorHex: colorHex,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> colorHex = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TeamsCompanion.insert(
                id: id,
                name: name,
                colorHex: colorHex,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TeamsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({playersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (playersRefs) db.players],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (playersRefs)
                    await $_getPrefetchedData<Team, $TeamsTable, Player>(
                      currentTable: table,
                      referencedTable: $$TeamsTableReferences._playersRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$TeamsTableReferences(db, table, p0).playersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.teamId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TeamsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TeamsTable,
      Team,
      $$TeamsTableFilterComposer,
      $$TeamsTableOrderingComposer,
      $$TeamsTableAnnotationComposer,
      $$TeamsTableCreateCompanionBuilder,
      $$TeamsTableUpdateCompanionBuilder,
      (Team, $$TeamsTableReferences),
      Team,
      PrefetchHooks Function({bool playersRefs})
    >;
typedef $$PlayersTableCreateCompanionBuilder =
    PlayersCompanion Function({
      Value<int> id,
      required String firstName,
      required String lastName,
      Value<String?> nickname,
      Value<int?> primaryNumber,
      Value<int?> teamId,
      required String preferredPositions,
      Value<DateTime?> dob,
      Value<int?> heightCm,
      Value<DateTime> createdAt,
    });
typedef $$PlayersTableUpdateCompanionBuilder =
    PlayersCompanion Function({
      Value<int> id,
      Value<String> firstName,
      Value<String> lastName,
      Value<String?> nickname,
      Value<int?> primaryNumber,
      Value<int?> teamId,
      Value<String> preferredPositions,
      Value<DateTime?> dob,
      Value<int?> heightCm,
      Value<DateTime> createdAt,
    });

final class $$PlayersTableReferences
    extends BaseReferences<_$AppDatabase, $PlayersTable, Player> {
  $$PlayersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TeamsTable _teamIdTable(_$AppDatabase db) => db.teams.createAlias(
    $_aliasNameGenerator(db.players.teamId, db.teams.id),
  );

  $$TeamsTableProcessedTableManager? get teamId {
    final $_column = $_itemColumn<int>('team_id');
    if ($_column == null) return null;
    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MatchEventsTable, List<MatchEvent>>
  _matchEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.matchEvents,
    aliasName: $_aliasNameGenerator(db.players.id, db.matchEvents.playerId),
  );

  $$MatchEventsTableProcessedTableManager get matchEventsRefs {
    final manager = $$MatchEventsTableTableManager(
      $_db,
      $_db.matchEvents,
    ).filter((f) => f.playerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_matchEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlayersTableFilterComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableFilterComposer({
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

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get primaryNumber => $composableBuilder(
    column: $table.primaryNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredPositions => $composableBuilder(
    column: $table.preferredPositions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dob => $composableBuilder(
    column: $table.dob,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TeamsTableFilterComposer get teamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> matchEventsRefs(
    Expression<bool> Function($$MatchEventsTableFilterComposer f) f,
  ) {
    final $$MatchEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matchEvents,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchEventsTableFilterComposer(
            $db: $db,
            $table: $db.matchEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableOrderingComposer({
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

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get primaryNumber => $composableBuilder(
    column: $table.primaryNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredPositions => $composableBuilder(
    column: $table.preferredPositions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dob => $composableBuilder(
    column: $table.dob,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TeamsTableOrderingComposer get teamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<int> get primaryNumber => $composableBuilder(
    column: $table.primaryNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferredPositions => $composableBuilder(
    column: $table.preferredPositions,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dob =>
      $composableBuilder(column: $table.dob, builder: (column) => column);

  GeneratedColumn<int> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TeamsTableAnnotationComposer get teamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> matchEventsRefs<T extends Object>(
    Expression<T> Function($$MatchEventsTableAnnotationComposer a) f,
  ) {
    final $$MatchEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matchEvents,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.matchEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayersTable,
          Player,
          $$PlayersTableFilterComposer,
          $$PlayersTableOrderingComposer,
          $$PlayersTableAnnotationComposer,
          $$PlayersTableCreateCompanionBuilder,
          $$PlayersTableUpdateCompanionBuilder,
          (Player, $$PlayersTableReferences),
          Player,
          PrefetchHooks Function({bool teamId, bool matchEventsRefs})
        > {
  $$PlayersTableTableManager(_$AppDatabase db, $PlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String?> nickname = const Value.absent(),
                Value<int?> primaryNumber = const Value.absent(),
                Value<int?> teamId = const Value.absent(),
                Value<String> preferredPositions = const Value.absent(),
                Value<DateTime?> dob = const Value.absent(),
                Value<int?> heightCm = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PlayersCompanion(
                id: id,
                firstName: firstName,
                lastName: lastName,
                nickname: nickname,
                primaryNumber: primaryNumber,
                teamId: teamId,
                preferredPositions: preferredPositions,
                dob: dob,
                heightCm: heightCm,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String firstName,
                required String lastName,
                Value<String?> nickname = const Value.absent(),
                Value<int?> primaryNumber = const Value.absent(),
                Value<int?> teamId = const Value.absent(),
                required String preferredPositions,
                Value<DateTime?> dob = const Value.absent(),
                Value<int?> heightCm = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PlayersCompanion.insert(
                id: id,
                firstName: firstName,
                lastName: lastName,
                nickname: nickname,
                primaryNumber: primaryNumber,
                teamId: teamId,
                preferredPositions: preferredPositions,
                dob: dob,
                heightCm: heightCm,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlayersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({teamId = false, matchEventsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (matchEventsRefs) db.matchEvents],
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
                    if (teamId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.teamId,
                                referencedTable: $$PlayersTableReferences
                                    ._teamIdTable(db),
                                referencedColumn: $$PlayersTableReferences
                                    ._teamIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (matchEventsRefs)
                    await $_getPrefetchedData<
                      Player,
                      $PlayersTable,
                      MatchEvent
                    >(
                      currentTable: table,
                      referencedTable: $$PlayersTableReferences
                          ._matchEventsRefsTable(db),
                      managerFromTypedResult: (p0) => $$PlayersTableReferences(
                        db,
                        table,
                        p0,
                      ).matchEventsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.playerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayersTable,
      Player,
      $$PlayersTableFilterComposer,
      $$PlayersTableOrderingComposer,
      $$PlayersTableAnnotationComposer,
      $$PlayersTableCreateCompanionBuilder,
      $$PlayersTableUpdateCompanionBuilder,
      (Player, $$PlayersTableReferences),
      Player,
      PrefetchHooks Function({bool teamId, bool matchEventsRefs})
    >;
typedef $$GamesTableCreateCompanionBuilder =
    GamesCompanion Function({
      Value<int> id,
      Value<String> homeTeamName,
      required String opponentName,
      required String competitionName,
      Value<String?> venueName,
      required DateTime scheduledAt,
      Value<int?> competitionId,
      Value<int?> venueId,
      Value<int?> homeTeamId,
      Value<int?> opponentTeamId,
      required String format,
      required String status,
      Value<String> trackingMode,
      Value<bool> ourFirstCentrePass,
      Value<bool> isSuperShot,
      Value<String> fast5PowerPlayMode,
      Value<int?> homePowerPlayQuarter,
      Value<int?> awayPowerPlayQuarter,
      Value<int?> homeScore,
      Value<int?> awayScore,
      Value<int> quarterDurationMinutes,
      Value<int> totalQuarters,
      Value<DateTime> createdAt,
    });
typedef $$GamesTableUpdateCompanionBuilder =
    GamesCompanion Function({
      Value<int> id,
      Value<String> homeTeamName,
      Value<String> opponentName,
      Value<String> competitionName,
      Value<String?> venueName,
      Value<DateTime> scheduledAt,
      Value<int?> competitionId,
      Value<int?> venueId,
      Value<int?> homeTeamId,
      Value<int?> opponentTeamId,
      Value<String> format,
      Value<String> status,
      Value<String> trackingMode,
      Value<bool> ourFirstCentrePass,
      Value<bool> isSuperShot,
      Value<String> fast5PowerPlayMode,
      Value<int?> homePowerPlayQuarter,
      Value<int?> awayPowerPlayQuarter,
      Value<int?> homeScore,
      Value<int?> awayScore,
      Value<int> quarterDurationMinutes,
      Value<int> totalQuarters,
      Value<DateTime> createdAt,
    });

final class $$GamesTableReferences
    extends BaseReferences<_$AppDatabase, $GamesTable, GameEntry> {
  $$GamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LineupsTable, List<LineupEntry>>
  _lineupsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.lineups,
    aliasName: $_aliasNameGenerator(db.games.id, db.lineups.gameId),
  );

  $$LineupsTableProcessedTableManager get lineupsRefs {
    final manager = $$LineupsTableTableManager(
      $_db,
      $_db.lineups,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_lineupsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MatchEventsTable, List<MatchEvent>>
  _matchEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.matchEvents,
    aliasName: $_aliasNameGenerator(db.games.id, db.matchEvents.gameId),
  );

  $$MatchEventsTableProcessedTableManager get matchEventsRefs {
    final manager = $$MatchEventsTableTableManager(
      $_db,
      $_db.matchEvents,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_matchEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GamesTableFilterComposer extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableFilterComposer({
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

  ColumnFilters<String> get homeTeamName => $composableBuilder(
    column: $table.homeTeamName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get opponentName => $composableBuilder(
    column: $table.opponentName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get competitionName => $composableBuilder(
    column: $table.competitionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get venueName => $composableBuilder(
    column: $table.venueName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get competitionId => $composableBuilder(
    column: $table.competitionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get venueId => $composableBuilder(
    column: $table.venueId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get homeTeamId => $composableBuilder(
    column: $table.homeTeamId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get opponentTeamId => $composableBuilder(
    column: $table.opponentTeamId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackingMode => $composableBuilder(
    column: $table.trackingMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ourFirstCentrePass => $composableBuilder(
    column: $table.ourFirstCentrePass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSuperShot => $composableBuilder(
    column: $table.isSuperShot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fast5PowerPlayMode => $composableBuilder(
    column: $table.fast5PowerPlayMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get homePowerPlayQuarter => $composableBuilder(
    column: $table.homePowerPlayQuarter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get awayPowerPlayQuarter => $composableBuilder(
    column: $table.awayPowerPlayQuarter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get homeScore => $composableBuilder(
    column: $table.homeScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get awayScore => $composableBuilder(
    column: $table.awayScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quarterDurationMinutes => $composableBuilder(
    column: $table.quarterDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuarters => $composableBuilder(
    column: $table.totalQuarters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> lineupsRefs(
    Expression<bool> Function($$LineupsTableFilterComposer f) f,
  ) {
    final $$LineupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lineups,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LineupsTableFilterComposer(
            $db: $db,
            $table: $db.lineups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> matchEventsRefs(
    Expression<bool> Function($$MatchEventsTableFilterComposer f) f,
  ) {
    final $$MatchEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matchEvents,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchEventsTableFilterComposer(
            $db: $db,
            $table: $db.matchEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamesTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableOrderingComposer({
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

  ColumnOrderings<String> get homeTeamName => $composableBuilder(
    column: $table.homeTeamName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get opponentName => $composableBuilder(
    column: $table.opponentName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get competitionName => $composableBuilder(
    column: $table.competitionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get venueName => $composableBuilder(
    column: $table.venueName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get competitionId => $composableBuilder(
    column: $table.competitionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get venueId => $composableBuilder(
    column: $table.venueId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get homeTeamId => $composableBuilder(
    column: $table.homeTeamId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get opponentTeamId => $composableBuilder(
    column: $table.opponentTeamId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackingMode => $composableBuilder(
    column: $table.trackingMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ourFirstCentrePass => $composableBuilder(
    column: $table.ourFirstCentrePass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSuperShot => $composableBuilder(
    column: $table.isSuperShot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fast5PowerPlayMode => $composableBuilder(
    column: $table.fast5PowerPlayMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get homePowerPlayQuarter => $composableBuilder(
    column: $table.homePowerPlayQuarter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get awayPowerPlayQuarter => $composableBuilder(
    column: $table.awayPowerPlayQuarter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get homeScore => $composableBuilder(
    column: $table.homeScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get awayScore => $composableBuilder(
    column: $table.awayScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quarterDurationMinutes => $composableBuilder(
    column: $table.quarterDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuarters => $composableBuilder(
    column: $table.totalQuarters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get homeTeamName => $composableBuilder(
    column: $table.homeTeamName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get opponentName => $composableBuilder(
    column: $table.opponentName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get competitionName => $composableBuilder(
    column: $table.competitionName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get venueName =>
      $composableBuilder(column: $table.venueName, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get competitionId => $composableBuilder(
    column: $table.competitionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get venueId =>
      $composableBuilder(column: $table.venueId, builder: (column) => column);

  GeneratedColumn<int> get homeTeamId => $composableBuilder(
    column: $table.homeTeamId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get opponentTeamId => $composableBuilder(
    column: $table.opponentTeamId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get trackingMode => $composableBuilder(
    column: $table.trackingMode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ourFirstCentrePass => $composableBuilder(
    column: $table.ourFirstCentrePass,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSuperShot => $composableBuilder(
    column: $table.isSuperShot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fast5PowerPlayMode => $composableBuilder(
    column: $table.fast5PowerPlayMode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get homePowerPlayQuarter => $composableBuilder(
    column: $table.homePowerPlayQuarter,
    builder: (column) => column,
  );

  GeneratedColumn<int> get awayPowerPlayQuarter => $composableBuilder(
    column: $table.awayPowerPlayQuarter,
    builder: (column) => column,
  );

  GeneratedColumn<int> get homeScore =>
      $composableBuilder(column: $table.homeScore, builder: (column) => column);

  GeneratedColumn<int> get awayScore =>
      $composableBuilder(column: $table.awayScore, builder: (column) => column);

  GeneratedColumn<int> get quarterDurationMinutes => $composableBuilder(
    column: $table.quarterDurationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalQuarters => $composableBuilder(
    column: $table.totalQuarters,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> lineupsRefs<T extends Object>(
    Expression<T> Function($$LineupsTableAnnotationComposer a) f,
  ) {
    final $$LineupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lineups,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LineupsTableAnnotationComposer(
            $db: $db,
            $table: $db.lineups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> matchEventsRefs<T extends Object>(
    Expression<T> Function($$MatchEventsTableAnnotationComposer a) f,
  ) {
    final $$MatchEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matchEvents,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.matchEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamesTable,
          GameEntry,
          $$GamesTableFilterComposer,
          $$GamesTableOrderingComposer,
          $$GamesTableAnnotationComposer,
          $$GamesTableCreateCompanionBuilder,
          $$GamesTableUpdateCompanionBuilder,
          (GameEntry, $$GamesTableReferences),
          GameEntry,
          PrefetchHooks Function({bool lineupsRefs, bool matchEventsRefs})
        > {
  $$GamesTableTableManager(_$AppDatabase db, $GamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> homeTeamName = const Value.absent(),
                Value<String> opponentName = const Value.absent(),
                Value<String> competitionName = const Value.absent(),
                Value<String?> venueName = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<int?> competitionId = const Value.absent(),
                Value<int?> venueId = const Value.absent(),
                Value<int?> homeTeamId = const Value.absent(),
                Value<int?> opponentTeamId = const Value.absent(),
                Value<String> format = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> trackingMode = const Value.absent(),
                Value<bool> ourFirstCentrePass = const Value.absent(),
                Value<bool> isSuperShot = const Value.absent(),
                Value<String> fast5PowerPlayMode = const Value.absent(),
                Value<int?> homePowerPlayQuarter = const Value.absent(),
                Value<int?> awayPowerPlayQuarter = const Value.absent(),
                Value<int?> homeScore = const Value.absent(),
                Value<int?> awayScore = const Value.absent(),
                Value<int> quarterDurationMinutes = const Value.absent(),
                Value<int> totalQuarters = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => GamesCompanion(
                id: id,
                homeTeamName: homeTeamName,
                opponentName: opponentName,
                competitionName: competitionName,
                venueName: venueName,
                scheduledAt: scheduledAt,
                competitionId: competitionId,
                venueId: venueId,
                homeTeamId: homeTeamId,
                opponentTeamId: opponentTeamId,
                format: format,
                status: status,
                trackingMode: trackingMode,
                ourFirstCentrePass: ourFirstCentrePass,
                isSuperShot: isSuperShot,
                fast5PowerPlayMode: fast5PowerPlayMode,
                homePowerPlayQuarter: homePowerPlayQuarter,
                awayPowerPlayQuarter: awayPowerPlayQuarter,
                homeScore: homeScore,
                awayScore: awayScore,
                quarterDurationMinutes: quarterDurationMinutes,
                totalQuarters: totalQuarters,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> homeTeamName = const Value.absent(),
                required String opponentName,
                required String competitionName,
                Value<String?> venueName = const Value.absent(),
                required DateTime scheduledAt,
                Value<int?> competitionId = const Value.absent(),
                Value<int?> venueId = const Value.absent(),
                Value<int?> homeTeamId = const Value.absent(),
                Value<int?> opponentTeamId = const Value.absent(),
                required String format,
                required String status,
                Value<String> trackingMode = const Value.absent(),
                Value<bool> ourFirstCentrePass = const Value.absent(),
                Value<bool> isSuperShot = const Value.absent(),
                Value<String> fast5PowerPlayMode = const Value.absent(),
                Value<int?> homePowerPlayQuarter = const Value.absent(),
                Value<int?> awayPowerPlayQuarter = const Value.absent(),
                Value<int?> homeScore = const Value.absent(),
                Value<int?> awayScore = const Value.absent(),
                Value<int> quarterDurationMinutes = const Value.absent(),
                Value<int> totalQuarters = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => GamesCompanion.insert(
                id: id,
                homeTeamName: homeTeamName,
                opponentName: opponentName,
                competitionName: competitionName,
                venueName: venueName,
                scheduledAt: scheduledAt,
                competitionId: competitionId,
                venueId: venueId,
                homeTeamId: homeTeamId,
                opponentTeamId: opponentTeamId,
                format: format,
                status: status,
                trackingMode: trackingMode,
                ourFirstCentrePass: ourFirstCentrePass,
                isSuperShot: isSuperShot,
                fast5PowerPlayMode: fast5PowerPlayMode,
                homePowerPlayQuarter: homePowerPlayQuarter,
                awayPowerPlayQuarter: awayPowerPlayQuarter,
                homeScore: homeScore,
                awayScore: awayScore,
                quarterDurationMinutes: quarterDurationMinutes,
                totalQuarters: totalQuarters,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GamesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({lineupsRefs = false, matchEventsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (lineupsRefs) db.lineups,
                    if (matchEventsRefs) db.matchEvents,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (lineupsRefs)
                        await $_getPrefetchedData<
                          GameEntry,
                          $GamesTable,
                          LineupEntry
                        >(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._lineupsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(db, table, p0).lineupsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (matchEventsRefs)
                        await $_getPrefetchedData<
                          GameEntry,
                          $GamesTable,
                          MatchEvent
                        >(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._matchEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).matchEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamesTable,
      GameEntry,
      $$GamesTableFilterComposer,
      $$GamesTableOrderingComposer,
      $$GamesTableAnnotationComposer,
      $$GamesTableCreateCompanionBuilder,
      $$GamesTableUpdateCompanionBuilder,
      (GameEntry, $$GamesTableReferences),
      GameEntry,
      PrefetchHooks Function({bool lineupsRefs, bool matchEventsRefs})
    >;
typedef $$LineupsTableCreateCompanionBuilder =
    LineupsCompanion Function({
      Value<int> id,
      required int gameId,
      required String positionMapping,
      Value<DateTime> createdAt,
    });
typedef $$LineupsTableUpdateCompanionBuilder =
    LineupsCompanion Function({
      Value<int> id,
      Value<int> gameId,
      Value<String> positionMapping,
      Value<DateTime> createdAt,
    });

final class $$LineupsTableReferences
    extends BaseReferences<_$AppDatabase, $LineupsTable, LineupEntry> {
  $$LineupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) => db.games.createAlias(
    $_aliasNameGenerator(db.lineups.gameId, db.games.id),
  );

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LineupsTableFilterComposer
    extends Composer<_$AppDatabase, $LineupsTable> {
  $$LineupsTableFilterComposer({
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

  ColumnFilters<String> get positionMapping => $composableBuilder(
    column: $table.positionMapping,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LineupsTableOrderingComposer
    extends Composer<_$AppDatabase, $LineupsTable> {
  $$LineupsTableOrderingComposer({
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

  ColumnOrderings<String> get positionMapping => $composableBuilder(
    column: $table.positionMapping,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LineupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LineupsTable> {
  $$LineupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get positionMapping => $composableBuilder(
    column: $table.positionMapping,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LineupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LineupsTable,
          LineupEntry,
          $$LineupsTableFilterComposer,
          $$LineupsTableOrderingComposer,
          $$LineupsTableAnnotationComposer,
          $$LineupsTableCreateCompanionBuilder,
          $$LineupsTableUpdateCompanionBuilder,
          (LineupEntry, $$LineupsTableReferences),
          LineupEntry,
          PrefetchHooks Function({bool gameId})
        > {
  $$LineupsTableTableManager(_$AppDatabase db, $LineupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LineupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LineupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LineupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<String> positionMapping = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LineupsCompanion(
                id: id,
                gameId: gameId,
                positionMapping: positionMapping,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int gameId,
                required String positionMapping,
                Value<DateTime> createdAt = const Value.absent(),
              }) => LineupsCompanion.insert(
                id: id,
                gameId: gameId,
                positionMapping: positionMapping,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LineupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false}) {
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
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable: $$LineupsTableReferences
                                    ._gameIdTable(db),
                                referencedColumn: $$LineupsTableReferences
                                    ._gameIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$LineupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LineupsTable,
      LineupEntry,
      $$LineupsTableFilterComposer,
      $$LineupsTableOrderingComposer,
      $$LineupsTableAnnotationComposer,
      $$LineupsTableCreateCompanionBuilder,
      $$LineupsTableUpdateCompanionBuilder,
      (LineupEntry, $$LineupsTableReferences),
      LineupEntry,
      PrefetchHooks Function({bool gameId})
    >;
typedef $$MatchEventsTableCreateCompanionBuilder =
    MatchEventsCompanion Function({
      Value<int> id,
      required int gameId,
      required int quarter,
      required int matchTimeSeconds,
      required DateTime timestamp,
      required String type,
      Value<int?> playerId,
      Value<String?> position,
      Value<bool> isSpecialScoring,
      Value<bool> isHomeTeam,
      Value<double?> shotX,
      Value<double?> shotY,
    });
typedef $$MatchEventsTableUpdateCompanionBuilder =
    MatchEventsCompanion Function({
      Value<int> id,
      Value<int> gameId,
      Value<int> quarter,
      Value<int> matchTimeSeconds,
      Value<DateTime> timestamp,
      Value<String> type,
      Value<int?> playerId,
      Value<String?> position,
      Value<bool> isSpecialScoring,
      Value<bool> isHomeTeam,
      Value<double?> shotX,
      Value<double?> shotY,
    });

final class $$MatchEventsTableReferences
    extends BaseReferences<_$AppDatabase, $MatchEventsTable, MatchEvent> {
  $$MatchEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) => db.games.createAlias(
    $_aliasNameGenerator(db.matchEvents.gameId, db.games.id),
  );

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlayersTable _playerIdTable(_$AppDatabase db) =>
      db.players.createAlias(
        $_aliasNameGenerator(db.matchEvents.playerId, db.players.id),
      );

  $$PlayersTableProcessedTableManager? get playerId {
    final $_column = $_itemColumn<int>('player_id');
    if ($_column == null) return null;
    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MatchEventsTableFilterComposer
    extends Composer<_$AppDatabase, $MatchEventsTable> {
  $$MatchEventsTableFilterComposer({
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

  ColumnFilters<int> get quarter => $composableBuilder(
    column: $table.quarter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get matchTimeSeconds => $composableBuilder(
    column: $table.matchTimeSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSpecialScoring => $composableBuilder(
    column: $table.isSpecialScoring,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isHomeTeam => $composableBuilder(
    column: $table.isHomeTeam,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get shotX => $composableBuilder(
    column: $table.shotX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get shotY => $composableBuilder(
    column: $table.shotY,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableFilterComposer get playerId {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $MatchEventsTable> {
  $$MatchEventsTableOrderingComposer({
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

  ColumnOrderings<int> get quarter => $composableBuilder(
    column: $table.quarter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get matchTimeSeconds => $composableBuilder(
    column: $table.matchTimeSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSpecialScoring => $composableBuilder(
    column: $table.isSpecialScoring,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isHomeTeam => $composableBuilder(
    column: $table.isHomeTeam,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get shotX => $composableBuilder(
    column: $table.shotX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get shotY => $composableBuilder(
    column: $table.shotY,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableOrderingComposer get playerId {
    final $$PlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableOrderingComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MatchEventsTable> {
  $$MatchEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quarter =>
      $composableBuilder(column: $table.quarter, builder: (column) => column);

  GeneratedColumn<int> get matchTimeSeconds => $composableBuilder(
    column: $table.matchTimeSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<bool> get isSpecialScoring => $composableBuilder(
    column: $table.isSpecialScoring,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isHomeTeam => $composableBuilder(
    column: $table.isHomeTeam,
    builder: (column) => column,
  );

  GeneratedColumn<double> get shotX =>
      $composableBuilder(column: $table.shotX, builder: (column) => column);

  GeneratedColumn<double> get shotY =>
      $composableBuilder(column: $table.shotY, builder: (column) => column);

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableAnnotationComposer get playerId {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MatchEventsTable,
          MatchEvent,
          $$MatchEventsTableFilterComposer,
          $$MatchEventsTableOrderingComposer,
          $$MatchEventsTableAnnotationComposer,
          $$MatchEventsTableCreateCompanionBuilder,
          $$MatchEventsTableUpdateCompanionBuilder,
          (MatchEvent, $$MatchEventsTableReferences),
          MatchEvent,
          PrefetchHooks Function({bool gameId, bool playerId})
        > {
  $$MatchEventsTableTableManager(_$AppDatabase db, $MatchEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MatchEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MatchEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MatchEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<int> quarter = const Value.absent(),
                Value<int> matchTimeSeconds = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int?> playerId = const Value.absent(),
                Value<String?> position = const Value.absent(),
                Value<bool> isSpecialScoring = const Value.absent(),
                Value<bool> isHomeTeam = const Value.absent(),
                Value<double?> shotX = const Value.absent(),
                Value<double?> shotY = const Value.absent(),
              }) => MatchEventsCompanion(
                id: id,
                gameId: gameId,
                quarter: quarter,
                matchTimeSeconds: matchTimeSeconds,
                timestamp: timestamp,
                type: type,
                playerId: playerId,
                position: position,
                isSpecialScoring: isSpecialScoring,
                isHomeTeam: isHomeTeam,
                shotX: shotX,
                shotY: shotY,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int gameId,
                required int quarter,
                required int matchTimeSeconds,
                required DateTime timestamp,
                required String type,
                Value<int?> playerId = const Value.absent(),
                Value<String?> position = const Value.absent(),
                Value<bool> isSpecialScoring = const Value.absent(),
                Value<bool> isHomeTeam = const Value.absent(),
                Value<double?> shotX = const Value.absent(),
                Value<double?> shotY = const Value.absent(),
              }) => MatchEventsCompanion.insert(
                id: id,
                gameId: gameId,
                quarter: quarter,
                matchTimeSeconds: matchTimeSeconds,
                timestamp: timestamp,
                type: type,
                playerId: playerId,
                position: position,
                isSpecialScoring: isSpecialScoring,
                isHomeTeam: isHomeTeam,
                shotX: shotX,
                shotY: shotY,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MatchEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false, playerId = false}) {
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
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable: $$MatchEventsTableReferences
                                    ._gameIdTable(db),
                                referencedColumn: $$MatchEventsTableReferences
                                    ._gameIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (playerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.playerId,
                                referencedTable: $$MatchEventsTableReferences
                                    ._playerIdTable(db),
                                referencedColumn: $$MatchEventsTableReferences
                                    ._playerIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$MatchEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MatchEventsTable,
      MatchEvent,
      $$MatchEventsTableFilterComposer,
      $$MatchEventsTableOrderingComposer,
      $$MatchEventsTableAnnotationComposer,
      $$MatchEventsTableCreateCompanionBuilder,
      $$MatchEventsTableUpdateCompanionBuilder,
      (MatchEvent, $$MatchEventsTableReferences),
      MatchEvent,
      PrefetchHooks Function({bool gameId, bool playerId})
    >;
typedef $$CompetitionsTableCreateCompanionBuilder =
    CompetitionsCompanion Function({
      Value<int> id,
      required String name,
      Value<int?> seasonYear,
      Value<int> pointsWin,
      Value<int> pointsDraw,
      Value<int> pointsLoss,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$CompetitionsTableUpdateCompanionBuilder =
    CompetitionsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int?> seasonYear,
      Value<int> pointsWin,
      Value<int> pointsDraw,
      Value<int> pointsLoss,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

class $$CompetitionsTableFilterComposer
    extends Composer<_$AppDatabase, $CompetitionsTable> {
  $$CompetitionsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seasonYear => $composableBuilder(
    column: $table.seasonYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointsWin => $composableBuilder(
    column: $table.pointsWin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointsDraw => $composableBuilder(
    column: $table.pointsDraw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointsLoss => $composableBuilder(
    column: $table.pointsLoss,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CompetitionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompetitionsTable> {
  $$CompetitionsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seasonYear => $composableBuilder(
    column: $table.seasonYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointsWin => $composableBuilder(
    column: $table.pointsWin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointsDraw => $composableBuilder(
    column: $table.pointsDraw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointsLoss => $composableBuilder(
    column: $table.pointsLoss,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompetitionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompetitionsTable> {
  $$CompetitionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get seasonYear => $composableBuilder(
    column: $table.seasonYear,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pointsWin =>
      $composableBuilder(column: $table.pointsWin, builder: (column) => column);

  GeneratedColumn<int> get pointsDraw => $composableBuilder(
    column: $table.pointsDraw,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pointsLoss => $composableBuilder(
    column: $table.pointsLoss,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CompetitionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompetitionsTable,
          Competition,
          $$CompetitionsTableFilterComposer,
          $$CompetitionsTableOrderingComposer,
          $$CompetitionsTableAnnotationComposer,
          $$CompetitionsTableCreateCompanionBuilder,
          $$CompetitionsTableUpdateCompanionBuilder,
          (
            Competition,
            BaseReferences<_$AppDatabase, $CompetitionsTable, Competition>,
          ),
          Competition,
          PrefetchHooks Function()
        > {
  $$CompetitionsTableTableManager(_$AppDatabase db, $CompetitionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompetitionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompetitionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompetitionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> seasonYear = const Value.absent(),
                Value<int> pointsWin = const Value.absent(),
                Value<int> pointsDraw = const Value.absent(),
                Value<int> pointsLoss = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => CompetitionsCompanion(
                id: id,
                name: name,
                seasonYear: seasonYear,
                pointsWin: pointsWin,
                pointsDraw: pointsDraw,
                pointsLoss: pointsLoss,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int?> seasonYear = const Value.absent(),
                Value<int> pointsWin = const Value.absent(),
                Value<int> pointsDraw = const Value.absent(),
                Value<int> pointsLoss = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => CompetitionsCompanion.insert(
                id: id,
                name: name,
                seasonYear: seasonYear,
                pointsWin: pointsWin,
                pointsDraw: pointsDraw,
                pointsLoss: pointsLoss,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CompetitionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompetitionsTable,
      Competition,
      $$CompetitionsTableFilterComposer,
      $$CompetitionsTableOrderingComposer,
      $$CompetitionsTableAnnotationComposer,
      $$CompetitionsTableCreateCompanionBuilder,
      $$CompetitionsTableUpdateCompanionBuilder,
      (
        Competition,
        BaseReferences<_$AppDatabase, $CompetitionsTable, Competition>,
      ),
      Competition,
      PrefetchHooks Function()
    >;
typedef $$VenuesTableCreateCompanionBuilder =
    VenuesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> address,
      Value<bool> indoor,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$VenuesTableUpdateCompanionBuilder =
    VenuesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> address,
      Value<bool> indoor,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

class $$VenuesTableFilterComposer
    extends Composer<_$AppDatabase, $VenuesTable> {
  $$VenuesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get indoor => $composableBuilder(
    column: $table.indoor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VenuesTableOrderingComposer
    extends Composer<_$AppDatabase, $VenuesTable> {
  $$VenuesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get indoor => $composableBuilder(
    column: $table.indoor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VenuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VenuesTable> {
  $$VenuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<bool> get indoor =>
      $composableBuilder(column: $table.indoor, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$VenuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VenuesTable,
          Venue,
          $$VenuesTableFilterComposer,
          $$VenuesTableOrderingComposer,
          $$VenuesTableAnnotationComposer,
          $$VenuesTableCreateCompanionBuilder,
          $$VenuesTableUpdateCompanionBuilder,
          (Venue, BaseReferences<_$AppDatabase, $VenuesTable, Venue>),
          Venue,
          PrefetchHooks Function()
        > {
  $$VenuesTableTableManager(_$AppDatabase db, $VenuesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VenuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VenuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VenuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<bool> indoor = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => VenuesCompanion(
                id: id,
                name: name,
                address: address,
                indoor: indoor,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> address = const Value.absent(),
                Value<bool> indoor = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => VenuesCompanion.insert(
                id: id,
                name: name,
                address: address,
                indoor: indoor,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VenuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VenuesTable,
      Venue,
      $$VenuesTableFilterComposer,
      $$VenuesTableOrderingComposer,
      $$VenuesTableAnnotationComposer,
      $$VenuesTableCreateCompanionBuilder,
      $$VenuesTableUpdateCompanionBuilder,
      (Venue, BaseReferences<_$AppDatabase, $VenuesTable, Venue>),
      Venue,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TeamsTableTableManager get teams =>
      $$TeamsTableTableManager(_db, _db.teams);
  $$PlayersTableTableManager get players =>
      $$PlayersTableTableManager(_db, _db.players);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$LineupsTableTableManager get lineups =>
      $$LineupsTableTableManager(_db, _db.lineups);
  $$MatchEventsTableTableManager get matchEvents =>
      $$MatchEventsTableTableManager(_db, _db.matchEvents);
  $$CompetitionsTableTableManager get competitions =>
      $$CompetitionsTableTableManager(_db, _db.competitions);
  $$VenuesTableTableManager get venues =>
      $$VenuesTableTableManager(_db, _db.venues);
}
