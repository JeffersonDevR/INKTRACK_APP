// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LocalesTable extends Locales with TableInfo<$LocalesTable, LocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('tienda'),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActivoMeta = const VerificationMeta(
    'isActivo',
  );
  @override
  late final GeneratedColumn<bool> isActivo = GeneratedColumn<bool>(
    'is_activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
    nombre,
    direccion,
    telefono,
    tipo,
    userId,
    isActivo,
    syncStatus,
    lastSyncedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'locales';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('is_activo')) {
      context.handle(
        _isActivoMeta,
        isActivo.isAcceptableOrUnknown(data['is_activo']!, _isActivoMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
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
  LocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      ),
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      ),
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      isActivo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_activo'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $LocalesTable createAlias(String alias) {
    return $LocalesTable(attachedDatabase, alias);
  }
}

class LocalData extends DataClass implements Insertable<LocalData> {
  final String id;
  final String nombre;
  final String? direccion;
  final String? telefono;
  final String tipo;
  final String? userId;
  final bool isActivo;
  final String syncStatus;
  final DateTime? lastSyncedAt;
  final DateTime? updatedAt;
  const LocalData({
    required this.id,
    required this.nombre,
    this.direccion,
    this.telefono,
    required this.tipo,
    this.userId,
    required this.isActivo,
    required this.syncStatus,
    this.lastSyncedAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || direccion != null) {
      map['direccion'] = Variable<String>(direccion);
    }
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    map['tipo'] = Variable<String>(tipo);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['is_activo'] = Variable<bool>(isActivo);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  LocalesCompanion toCompanion(bool nullToAbsent) {
    return LocalesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      direccion: direccion == null && nullToAbsent
          ? const Value.absent()
          : Value(direccion),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      tipo: Value(tipo),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      isActivo: Value(isActivo),
      syncStatus: Value(syncStatus),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory LocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalData(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      direccion: serializer.fromJson<String?>(json['direccion']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      tipo: serializer.fromJson<String>(json['tipo']),
      userId: serializer.fromJson<String?>(json['userId']),
      isActivo: serializer.fromJson<bool>(json['isActivo']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'direccion': serializer.toJson<String?>(direccion),
      'telefono': serializer.toJson<String?>(telefono),
      'tipo': serializer.toJson<String>(tipo),
      'userId': serializer.toJson<String?>(userId),
      'isActivo': serializer.toJson<bool>(isActivo),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  LocalData copyWith({
    String? id,
    String? nombre,
    Value<String?> direccion = const Value.absent(),
    Value<String?> telefono = const Value.absent(),
    String? tipo,
    Value<String?> userId = const Value.absent(),
    bool? isActivo,
    String? syncStatus,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => LocalData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    direccion: direccion.present ? direccion.value : this.direccion,
    telefono: telefono.present ? telefono.value : this.telefono,
    tipo: tipo ?? this.tipo,
    userId: userId.present ? userId.value : this.userId,
    isActivo: isActivo ?? this.isActivo,
    syncStatus: syncStatus ?? this.syncStatus,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  LocalData copyWithCompanion(LocalesCompanion data) {
    return LocalData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      userId: data.userId.present ? data.userId.value : this.userId,
      isActivo: data.isActivo.present ? data.isActivo.value : this.isActivo,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('direccion: $direccion, ')
          ..write('telefono: $telefono, ')
          ..write('tipo: $tipo, ')
          ..write('userId: $userId, ')
          ..write('isActivo: $isActivo, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    direccion,
    telefono,
    tipo,
    userId,
    isActivo,
    syncStatus,
    lastSyncedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.direccion == this.direccion &&
          other.telefono == this.telefono &&
          other.tipo == this.tipo &&
          other.userId == this.userId &&
          other.isActivo == this.isActivo &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.updatedAt == this.updatedAt);
}

class LocalesCompanion extends UpdateCompanion<LocalData> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String?> direccion;
  final Value<String?> telefono;
  final Value<String> tipo;
  final Value<String?> userId;
  final Value<bool> isActivo;
  final Value<String> syncStatus;
  final Value<DateTime?> lastSyncedAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const LocalesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.direccion = const Value.absent(),
    this.telefono = const Value.absent(),
    this.tipo = const Value.absent(),
    this.userId = const Value.absent(),
    this.isActivo = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalesCompanion.insert({
    required String id,
    required String nombre,
    this.direccion = const Value.absent(),
    this.telefono = const Value.absent(),
    this.tipo = const Value.absent(),
    this.userId = const Value.absent(),
    this.isActivo = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre);
  static Insertable<LocalData> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? direccion,
    Expression<String>? telefono,
    Expression<String>? tipo,
    Expression<String>? userId,
    Expression<bool>? isActivo,
    Expression<String>? syncStatus,
    Expression<DateTime>? lastSyncedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (direccion != null) 'direccion': direccion,
      if (telefono != null) 'telefono': telefono,
      if (tipo != null) 'tipo': tipo,
      if (userId != null) 'user_id': userId,
      if (isActivo != null) 'is_activo': isActivo,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalesCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String?>? direccion,
    Value<String?>? telefono,
    Value<String>? tipo,
    Value<String?>? userId,
    Value<bool>? isActivo,
    Value<String>? syncStatus,
    Value<DateTime?>? lastSyncedAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      tipo: tipo ?? this.tipo,
      userId: userId ?? this.userId,
      isActivo: isActivo ?? this.isActivo,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (isActivo.present) {
      map['is_activo'] = Variable<bool>(isActivo.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('direccion: $direccion, ')
          ..write('telefono: $telefono, ')
          ..write('tipo: $tipo, ')
          ..write('userId: $userId, ')
          ..write('isActivo: $isActivo, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClientesTable extends Clientes
    with TableInfo<$ClientesTable, ClienteData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locales (id)',
    ),
  );
  static const VerificationMeta _esFiadoMeta = const VerificationMeta(
    'esFiado',
  );
  @override
  late final GeneratedColumn<bool> esFiado = GeneratedColumn<bool>(
    'es_fiado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_fiado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _saldoPendienteMeta = const VerificationMeta(
    'saldoPendiente',
  );
  @override
  late final GeneratedColumn<double> saldoPendiente = GeneratedColumn<double>(
    'saldo_pendiente',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isActivoMeta = const VerificationMeta(
    'isActivo',
  );
  @override
  late final GeneratedColumn<bool> isActivo = GeneratedColumn<bool>(
    'is_activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
  static const VerificationMeta _limiteCreditoMeta = const VerificationMeta(
    'limiteCredito',
  );
  @override
  late final GeneratedColumn<double> limiteCredito = GeneratedColumn<double>(
    'limite_credito',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _promesaPagoMeta = const VerificationMeta(
    'promesaPago',
  );
  @override
  late final GeneratedColumn<DateTime> promesaPago = GeneratedColumn<DateTime>(
    'promesa_pago',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    telefono,
    email,
    localId,
    esFiado,
    saldoPendiente,
    isActivo,
    syncStatus,
    lastSyncedAt,
    updatedAt,
    limiteCredito,
    promesaPago,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClienteData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    } else if (isInserting) {
      context.missing(_telefonoMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('es_fiado')) {
      context.handle(
        _esFiadoMeta,
        esFiado.isAcceptableOrUnknown(data['es_fiado']!, _esFiadoMeta),
      );
    }
    if (data.containsKey('saldo_pendiente')) {
      context.handle(
        _saldoPendienteMeta,
        saldoPendiente.isAcceptableOrUnknown(
          data['saldo_pendiente']!,
          _saldoPendienteMeta,
        ),
      );
    }
    if (data.containsKey('is_activo')) {
      context.handle(
        _isActivoMeta,
        isActivo.isAcceptableOrUnknown(data['is_activo']!, _isActivoMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('limite_credito')) {
      context.handle(
        _limiteCreditoMeta,
        limiteCredito.isAcceptableOrUnknown(
          data['limite_credito']!,
          _limiteCreditoMeta,
        ),
      );
    }
    if (data.containsKey('promesa_pago')) {
      context.handle(
        _promesaPagoMeta,
        promesaPago.isAcceptableOrUnknown(
          data['promesa_pago']!,
          _promesaPagoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClienteData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClienteData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      ),
      esFiado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_fiado'],
      )!,
      saldoPendiente: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saldo_pendiente'],
      )!,
      isActivo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_activo'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      limiteCredito: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}limite_credito'],
      ),
      promesaPago: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}promesa_pago'],
      ),
    );
  }

  @override
  $ClientesTable createAlias(String alias) {
    return $ClientesTable(attachedDatabase, alias);
  }
}

class ClienteData extends DataClass implements Insertable<ClienteData> {
  final String id;
  final String nombre;
  final String telefono;
  final String? email;
  final String? localId;
  final bool esFiado;
  final double saldoPendiente;
  final bool isActivo;
  final String syncStatus;
  final DateTime? lastSyncedAt;
  final DateTime? updatedAt;
  final double? limiteCredito;
  final DateTime? promesaPago;
  const ClienteData({
    required this.id,
    required this.nombre,
    required this.telefono,
    this.email,
    this.localId,
    required this.esFiado,
    required this.saldoPendiente,
    required this.isActivo,
    required this.syncStatus,
    this.lastSyncedAt,
    this.updatedAt,
    this.limiteCredito,
    this.promesaPago,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['telefono'] = Variable<String>(telefono);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<String>(localId);
    }
    map['es_fiado'] = Variable<bool>(esFiado);
    map['saldo_pendiente'] = Variable<double>(saldoPendiente);
    map['is_activo'] = Variable<bool>(isActivo);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || limiteCredito != null) {
      map['limite_credito'] = Variable<double>(limiteCredito);
    }
    if (!nullToAbsent || promesaPago != null) {
      map['promesa_pago'] = Variable<DateTime>(promesaPago);
    }
    return map;
  }

  ClientesCompanion toCompanion(bool nullToAbsent) {
    return ClientesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      telefono: Value(telefono),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
      esFiado: Value(esFiado),
      saldoPendiente: Value(saldoPendiente),
      isActivo: Value(isActivo),
      syncStatus: Value(syncStatus),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      limiteCredito: limiteCredito == null && nullToAbsent
          ? const Value.absent()
          : Value(limiteCredito),
      promesaPago: promesaPago == null && nullToAbsent
          ? const Value.absent()
          : Value(promesaPago),
    );
  }

  factory ClienteData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClienteData(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      telefono: serializer.fromJson<String>(json['telefono']),
      email: serializer.fromJson<String?>(json['email']),
      localId: serializer.fromJson<String?>(json['localId']),
      esFiado: serializer.fromJson<bool>(json['esFiado']),
      saldoPendiente: serializer.fromJson<double>(json['saldoPendiente']),
      isActivo: serializer.fromJson<bool>(json['isActivo']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      limiteCredito: serializer.fromJson<double?>(json['limiteCredito']),
      promesaPago: serializer.fromJson<DateTime?>(json['promesaPago']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'telefono': serializer.toJson<String>(telefono),
      'email': serializer.toJson<String?>(email),
      'localId': serializer.toJson<String?>(localId),
      'esFiado': serializer.toJson<bool>(esFiado),
      'saldoPendiente': serializer.toJson<double>(saldoPendiente),
      'isActivo': serializer.toJson<bool>(isActivo),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'limiteCredito': serializer.toJson<double?>(limiteCredito),
      'promesaPago': serializer.toJson<DateTime?>(promesaPago),
    };
  }

  ClienteData copyWith({
    String? id,
    String? nombre,
    String? telefono,
    Value<String?> email = const Value.absent(),
    Value<String?> localId = const Value.absent(),
    bool? esFiado,
    double? saldoPendiente,
    bool? isActivo,
    String? syncStatus,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<double?> limiteCredito = const Value.absent(),
    Value<DateTime?> promesaPago = const Value.absent(),
  }) => ClienteData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    telefono: telefono ?? this.telefono,
    email: email.present ? email.value : this.email,
    localId: localId.present ? localId.value : this.localId,
    esFiado: esFiado ?? this.esFiado,
    saldoPendiente: saldoPendiente ?? this.saldoPendiente,
    isActivo: isActivo ?? this.isActivo,
    syncStatus: syncStatus ?? this.syncStatus,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    limiteCredito: limiteCredito.present
        ? limiteCredito.value
        : this.limiteCredito,
    promesaPago: promesaPago.present ? promesaPago.value : this.promesaPago,
  );
  ClienteData copyWithCompanion(ClientesCompanion data) {
    return ClienteData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      email: data.email.present ? data.email.value : this.email,
      localId: data.localId.present ? data.localId.value : this.localId,
      esFiado: data.esFiado.present ? data.esFiado.value : this.esFiado,
      saldoPendiente: data.saldoPendiente.present
          ? data.saldoPendiente.value
          : this.saldoPendiente,
      isActivo: data.isActivo.present ? data.isActivo.value : this.isActivo,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      limiteCredito: data.limiteCredito.present
          ? data.limiteCredito.value
          : this.limiteCredito,
      promesaPago: data.promesaPago.present
          ? data.promesaPago.value
          : this.promesaPago,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClienteData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('localId: $localId, ')
          ..write('esFiado: $esFiado, ')
          ..write('saldoPendiente: $saldoPendiente, ')
          ..write('isActivo: $isActivo, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('limiteCredito: $limiteCredito, ')
          ..write('promesaPago: $promesaPago')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    telefono,
    email,
    localId,
    esFiado,
    saldoPendiente,
    isActivo,
    syncStatus,
    lastSyncedAt,
    updatedAt,
    limiteCredito,
    promesaPago,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClienteData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.telefono == this.telefono &&
          other.email == this.email &&
          other.localId == this.localId &&
          other.esFiado == this.esFiado &&
          other.saldoPendiente == this.saldoPendiente &&
          other.isActivo == this.isActivo &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.updatedAt == this.updatedAt &&
          other.limiteCredito == this.limiteCredito &&
          other.promesaPago == this.promesaPago);
}

class ClientesCompanion extends UpdateCompanion<ClienteData> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> telefono;
  final Value<String?> email;
  final Value<String?> localId;
  final Value<bool> esFiado;
  final Value<double> saldoPendiente;
  final Value<bool> isActivo;
  final Value<String> syncStatus;
  final Value<DateTime?> lastSyncedAt;
  final Value<DateTime?> updatedAt;
  final Value<double?> limiteCredito;
  final Value<DateTime?> promesaPago;
  final Value<int> rowid;
  const ClientesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.localId = const Value.absent(),
    this.esFiado = const Value.absent(),
    this.saldoPendiente = const Value.absent(),
    this.isActivo = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.limiteCredito = const Value.absent(),
    this.promesaPago = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientesCompanion.insert({
    required String id,
    required String nombre,
    required String telefono,
    this.email = const Value.absent(),
    this.localId = const Value.absent(),
    this.esFiado = const Value.absent(),
    this.saldoPendiente = const Value.absent(),
    this.isActivo = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.limiteCredito = const Value.absent(),
    this.promesaPago = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       telefono = Value(telefono);
  static Insertable<ClienteData> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? telefono,
    Expression<String>? email,
    Expression<String>? localId,
    Expression<bool>? esFiado,
    Expression<double>? saldoPendiente,
    Expression<bool>? isActivo,
    Expression<String>? syncStatus,
    Expression<DateTime>? lastSyncedAt,
    Expression<DateTime>? updatedAt,
    Expression<double>? limiteCredito,
    Expression<DateTime>? promesaPago,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (telefono != null) 'telefono': telefono,
      if (email != null) 'email': email,
      if (localId != null) 'local_id': localId,
      if (esFiado != null) 'es_fiado': esFiado,
      if (saldoPendiente != null) 'saldo_pendiente': saldoPendiente,
      if (isActivo != null) 'is_activo': isActivo,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (limiteCredito != null) 'limite_credito': limiteCredito,
      if (promesaPago != null) 'promesa_pago': promesaPago,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientesCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? telefono,
    Value<String?>? email,
    Value<String?>? localId,
    Value<bool>? esFiado,
    Value<double>? saldoPendiente,
    Value<bool>? isActivo,
    Value<String>? syncStatus,
    Value<DateTime?>? lastSyncedAt,
    Value<DateTime?>? updatedAt,
    Value<double?>? limiteCredito,
    Value<DateTime?>? promesaPago,
    Value<int>? rowid,
  }) {
    return ClientesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      localId: localId ?? this.localId,
      esFiado: esFiado ?? this.esFiado,
      saldoPendiente: saldoPendiente ?? this.saldoPendiente,
      isActivo: isActivo ?? this.isActivo,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      limiteCredito: limiteCredito ?? this.limiteCredito,
      promesaPago: promesaPago ?? this.promesaPago,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (esFiado.present) {
      map['es_fiado'] = Variable<bool>(esFiado.value);
    }
    if (saldoPendiente.present) {
      map['saldo_pendiente'] = Variable<double>(saldoPendiente.value);
    }
    if (isActivo.present) {
      map['is_activo'] = Variable<bool>(isActivo.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (limiteCredito.present) {
      map['limite_credito'] = Variable<double>(limiteCredito.value);
    }
    if (promesaPago.present) {
      map['promesa_pago'] = Variable<DateTime>(promesaPago.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('localId: $localId, ')
          ..write('esFiado: $esFiado, ')
          ..write('saldoPendiente: $saldoPendiente, ')
          ..write('isActivo: $isActivo, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('limiteCredito: $limiteCredito, ')
          ..write('promesaPago: $promesaPago, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProveedoresTable extends Proveedores
    with TableInfo<$ProveedoresTable, ProveedorData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProveedoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> diasVisita =
      GeneratedColumn<String>(
        'dias_visita',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($ProveedoresTable.$converterdiasVisita);
  static const VerificationMeta _periodoVisitaMeta = const VerificationMeta(
    'periodoVisita',
  );
  @override
  late final GeneratedColumn<int> periodoVisita = GeneratedColumn<int>(
    'periodo_visita',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ultimaVisitaMeta = const VerificationMeta(
    'ultimaVisita',
  );
  @override
  late final GeneratedColumn<DateTime> ultimaVisita = GeneratedColumn<DateTime>(
    'ultima_visita',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proximaVisitaMeta = const VerificationMeta(
    'proximaVisita',
  );
  @override
  late final GeneratedColumn<DateTime> proximaVisita =
      GeneratedColumn<DateTime>(
        'proxima_visita',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locales (id)',
    ),
  );
  static const VerificationMeta _isActivoMeta = const VerificationMeta(
    'isActivo',
  );
  @override
  late final GeneratedColumn<bool> isActivo = GeneratedColumn<bool>(
    'is_activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    telefono,
    diasVisita,
    periodoVisita,
    ultimaVisita,
    proximaVisita,
    localId,
    isActivo,
    syncStatus,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'proveedores';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProveedorData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    } else if (isInserting) {
      context.missing(_telefonoMeta);
    }
    if (data.containsKey('periodo_visita')) {
      context.handle(
        _periodoVisitaMeta,
        periodoVisita.isAcceptableOrUnknown(
          data['periodo_visita']!,
          _periodoVisitaMeta,
        ),
      );
    }
    if (data.containsKey('ultima_visita')) {
      context.handle(
        _ultimaVisitaMeta,
        ultimaVisita.isAcceptableOrUnknown(
          data['ultima_visita']!,
          _ultimaVisitaMeta,
        ),
      );
    }
    if (data.containsKey('proxima_visita')) {
      context.handle(
        _proximaVisitaMeta,
        proximaVisita.isAcceptableOrUnknown(
          data['proxima_visita']!,
          _proximaVisitaMeta,
        ),
      );
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('is_activo')) {
      context.handle(
        _isActivoMeta,
        isActivo.isAcceptableOrUnknown(data['is_activo']!, _isActivoMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProveedorData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProveedorData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      )!,
      diasVisita: $ProveedoresTable.$converterdiasVisita.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}dias_visita'],
        )!,
      ),
      periodoVisita: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}periodo_visita'],
      ),
      ultimaVisita: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ultima_visita'],
      ),
      proximaVisita: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}proxima_visita'],
      ),
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      ),
      isActivo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_activo'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $ProveedoresTable createAlias(String alias) {
    return $ProveedoresTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterdiasVisita =
      const StringListConverter();
}

class ProveedorData extends DataClass implements Insertable<ProveedorData> {
  final String id;
  final String nombre;
  final String telefono;
  final List<String> diasVisita;
  final int? periodoVisita;
  final DateTime? ultimaVisita;
  final DateTime? proximaVisita;
  final String? localId;
  final bool isActivo;
  final String syncStatus;
  final DateTime? lastSyncedAt;
  const ProveedorData({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.diasVisita,
    this.periodoVisita,
    this.ultimaVisita,
    this.proximaVisita,
    this.localId,
    required this.isActivo,
    required this.syncStatus,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['telefono'] = Variable<String>(telefono);
    {
      map['dias_visita'] = Variable<String>(
        $ProveedoresTable.$converterdiasVisita.toSql(diasVisita),
      );
    }
    if (!nullToAbsent || periodoVisita != null) {
      map['periodo_visita'] = Variable<int>(periodoVisita);
    }
    if (!nullToAbsent || ultimaVisita != null) {
      map['ultima_visita'] = Variable<DateTime>(ultimaVisita);
    }
    if (!nullToAbsent || proximaVisita != null) {
      map['proxima_visita'] = Variable<DateTime>(proximaVisita);
    }
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<String>(localId);
    }
    map['is_activo'] = Variable<bool>(isActivo);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  ProveedoresCompanion toCompanion(bool nullToAbsent) {
    return ProveedoresCompanion(
      id: Value(id),
      nombre: Value(nombre),
      telefono: Value(telefono),
      diasVisita: Value(diasVisita),
      periodoVisita: periodoVisita == null && nullToAbsent
          ? const Value.absent()
          : Value(periodoVisita),
      ultimaVisita: ultimaVisita == null && nullToAbsent
          ? const Value.absent()
          : Value(ultimaVisita),
      proximaVisita: proximaVisita == null && nullToAbsent
          ? const Value.absent()
          : Value(proximaVisita),
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
      isActivo: Value(isActivo),
      syncStatus: Value(syncStatus),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory ProveedorData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProveedorData(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      telefono: serializer.fromJson<String>(json['telefono']),
      diasVisita: serializer.fromJson<List<String>>(json['diasVisita']),
      periodoVisita: serializer.fromJson<int?>(json['periodoVisita']),
      ultimaVisita: serializer.fromJson<DateTime?>(json['ultimaVisita']),
      proximaVisita: serializer.fromJson<DateTime?>(json['proximaVisita']),
      localId: serializer.fromJson<String?>(json['localId']),
      isActivo: serializer.fromJson<bool>(json['isActivo']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'telefono': serializer.toJson<String>(telefono),
      'diasVisita': serializer.toJson<List<String>>(diasVisita),
      'periodoVisita': serializer.toJson<int?>(periodoVisita),
      'ultimaVisita': serializer.toJson<DateTime?>(ultimaVisita),
      'proximaVisita': serializer.toJson<DateTime?>(proximaVisita),
      'localId': serializer.toJson<String?>(localId),
      'isActivo': serializer.toJson<bool>(isActivo),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  ProveedorData copyWith({
    String? id,
    String? nombre,
    String? telefono,
    List<String>? diasVisita,
    Value<int?> periodoVisita = const Value.absent(),
    Value<DateTime?> ultimaVisita = const Value.absent(),
    Value<DateTime?> proximaVisita = const Value.absent(),
    Value<String?> localId = const Value.absent(),
    bool? isActivo,
    String? syncStatus,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => ProveedorData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    telefono: telefono ?? this.telefono,
    diasVisita: diasVisita ?? this.diasVisita,
    periodoVisita: periodoVisita.present
        ? periodoVisita.value
        : this.periodoVisita,
    ultimaVisita: ultimaVisita.present ? ultimaVisita.value : this.ultimaVisita,
    proximaVisita: proximaVisita.present
        ? proximaVisita.value
        : this.proximaVisita,
    localId: localId.present ? localId.value : this.localId,
    isActivo: isActivo ?? this.isActivo,
    syncStatus: syncStatus ?? this.syncStatus,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  ProveedorData copyWithCompanion(ProveedoresCompanion data) {
    return ProveedorData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      diasVisita: data.diasVisita.present
          ? data.diasVisita.value
          : this.diasVisita,
      periodoVisita: data.periodoVisita.present
          ? data.periodoVisita.value
          : this.periodoVisita,
      ultimaVisita: data.ultimaVisita.present
          ? data.ultimaVisita.value
          : this.ultimaVisita,
      proximaVisita: data.proximaVisita.present
          ? data.proximaVisita.value
          : this.proximaVisita,
      localId: data.localId.present ? data.localId.value : this.localId,
      isActivo: data.isActivo.present ? data.isActivo.value : this.isActivo,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProveedorData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('diasVisita: $diasVisita, ')
          ..write('periodoVisita: $periodoVisita, ')
          ..write('ultimaVisita: $ultimaVisita, ')
          ..write('proximaVisita: $proximaVisita, ')
          ..write('localId: $localId, ')
          ..write('isActivo: $isActivo, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    telefono,
    diasVisita,
    periodoVisita,
    ultimaVisita,
    proximaVisita,
    localId,
    isActivo,
    syncStatus,
    lastSyncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProveedorData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.telefono == this.telefono &&
          other.diasVisita == this.diasVisita &&
          other.periodoVisita == this.periodoVisita &&
          other.ultimaVisita == this.ultimaVisita &&
          other.proximaVisita == this.proximaVisita &&
          other.localId == this.localId &&
          other.isActivo == this.isActivo &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class ProveedoresCompanion extends UpdateCompanion<ProveedorData> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> telefono;
  final Value<List<String>> diasVisita;
  final Value<int?> periodoVisita;
  final Value<DateTime?> ultimaVisita;
  final Value<DateTime?> proximaVisita;
  final Value<String?> localId;
  final Value<bool> isActivo;
  final Value<String> syncStatus;
  final Value<DateTime?> lastSyncedAt;
  final Value<int> rowid;
  const ProveedoresCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.telefono = const Value.absent(),
    this.diasVisita = const Value.absent(),
    this.periodoVisita = const Value.absent(),
    this.ultimaVisita = const Value.absent(),
    this.proximaVisita = const Value.absent(),
    this.localId = const Value.absent(),
    this.isActivo = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProveedoresCompanion.insert({
    required String id,
    required String nombre,
    required String telefono,
    required List<String> diasVisita,
    this.periodoVisita = const Value.absent(),
    this.ultimaVisita = const Value.absent(),
    this.proximaVisita = const Value.absent(),
    this.localId = const Value.absent(),
    this.isActivo = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       telefono = Value(telefono),
       diasVisita = Value(diasVisita);
  static Insertable<ProveedorData> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? telefono,
    Expression<String>? diasVisita,
    Expression<int>? periodoVisita,
    Expression<DateTime>? ultimaVisita,
    Expression<DateTime>? proximaVisita,
    Expression<String>? localId,
    Expression<bool>? isActivo,
    Expression<String>? syncStatus,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (telefono != null) 'telefono': telefono,
      if (diasVisita != null) 'dias_visita': diasVisita,
      if (periodoVisita != null) 'periodo_visita': periodoVisita,
      if (ultimaVisita != null) 'ultima_visita': ultimaVisita,
      if (proximaVisita != null) 'proxima_visita': proximaVisita,
      if (localId != null) 'local_id': localId,
      if (isActivo != null) 'is_activo': isActivo,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProveedoresCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? telefono,
    Value<List<String>>? diasVisita,
    Value<int?>? periodoVisita,
    Value<DateTime?>? ultimaVisita,
    Value<DateTime?>? proximaVisita,
    Value<String?>? localId,
    Value<bool>? isActivo,
    Value<String>? syncStatus,
    Value<DateTime?>? lastSyncedAt,
    Value<int>? rowid,
  }) {
    return ProveedoresCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      diasVisita: diasVisita ?? this.diasVisita,
      periodoVisita: periodoVisita ?? this.periodoVisita,
      ultimaVisita: ultimaVisita ?? this.ultimaVisita,
      proximaVisita: proximaVisita ?? this.proximaVisita,
      localId: localId ?? this.localId,
      isActivo: isActivo ?? this.isActivo,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (diasVisita.present) {
      map['dias_visita'] = Variable<String>(
        $ProveedoresTable.$converterdiasVisita.toSql(diasVisita.value),
      );
    }
    if (periodoVisita.present) {
      map['periodo_visita'] = Variable<int>(periodoVisita.value);
    }
    if (ultimaVisita.present) {
      map['ultima_visita'] = Variable<DateTime>(ultimaVisita.value);
    }
    if (proximaVisita.present) {
      map['proxima_visita'] = Variable<DateTime>(proximaVisita.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (isActivo.present) {
      map['is_activo'] = Variable<bool>(isActivo.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProveedoresCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('diasVisita: $diasVisita, ')
          ..write('periodoVisita: $periodoVisita, ')
          ..write('ultimaVisita: $ultimaVisita, ')
          ..write('proximaVisita: $proximaVisita, ')
          ..write('localId: $localId, ')
          ..write('isActivo: $isActivo, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductosTable extends Productos
    with TableInfo<$ProductosTable, ProductoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioMeta = const VerificationMeta('precio');
  @override
  late final GeneratedColumn<double> precio = GeneratedColumn<double>(
    'precio',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioCompraMeta = const VerificationMeta(
    'precioCompra',
  );
  @override
  late final GeneratedColumn<double> precioCompra = GeneratedColumn<double>(
    'precio_compra',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unidadesPorPaqueteMeta =
      const VerificationMeta('unidadesPorPaquete');
  @override
  late final GeneratedColumn<int> unidadesPorPaquete = GeneratedColumn<int>(
    'unidades_por_paquete',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _esPaqueteMeta = const VerificationMeta(
    'esPaquete',
  );
  @override
  late final GeneratedColumn<bool> esPaquete = GeneratedColumn<bool>(
    'es_paquete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_paquete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proveedorIdMeta = const VerificationMeta(
    'proveedorId',
  );
  @override
  late final GeneratedColumn<String> proveedorId = GeneratedColumn<String>(
    'proveedor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES proveedores (id)',
    ),
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locales (id)',
    ),
  );
  static const VerificationMeta _stockMinimoMeta = const VerificationMeta(
    'stockMinimo',
  );
  @override
  late final GeneratedColumn<int> stockMinimo = GeneratedColumn<int>(
    'stock_minimo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _codigoBarrasMeta = const VerificationMeta(
    'codigoBarras',
  );
  @override
  late final GeneratedColumn<String> codigoBarras = GeneratedColumn<String>(
    'codigo_barras',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codigoPersonalizadoMeta =
      const VerificationMeta('codigoPersonalizado');
  @override
  late final GeneratedColumn<String> codigoPersonalizado =
      GeneratedColumn<String>(
        'codigo_personalizado',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _proveedorNombreMeta = const VerificationMeta(
    'proveedorNombre',
  );
  @override
  late final GeneratedColumn<String> proveedorNombre = GeneratedColumn<String>(
    'proveedor_nombre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActivoMeta = const VerificationMeta(
    'isActivo',
  );
  @override
  late final GeneratedColumn<bool> isActivo = GeneratedColumn<bool>(
    'is_activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
  static const VerificationMeta _unidadMeta = const VerificationMeta('unidad');
  @override
  late final GeneratedColumn<String> unidad = GeneratedColumn<String>(
    'unidad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unidad'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    cantidad,
    precio,
    precioCompra,
    unidadesPorPaquete,
    esPaquete,
    categoria,
    proveedorId,
    localId,
    stockMinimo,
    codigoBarras,
    codigoPersonalizado,
    proveedorNombre,
    isActivo,
    syncStatus,
    lastSyncedAt,
    updatedAt,
    unidad,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'productos';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('precio')) {
      context.handle(
        _precioMeta,
        precio.isAcceptableOrUnknown(data['precio']!, _precioMeta),
      );
    } else if (isInserting) {
      context.missing(_precioMeta);
    }
    if (data.containsKey('precio_compra')) {
      context.handle(
        _precioCompraMeta,
        precioCompra.isAcceptableOrUnknown(
          data['precio_compra']!,
          _precioCompraMeta,
        ),
      );
    }
    if (data.containsKey('unidades_por_paquete')) {
      context.handle(
        _unidadesPorPaqueteMeta,
        unidadesPorPaquete.isAcceptableOrUnknown(
          data['unidades_por_paquete']!,
          _unidadesPorPaqueteMeta,
        ),
      );
    }
    if (data.containsKey('es_paquete')) {
      context.handle(
        _esPaqueteMeta,
        esPaquete.isAcceptableOrUnknown(data['es_paquete']!, _esPaqueteMeta),
      );
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    } else if (isInserting) {
      context.missing(_categoriaMeta);
    }
    if (data.containsKey('proveedor_id')) {
      context.handle(
        _proveedorIdMeta,
        proveedorId.isAcceptableOrUnknown(
          data['proveedor_id']!,
          _proveedorIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proveedorIdMeta);
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('stock_minimo')) {
      context.handle(
        _stockMinimoMeta,
        stockMinimo.isAcceptableOrUnknown(
          data['stock_minimo']!,
          _stockMinimoMeta,
        ),
      );
    }
    if (data.containsKey('codigo_barras')) {
      context.handle(
        _codigoBarrasMeta,
        codigoBarras.isAcceptableOrUnknown(
          data['codigo_barras']!,
          _codigoBarrasMeta,
        ),
      );
    }
    if (data.containsKey('codigo_personalizado')) {
      context.handle(
        _codigoPersonalizadoMeta,
        codigoPersonalizado.isAcceptableOrUnknown(
          data['codigo_personalizado']!,
          _codigoPersonalizadoMeta,
        ),
      );
    }
    if (data.containsKey('proveedor_nombre')) {
      context.handle(
        _proveedorNombreMeta,
        proveedorNombre.isAcceptableOrUnknown(
          data['proveedor_nombre']!,
          _proveedorNombreMeta,
        ),
      );
    }
    if (data.containsKey('is_activo')) {
      context.handle(
        _isActivoMeta,
        isActivo.isAcceptableOrUnknown(data['is_activo']!, _isActivoMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('unidad')) {
      context.handle(
        _unidadMeta,
        unidad.isAcceptableOrUnknown(data['unidad']!, _unidadMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      precio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio'],
      )!,
      precioCompra: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_compra'],
      ),
      unidadesPorPaquete: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unidades_por_paquete'],
      )!,
      esPaquete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_paquete'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      )!,
      proveedorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proveedor_id'],
      )!,
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      ),
      stockMinimo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock_minimo'],
      )!,
      codigoBarras: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_barras'],
      ),
      codigoPersonalizado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_personalizado'],
      ),
      proveedorNombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proveedor_nombre'],
      ),
      isActivo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_activo'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      unidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unidad'],
      )!,
    );
  }

  @override
  $ProductosTable createAlias(String alias) {
    return $ProductosTable(attachedDatabase, alias);
  }
}

class ProductoData extends DataClass implements Insertable<ProductoData> {
  final String id;
  final String nombre;
  final int cantidad;
  final double precio;
  final double? precioCompra;
  final int unidadesPorPaquete;
  final bool esPaquete;
  final String categoria;
  final String proveedorId;
  final String? localId;
  final int stockMinimo;
  final String? codigoBarras;
  final String? codigoPersonalizado;
  final String? proveedorNombre;
  final bool isActivo;
  final String syncStatus;
  final DateTime? lastSyncedAt;
  final DateTime? updatedAt;
  final String unidad;
  const ProductoData({
    required this.id,
    required this.nombre,
    required this.cantidad,
    required this.precio,
    this.precioCompra,
    required this.unidadesPorPaquete,
    required this.esPaquete,
    required this.categoria,
    required this.proveedorId,
    this.localId,
    required this.stockMinimo,
    this.codigoBarras,
    this.codigoPersonalizado,
    this.proveedorNombre,
    required this.isActivo,
    required this.syncStatus,
    this.lastSyncedAt,
    this.updatedAt,
    required this.unidad,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['cantidad'] = Variable<int>(cantidad);
    map['precio'] = Variable<double>(precio);
    if (!nullToAbsent || precioCompra != null) {
      map['precio_compra'] = Variable<double>(precioCompra);
    }
    map['unidades_por_paquete'] = Variable<int>(unidadesPorPaquete);
    map['es_paquete'] = Variable<bool>(esPaquete);
    map['categoria'] = Variable<String>(categoria);
    map['proveedor_id'] = Variable<String>(proveedorId);
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<String>(localId);
    }
    map['stock_minimo'] = Variable<int>(stockMinimo);
    if (!nullToAbsent || codigoBarras != null) {
      map['codigo_barras'] = Variable<String>(codigoBarras);
    }
    if (!nullToAbsent || codigoPersonalizado != null) {
      map['codigo_personalizado'] = Variable<String>(codigoPersonalizado);
    }
    if (!nullToAbsent || proveedorNombre != null) {
      map['proveedor_nombre'] = Variable<String>(proveedorNombre);
    }
    map['is_activo'] = Variable<bool>(isActivo);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['unidad'] = Variable<String>(unidad);
    return map;
  }

  ProductosCompanion toCompanion(bool nullToAbsent) {
    return ProductosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      cantidad: Value(cantidad),
      precio: Value(precio),
      precioCompra: precioCompra == null && nullToAbsent
          ? const Value.absent()
          : Value(precioCompra),
      unidadesPorPaquete: Value(unidadesPorPaquete),
      esPaquete: Value(esPaquete),
      categoria: Value(categoria),
      proveedorId: Value(proveedorId),
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
      stockMinimo: Value(stockMinimo),
      codigoBarras: codigoBarras == null && nullToAbsent
          ? const Value.absent()
          : Value(codigoBarras),
      codigoPersonalizado: codigoPersonalizado == null && nullToAbsent
          ? const Value.absent()
          : Value(codigoPersonalizado),
      proveedorNombre: proveedorNombre == null && nullToAbsent
          ? const Value.absent()
          : Value(proveedorNombre),
      isActivo: Value(isActivo),
      syncStatus: Value(syncStatus),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      unidad: Value(unidad),
    );
  }

  factory ProductoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductoData(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      precio: serializer.fromJson<double>(json['precio']),
      precioCompra: serializer.fromJson<double?>(json['precioCompra']),
      unidadesPorPaquete: serializer.fromJson<int>(json['unidadesPorPaquete']),
      esPaquete: serializer.fromJson<bool>(json['esPaquete']),
      categoria: serializer.fromJson<String>(json['categoria']),
      proveedorId: serializer.fromJson<String>(json['proveedorId']),
      localId: serializer.fromJson<String?>(json['localId']),
      stockMinimo: serializer.fromJson<int>(json['stockMinimo']),
      codigoBarras: serializer.fromJson<String?>(json['codigoBarras']),
      codigoPersonalizado: serializer.fromJson<String?>(
        json['codigoPersonalizado'],
      ),
      proveedorNombre: serializer.fromJson<String?>(json['proveedorNombre']),
      isActivo: serializer.fromJson<bool>(json['isActivo']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      unidad: serializer.fromJson<String>(json['unidad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'cantidad': serializer.toJson<int>(cantidad),
      'precio': serializer.toJson<double>(precio),
      'precioCompra': serializer.toJson<double?>(precioCompra),
      'unidadesPorPaquete': serializer.toJson<int>(unidadesPorPaquete),
      'esPaquete': serializer.toJson<bool>(esPaquete),
      'categoria': serializer.toJson<String>(categoria),
      'proveedorId': serializer.toJson<String>(proveedorId),
      'localId': serializer.toJson<String?>(localId),
      'stockMinimo': serializer.toJson<int>(stockMinimo),
      'codigoBarras': serializer.toJson<String?>(codigoBarras),
      'codigoPersonalizado': serializer.toJson<String?>(codigoPersonalizado),
      'proveedorNombre': serializer.toJson<String?>(proveedorNombre),
      'isActivo': serializer.toJson<bool>(isActivo),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'unidad': serializer.toJson<String>(unidad),
    };
  }

  ProductoData copyWith({
    String? id,
    String? nombre,
    int? cantidad,
    double? precio,
    Value<double?> precioCompra = const Value.absent(),
    int? unidadesPorPaquete,
    bool? esPaquete,
    String? categoria,
    String? proveedorId,
    Value<String?> localId = const Value.absent(),
    int? stockMinimo,
    Value<String?> codigoBarras = const Value.absent(),
    Value<String?> codigoPersonalizado = const Value.absent(),
    Value<String?> proveedorNombre = const Value.absent(),
    bool? isActivo,
    String? syncStatus,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    String? unidad,
  }) => ProductoData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    cantidad: cantidad ?? this.cantidad,
    precio: precio ?? this.precio,
    precioCompra: precioCompra.present ? precioCompra.value : this.precioCompra,
    unidadesPorPaquete: unidadesPorPaquete ?? this.unidadesPorPaquete,
    esPaquete: esPaquete ?? this.esPaquete,
    categoria: categoria ?? this.categoria,
    proveedorId: proveedorId ?? this.proveedorId,
    localId: localId.present ? localId.value : this.localId,
    stockMinimo: stockMinimo ?? this.stockMinimo,
    codigoBarras: codigoBarras.present ? codigoBarras.value : this.codigoBarras,
    codigoPersonalizado: codigoPersonalizado.present
        ? codigoPersonalizado.value
        : this.codigoPersonalizado,
    proveedorNombre: proveedorNombre.present
        ? proveedorNombre.value
        : this.proveedorNombre,
    isActivo: isActivo ?? this.isActivo,
    syncStatus: syncStatus ?? this.syncStatus,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    unidad: unidad ?? this.unidad,
  );
  ProductoData copyWithCompanion(ProductosCompanion data) {
    return ProductoData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precio: data.precio.present ? data.precio.value : this.precio,
      precioCompra: data.precioCompra.present
          ? data.precioCompra.value
          : this.precioCompra,
      unidadesPorPaquete: data.unidadesPorPaquete.present
          ? data.unidadesPorPaquete.value
          : this.unidadesPorPaquete,
      esPaquete: data.esPaquete.present ? data.esPaquete.value : this.esPaquete,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      proveedorId: data.proveedorId.present
          ? data.proveedorId.value
          : this.proveedorId,
      localId: data.localId.present ? data.localId.value : this.localId,
      stockMinimo: data.stockMinimo.present
          ? data.stockMinimo.value
          : this.stockMinimo,
      codigoBarras: data.codigoBarras.present
          ? data.codigoBarras.value
          : this.codigoBarras,
      codigoPersonalizado: data.codigoPersonalizado.present
          ? data.codigoPersonalizado.value
          : this.codigoPersonalizado,
      proveedorNombre: data.proveedorNombre.present
          ? data.proveedorNombre.value
          : this.proveedorNombre,
      isActivo: data.isActivo.present ? data.isActivo.value : this.isActivo,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      unidad: data.unidad.present ? data.unidad.value : this.unidad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductoData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('cantidad: $cantidad, ')
          ..write('precio: $precio, ')
          ..write('precioCompra: $precioCompra, ')
          ..write('unidadesPorPaquete: $unidadesPorPaquete, ')
          ..write('esPaquete: $esPaquete, ')
          ..write('categoria: $categoria, ')
          ..write('proveedorId: $proveedorId, ')
          ..write('localId: $localId, ')
          ..write('stockMinimo: $stockMinimo, ')
          ..write('codigoBarras: $codigoBarras, ')
          ..write('codigoPersonalizado: $codigoPersonalizado, ')
          ..write('proveedorNombre: $proveedorNombre, ')
          ..write('isActivo: $isActivo, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('unidad: $unidad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    cantidad,
    precio,
    precioCompra,
    unidadesPorPaquete,
    esPaquete,
    categoria,
    proveedorId,
    localId,
    stockMinimo,
    codigoBarras,
    codigoPersonalizado,
    proveedorNombre,
    isActivo,
    syncStatus,
    lastSyncedAt,
    updatedAt,
    unidad,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductoData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.cantidad == this.cantidad &&
          other.precio == this.precio &&
          other.precioCompra == this.precioCompra &&
          other.unidadesPorPaquete == this.unidadesPorPaquete &&
          other.esPaquete == this.esPaquete &&
          other.categoria == this.categoria &&
          other.proveedorId == this.proveedorId &&
          other.localId == this.localId &&
          other.stockMinimo == this.stockMinimo &&
          other.codigoBarras == this.codigoBarras &&
          other.codigoPersonalizado == this.codigoPersonalizado &&
          other.proveedorNombre == this.proveedorNombre &&
          other.isActivo == this.isActivo &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.updatedAt == this.updatedAt &&
          other.unidad == this.unidad);
}

class ProductosCompanion extends UpdateCompanion<ProductoData> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<int> cantidad;
  final Value<double> precio;
  final Value<double?> precioCompra;
  final Value<int> unidadesPorPaquete;
  final Value<bool> esPaquete;
  final Value<String> categoria;
  final Value<String> proveedorId;
  final Value<String?> localId;
  final Value<int> stockMinimo;
  final Value<String?> codigoBarras;
  final Value<String?> codigoPersonalizado;
  final Value<String?> proveedorNombre;
  final Value<bool> isActivo;
  final Value<String> syncStatus;
  final Value<DateTime?> lastSyncedAt;
  final Value<DateTime?> updatedAt;
  final Value<String> unidad;
  final Value<int> rowid;
  const ProductosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precio = const Value.absent(),
    this.precioCompra = const Value.absent(),
    this.unidadesPorPaquete = const Value.absent(),
    this.esPaquete = const Value.absent(),
    this.categoria = const Value.absent(),
    this.proveedorId = const Value.absent(),
    this.localId = const Value.absent(),
    this.stockMinimo = const Value.absent(),
    this.codigoBarras = const Value.absent(),
    this.codigoPersonalizado = const Value.absent(),
    this.proveedorNombre = const Value.absent(),
    this.isActivo = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.unidad = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductosCompanion.insert({
    required String id,
    required String nombre,
    required int cantidad,
    required double precio,
    this.precioCompra = const Value.absent(),
    this.unidadesPorPaquete = const Value.absent(),
    this.esPaquete = const Value.absent(),
    required String categoria,
    required String proveedorId,
    this.localId = const Value.absent(),
    this.stockMinimo = const Value.absent(),
    this.codigoBarras = const Value.absent(),
    this.codigoPersonalizado = const Value.absent(),
    this.proveedorNombre = const Value.absent(),
    this.isActivo = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.unidad = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       cantidad = Value(cantidad),
       precio = Value(precio),
       categoria = Value(categoria),
       proveedorId = Value(proveedorId);
  static Insertable<ProductoData> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<int>? cantidad,
    Expression<double>? precio,
    Expression<double>? precioCompra,
    Expression<int>? unidadesPorPaquete,
    Expression<bool>? esPaquete,
    Expression<String>? categoria,
    Expression<String>? proveedorId,
    Expression<String>? localId,
    Expression<int>? stockMinimo,
    Expression<String>? codigoBarras,
    Expression<String>? codigoPersonalizado,
    Expression<String>? proveedorNombre,
    Expression<bool>? isActivo,
    Expression<String>? syncStatus,
    Expression<DateTime>? lastSyncedAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? unidad,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (cantidad != null) 'cantidad': cantidad,
      if (precio != null) 'precio': precio,
      if (precioCompra != null) 'precio_compra': precioCompra,
      if (unidadesPorPaquete != null)
        'unidades_por_paquete': unidadesPorPaquete,
      if (esPaquete != null) 'es_paquete': esPaquete,
      if (categoria != null) 'categoria': categoria,
      if (proveedorId != null) 'proveedor_id': proveedorId,
      if (localId != null) 'local_id': localId,
      if (stockMinimo != null) 'stock_minimo': stockMinimo,
      if (codigoBarras != null) 'codigo_barras': codigoBarras,
      if (codigoPersonalizado != null)
        'codigo_personalizado': codigoPersonalizado,
      if (proveedorNombre != null) 'proveedor_nombre': proveedorNombre,
      if (isActivo != null) 'is_activo': isActivo,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (unidad != null) 'unidad': unidad,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductosCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<int>? cantidad,
    Value<double>? precio,
    Value<double?>? precioCompra,
    Value<int>? unidadesPorPaquete,
    Value<bool>? esPaquete,
    Value<String>? categoria,
    Value<String>? proveedorId,
    Value<String?>? localId,
    Value<int>? stockMinimo,
    Value<String?>? codigoBarras,
    Value<String?>? codigoPersonalizado,
    Value<String?>? proveedorNombre,
    Value<bool>? isActivo,
    Value<String>? syncStatus,
    Value<DateTime?>? lastSyncedAt,
    Value<DateTime?>? updatedAt,
    Value<String>? unidad,
    Value<int>? rowid,
  }) {
    return ProductosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      cantidad: cantidad ?? this.cantidad,
      precio: precio ?? this.precio,
      precioCompra: precioCompra ?? this.precioCompra,
      unidadesPorPaquete: unidadesPorPaquete ?? this.unidadesPorPaquete,
      esPaquete: esPaquete ?? this.esPaquete,
      categoria: categoria ?? this.categoria,
      proveedorId: proveedorId ?? this.proveedorId,
      localId: localId ?? this.localId,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      codigoPersonalizado: codigoPersonalizado ?? this.codigoPersonalizado,
      proveedorNombre: proveedorNombre ?? this.proveedorNombre,
      isActivo: isActivo ?? this.isActivo,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      unidad: unidad ?? this.unidad,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (precio.present) {
      map['precio'] = Variable<double>(precio.value);
    }
    if (precioCompra.present) {
      map['precio_compra'] = Variable<double>(precioCompra.value);
    }
    if (unidadesPorPaquete.present) {
      map['unidades_por_paquete'] = Variable<int>(unidadesPorPaquete.value);
    }
    if (esPaquete.present) {
      map['es_paquete'] = Variable<bool>(esPaquete.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (proveedorId.present) {
      map['proveedor_id'] = Variable<String>(proveedorId.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (stockMinimo.present) {
      map['stock_minimo'] = Variable<int>(stockMinimo.value);
    }
    if (codigoBarras.present) {
      map['codigo_barras'] = Variable<String>(codigoBarras.value);
    }
    if (codigoPersonalizado.present) {
      map['codigo_personalizado'] = Variable<String>(codigoPersonalizado.value);
    }
    if (proveedorNombre.present) {
      map['proveedor_nombre'] = Variable<String>(proveedorNombre.value);
    }
    if (isActivo.present) {
      map['is_activo'] = Variable<bool>(isActivo.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (unidad.present) {
      map['unidad'] = Variable<String>(unidad.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('cantidad: $cantidad, ')
          ..write('precio: $precio, ')
          ..write('precioCompra: $precioCompra, ')
          ..write('unidadesPorPaquete: $unidadesPorPaquete, ')
          ..write('esPaquete: $esPaquete, ')
          ..write('categoria: $categoria, ')
          ..write('proveedorId: $proveedorId, ')
          ..write('localId: $localId, ')
          ..write('stockMinimo: $stockMinimo, ')
          ..write('codigoBarras: $codigoBarras, ')
          ..write('codigoPersonalizado: $codigoPersonalizado, ')
          ..write('proveedorNombre: $proveedorNombre, ')
          ..write('isActivo: $isActivo, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('unidad: $unidad, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MovimientosTable extends Movimientos
    with TableInfo<$MovimientosTable, MovimientoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovimientosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoMeta = const VerificationMeta('monto');
  @override
  late final GeneratedColumn<double> monto = GeneratedColumn<double>(
    'monto',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MovimientoType, int> tipo =
      GeneratedColumn<int>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<MovimientoType>($MovimientosTable.$convertertipo);
  static const VerificationMeta _conceptoMeta = const VerificationMeta(
    'concepto',
  );
  @override
  late final GeneratedColumn<String> concepto = GeneratedColumn<String>(
    'concepto',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  @override
  late final GeneratedColumn<String> productoId = GeneratedColumn<String>(
    'producto_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES productos (id)',
    ),
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<String> clienteId = GeneratedColumn<String>(
    'cliente_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id)',
    ),
  );
  static const VerificationMeta _proveedorIdMeta = const VerificationMeta(
    'proveedorId',
  );
  @override
  late final GeneratedColumn<String> proveedorId = GeneratedColumn<String>(
    'proveedor_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES proveedores (id)',
    ),
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locales (id)',
    ),
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _esFiadoMeta = const VerificationMeta(
    'esFiado',
  );
  @override
  late final GeneratedColumn<bool> esFiado = GeneratedColumn<bool>(
    'es_fiado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_fiado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _productosJsonMeta = const VerificationMeta(
    'productosJson',
  );
  @override
  late final GeneratedColumn<String> productosJson = GeneratedColumn<String>(
    'productos_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
    monto,
    fecha,
    tipo,
    concepto,
    categoria,
    productoId,
    clienteId,
    proveedorId,
    localId,
    cantidad,
    esFiado,
    productosJson,
    syncStatus,
    lastSyncedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movimientos';
  @override
  VerificationContext validateIntegrity(
    Insertable<MovimientoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('monto')) {
      context.handle(
        _montoMeta,
        monto.isAcceptableOrUnknown(data['monto']!, _montoMeta),
      );
    } else if (isInserting) {
      context.missing(_montoMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('concepto')) {
      context.handle(
        _conceptoMeta,
        concepto.isAcceptableOrUnknown(data['concepto']!, _conceptoMeta),
      );
    } else if (isInserting) {
      context.missing(_conceptoMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    }
    if (data.containsKey('proveedor_id')) {
      context.handle(
        _proveedorIdMeta,
        proveedorId.isAcceptableOrUnknown(
          data['proveedor_id']!,
          _proveedorIdMeta,
        ),
      );
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    }
    if (data.containsKey('es_fiado')) {
      context.handle(
        _esFiadoMeta,
        esFiado.isAcceptableOrUnknown(data['es_fiado']!, _esFiadoMeta),
      );
    }
    if (data.containsKey('productos_json')) {
      context.handle(
        _productosJsonMeta,
        productosJson.isAcceptableOrUnknown(
          data['productos_json']!,
          _productosJsonMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
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
  MovimientoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovimientoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      monto: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      tipo: $MovimientosTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      concepto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concepto'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      ),
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}producto_id'],
      ),
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_id'],
      ),
      proveedorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proveedor_id'],
      ),
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      ),
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      ),
      esFiado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_fiado'],
      )!,
      productosJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}productos_json'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $MovimientosTable createAlias(String alias) {
    return $MovimientosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MovimientoType, int, int> $convertertipo =
      const EnumIndexConverter<MovimientoType>(MovimientoType.values);
}

class MovimientoData extends DataClass implements Insertable<MovimientoData> {
  final String id;
  final double monto;
  final DateTime fecha;
  final MovimientoType tipo;
  final String concepto;
  final String? categoria;
  final String? productoId;
  final String? clienteId;
  final String? proveedorId;
  final String? localId;
  final int? cantidad;
  final bool esFiado;
  final String? productosJson;
  final String syncStatus;
  final DateTime? lastSyncedAt;
  final DateTime? updatedAt;
  const MovimientoData({
    required this.id,
    required this.monto,
    required this.fecha,
    required this.tipo,
    required this.concepto,
    this.categoria,
    this.productoId,
    this.clienteId,
    this.proveedorId,
    this.localId,
    this.cantidad,
    required this.esFiado,
    this.productosJson,
    required this.syncStatus,
    this.lastSyncedAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['monto'] = Variable<double>(monto);
    map['fecha'] = Variable<DateTime>(fecha);
    {
      map['tipo'] = Variable<int>($MovimientosTable.$convertertipo.toSql(tipo));
    }
    map['concepto'] = Variable<String>(concepto);
    if (!nullToAbsent || categoria != null) {
      map['categoria'] = Variable<String>(categoria);
    }
    if (!nullToAbsent || productoId != null) {
      map['producto_id'] = Variable<String>(productoId);
    }
    if (!nullToAbsent || clienteId != null) {
      map['cliente_id'] = Variable<String>(clienteId);
    }
    if (!nullToAbsent || proveedorId != null) {
      map['proveedor_id'] = Variable<String>(proveedorId);
    }
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<String>(localId);
    }
    if (!nullToAbsent || cantidad != null) {
      map['cantidad'] = Variable<int>(cantidad);
    }
    map['es_fiado'] = Variable<bool>(esFiado);
    if (!nullToAbsent || productosJson != null) {
      map['productos_json'] = Variable<String>(productosJson);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  MovimientosCompanion toCompanion(bool nullToAbsent) {
    return MovimientosCompanion(
      id: Value(id),
      monto: Value(monto),
      fecha: Value(fecha),
      tipo: Value(tipo),
      concepto: Value(concepto),
      categoria: categoria == null && nullToAbsent
          ? const Value.absent()
          : Value(categoria),
      productoId: productoId == null && nullToAbsent
          ? const Value.absent()
          : Value(productoId),
      clienteId: clienteId == null && nullToAbsent
          ? const Value.absent()
          : Value(clienteId),
      proveedorId: proveedorId == null && nullToAbsent
          ? const Value.absent()
          : Value(proveedorId),
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
      cantidad: cantidad == null && nullToAbsent
          ? const Value.absent()
          : Value(cantidad),
      esFiado: Value(esFiado),
      productosJson: productosJson == null && nullToAbsent
          ? const Value.absent()
          : Value(productosJson),
      syncStatus: Value(syncStatus),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory MovimientoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovimientoData(
      id: serializer.fromJson<String>(json['id']),
      monto: serializer.fromJson<double>(json['monto']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      tipo: $MovimientosTable.$convertertipo.fromJson(
        serializer.fromJson<int>(json['tipo']),
      ),
      concepto: serializer.fromJson<String>(json['concepto']),
      categoria: serializer.fromJson<String?>(json['categoria']),
      productoId: serializer.fromJson<String?>(json['productoId']),
      clienteId: serializer.fromJson<String?>(json['clienteId']),
      proveedorId: serializer.fromJson<String?>(json['proveedorId']),
      localId: serializer.fromJson<String?>(json['localId']),
      cantidad: serializer.fromJson<int?>(json['cantidad']),
      esFiado: serializer.fromJson<bool>(json['esFiado']),
      productosJson: serializer.fromJson<String?>(json['productosJson']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'monto': serializer.toJson<double>(monto),
      'fecha': serializer.toJson<DateTime>(fecha),
      'tipo': serializer.toJson<int>(
        $MovimientosTable.$convertertipo.toJson(tipo),
      ),
      'concepto': serializer.toJson<String>(concepto),
      'categoria': serializer.toJson<String?>(categoria),
      'productoId': serializer.toJson<String?>(productoId),
      'clienteId': serializer.toJson<String?>(clienteId),
      'proveedorId': serializer.toJson<String?>(proveedorId),
      'localId': serializer.toJson<String?>(localId),
      'cantidad': serializer.toJson<int?>(cantidad),
      'esFiado': serializer.toJson<bool>(esFiado),
      'productosJson': serializer.toJson<String?>(productosJson),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  MovimientoData copyWith({
    String? id,
    double? monto,
    DateTime? fecha,
    MovimientoType? tipo,
    String? concepto,
    Value<String?> categoria = const Value.absent(),
    Value<String?> productoId = const Value.absent(),
    Value<String?> clienteId = const Value.absent(),
    Value<String?> proveedorId = const Value.absent(),
    Value<String?> localId = const Value.absent(),
    Value<int?> cantidad = const Value.absent(),
    bool? esFiado,
    Value<String?> productosJson = const Value.absent(),
    String? syncStatus,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => MovimientoData(
    id: id ?? this.id,
    monto: monto ?? this.monto,
    fecha: fecha ?? this.fecha,
    tipo: tipo ?? this.tipo,
    concepto: concepto ?? this.concepto,
    categoria: categoria.present ? categoria.value : this.categoria,
    productoId: productoId.present ? productoId.value : this.productoId,
    clienteId: clienteId.present ? clienteId.value : this.clienteId,
    proveedorId: proveedorId.present ? proveedorId.value : this.proveedorId,
    localId: localId.present ? localId.value : this.localId,
    cantidad: cantidad.present ? cantidad.value : this.cantidad,
    esFiado: esFiado ?? this.esFiado,
    productosJson: productosJson.present
        ? productosJson.value
        : this.productosJson,
    syncStatus: syncStatus ?? this.syncStatus,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  MovimientoData copyWithCompanion(MovimientosCompanion data) {
    return MovimientoData(
      id: data.id.present ? data.id.value : this.id,
      monto: data.monto.present ? data.monto.value : this.monto,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      concepto: data.concepto.present ? data.concepto.value : this.concepto,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      proveedorId: data.proveedorId.present
          ? data.proveedorId.value
          : this.proveedorId,
      localId: data.localId.present ? data.localId.value : this.localId,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      esFiado: data.esFiado.present ? data.esFiado.value : this.esFiado,
      productosJson: data.productosJson.present
          ? data.productosJson.value
          : this.productosJson,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovimientoData(')
          ..write('id: $id, ')
          ..write('monto: $monto, ')
          ..write('fecha: $fecha, ')
          ..write('tipo: $tipo, ')
          ..write('concepto: $concepto, ')
          ..write('categoria: $categoria, ')
          ..write('productoId: $productoId, ')
          ..write('clienteId: $clienteId, ')
          ..write('proveedorId: $proveedorId, ')
          ..write('localId: $localId, ')
          ..write('cantidad: $cantidad, ')
          ..write('esFiado: $esFiado, ')
          ..write('productosJson: $productosJson, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    monto,
    fecha,
    tipo,
    concepto,
    categoria,
    productoId,
    clienteId,
    proveedorId,
    localId,
    cantidad,
    esFiado,
    productosJson,
    syncStatus,
    lastSyncedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovimientoData &&
          other.id == this.id &&
          other.monto == this.monto &&
          other.fecha == this.fecha &&
          other.tipo == this.tipo &&
          other.concepto == this.concepto &&
          other.categoria == this.categoria &&
          other.productoId == this.productoId &&
          other.clienteId == this.clienteId &&
          other.proveedorId == this.proveedorId &&
          other.localId == this.localId &&
          other.cantidad == this.cantidad &&
          other.esFiado == this.esFiado &&
          other.productosJson == this.productosJson &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.updatedAt == this.updatedAt);
}

class MovimientosCompanion extends UpdateCompanion<MovimientoData> {
  final Value<String> id;
  final Value<double> monto;
  final Value<DateTime> fecha;
  final Value<MovimientoType> tipo;
  final Value<String> concepto;
  final Value<String?> categoria;
  final Value<String?> productoId;
  final Value<String?> clienteId;
  final Value<String?> proveedorId;
  final Value<String?> localId;
  final Value<int?> cantidad;
  final Value<bool> esFiado;
  final Value<String?> productosJson;
  final Value<String> syncStatus;
  final Value<DateTime?> lastSyncedAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const MovimientosCompanion({
    this.id = const Value.absent(),
    this.monto = const Value.absent(),
    this.fecha = const Value.absent(),
    this.tipo = const Value.absent(),
    this.concepto = const Value.absent(),
    this.categoria = const Value.absent(),
    this.productoId = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.proveedorId = const Value.absent(),
    this.localId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.esFiado = const Value.absent(),
    this.productosJson = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MovimientosCompanion.insert({
    required String id,
    required double monto,
    required DateTime fecha,
    required MovimientoType tipo,
    required String concepto,
    this.categoria = const Value.absent(),
    this.productoId = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.proveedorId = const Value.absent(),
    this.localId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.esFiado = const Value.absent(),
    this.productosJson = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       monto = Value(monto),
       fecha = Value(fecha),
       tipo = Value(tipo),
       concepto = Value(concepto);
  static Insertable<MovimientoData> custom({
    Expression<String>? id,
    Expression<double>? monto,
    Expression<DateTime>? fecha,
    Expression<int>? tipo,
    Expression<String>? concepto,
    Expression<String>? categoria,
    Expression<String>? productoId,
    Expression<String>? clienteId,
    Expression<String>? proveedorId,
    Expression<String>? localId,
    Expression<int>? cantidad,
    Expression<bool>? esFiado,
    Expression<String>? productosJson,
    Expression<String>? syncStatus,
    Expression<DateTime>? lastSyncedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (monto != null) 'monto': monto,
      if (fecha != null) 'fecha': fecha,
      if (tipo != null) 'tipo': tipo,
      if (concepto != null) 'concepto': concepto,
      if (categoria != null) 'categoria': categoria,
      if (productoId != null) 'producto_id': productoId,
      if (clienteId != null) 'cliente_id': clienteId,
      if (proveedorId != null) 'proveedor_id': proveedorId,
      if (localId != null) 'local_id': localId,
      if (cantidad != null) 'cantidad': cantidad,
      if (esFiado != null) 'es_fiado': esFiado,
      if (productosJson != null) 'productos_json': productosJson,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MovimientosCompanion copyWith({
    Value<String>? id,
    Value<double>? monto,
    Value<DateTime>? fecha,
    Value<MovimientoType>? tipo,
    Value<String>? concepto,
    Value<String?>? categoria,
    Value<String?>? productoId,
    Value<String?>? clienteId,
    Value<String?>? proveedorId,
    Value<String?>? localId,
    Value<int?>? cantidad,
    Value<bool>? esFiado,
    Value<String?>? productosJson,
    Value<String>? syncStatus,
    Value<DateTime?>? lastSyncedAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return MovimientosCompanion(
      id: id ?? this.id,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      tipo: tipo ?? this.tipo,
      concepto: concepto ?? this.concepto,
      categoria: categoria ?? this.categoria,
      productoId: productoId ?? this.productoId,
      clienteId: clienteId ?? this.clienteId,
      proveedorId: proveedorId ?? this.proveedorId,
      localId: localId ?? this.localId,
      cantidad: cantidad ?? this.cantidad,
      esFiado: esFiado ?? this.esFiado,
      productosJson: productosJson ?? this.productosJson,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<int>(
        $MovimientosTable.$convertertipo.toSql(tipo.value),
      );
    }
    if (concepto.present) {
      map['concepto'] = Variable<String>(concepto.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<String>(productoId.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<String>(clienteId.value);
    }
    if (proveedorId.present) {
      map['proveedor_id'] = Variable<String>(proveedorId.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (esFiado.present) {
      map['es_fiado'] = Variable<bool>(esFiado.value);
    }
    if (productosJson.present) {
      map['productos_json'] = Variable<String>(productosJson.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovimientosCompanion(')
          ..write('id: $id, ')
          ..write('monto: $monto, ')
          ..write('fecha: $fecha, ')
          ..write('tipo: $tipo, ')
          ..write('concepto: $concepto, ')
          ..write('categoria: $categoria, ')
          ..write('productoId: $productoId, ')
          ..write('clienteId: $clienteId, ')
          ..write('proveedorId: $proveedorId, ')
          ..write('localId: $localId, ')
          ..write('cantidad: $cantidad, ')
          ..write('esFiado: $esFiado, ')
          ..write('productosJson: $productosJson, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VentasTable extends Ventas with TableInfo<$VentasTable, VentaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VentasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoMeta = const VerificationMeta('monto');
  @override
  late final GeneratedColumn<double> monto = GeneratedColumn<double>(
    'monto',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<String> clienteId = GeneratedColumn<String>(
    'cliente_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id)',
    ),
  );
  static const VerificationMeta _clienteNombreMeta = const VerificationMeta(
    'clienteNombre',
  );
  @override
  late final GeneratedColumn<String> clienteNombre = GeneratedColumn<String>(
    'cliente_nombre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locales (id)',
    ),
  );
  static const VerificationMeta _conceptoMeta = const VerificationMeta(
    'concepto',
  );
  @override
  late final GeneratedColumn<String> concepto = GeneratedColumn<String>(
    'concepto',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productosJsonMeta = const VerificationMeta(
    'productosJson',
  );
  @override
  late final GeneratedColumn<String> productosJson = GeneratedColumn<String>(
    'productos_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
  static const VerificationMeta _esFiadoMeta = const VerificationMeta(
    'esFiado',
  );
  @override
  late final GeneratedColumn<bool> esFiado = GeneratedColumn<bool>(
    'es_fiado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_fiado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    monto,
    fecha,
    clienteId,
    clienteNombre,
    localId,
    concepto,
    productosJson,
    syncStatus,
    lastSyncedAt,
    updatedAt,
    esFiado,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ventas';
  @override
  VerificationContext validateIntegrity(
    Insertable<VentaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('monto')) {
      context.handle(
        _montoMeta,
        monto.isAcceptableOrUnknown(data['monto']!, _montoMeta),
      );
    } else if (isInserting) {
      context.missing(_montoMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    }
    if (data.containsKey('cliente_nombre')) {
      context.handle(
        _clienteNombreMeta,
        clienteNombre.isAcceptableOrUnknown(
          data['cliente_nombre']!,
          _clienteNombreMeta,
        ),
      );
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('concepto')) {
      context.handle(
        _conceptoMeta,
        concepto.isAcceptableOrUnknown(data['concepto']!, _conceptoMeta),
      );
    }
    if (data.containsKey('productos_json')) {
      context.handle(
        _productosJsonMeta,
        productosJson.isAcceptableOrUnknown(
          data['productos_json']!,
          _productosJsonMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('es_fiado')) {
      context.handle(
        _esFiadoMeta,
        esFiado.isAcceptableOrUnknown(data['es_fiado']!, _esFiadoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VentaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VentaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      monto: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_id'],
      ),
      clienteNombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_nombre'],
      ),
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      ),
      concepto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concepto'],
      ),
      productosJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}productos_json'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      esFiado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_fiado'],
      )!,
    );
  }

  @override
  $VentasTable createAlias(String alias) {
    return $VentasTable(attachedDatabase, alias);
  }
}

class VentaData extends DataClass implements Insertable<VentaData> {
  final String id;
  final double monto;
  final DateTime fecha;
  final String? clienteId;
  final String? clienteNombre;
  final String? localId;
  final String? concepto;
  final String? productosJson;
  final String syncStatus;
  final DateTime? lastSyncedAt;
  final DateTime? updatedAt;
  final bool esFiado;
  const VentaData({
    required this.id,
    required this.monto,
    required this.fecha,
    this.clienteId,
    this.clienteNombre,
    this.localId,
    this.concepto,
    this.productosJson,
    required this.syncStatus,
    this.lastSyncedAt,
    this.updatedAt,
    required this.esFiado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['monto'] = Variable<double>(monto);
    map['fecha'] = Variable<DateTime>(fecha);
    if (!nullToAbsent || clienteId != null) {
      map['cliente_id'] = Variable<String>(clienteId);
    }
    if (!nullToAbsent || clienteNombre != null) {
      map['cliente_nombre'] = Variable<String>(clienteNombre);
    }
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<String>(localId);
    }
    if (!nullToAbsent || concepto != null) {
      map['concepto'] = Variable<String>(concepto);
    }
    if (!nullToAbsent || productosJson != null) {
      map['productos_json'] = Variable<String>(productosJson);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['es_fiado'] = Variable<bool>(esFiado);
    return map;
  }

  VentasCompanion toCompanion(bool nullToAbsent) {
    return VentasCompanion(
      id: Value(id),
      monto: Value(monto),
      fecha: Value(fecha),
      clienteId: clienteId == null && nullToAbsent
          ? const Value.absent()
          : Value(clienteId),
      clienteNombre: clienteNombre == null && nullToAbsent
          ? const Value.absent()
          : Value(clienteNombre),
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
      concepto: concepto == null && nullToAbsent
          ? const Value.absent()
          : Value(concepto),
      productosJson: productosJson == null && nullToAbsent
          ? const Value.absent()
          : Value(productosJson),
      syncStatus: Value(syncStatus),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      esFiado: Value(esFiado),
    );
  }

  factory VentaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VentaData(
      id: serializer.fromJson<String>(json['id']),
      monto: serializer.fromJson<double>(json['monto']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      clienteId: serializer.fromJson<String?>(json['clienteId']),
      clienteNombre: serializer.fromJson<String?>(json['clienteNombre']),
      localId: serializer.fromJson<String?>(json['localId']),
      concepto: serializer.fromJson<String?>(json['concepto']),
      productosJson: serializer.fromJson<String?>(json['productosJson']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      esFiado: serializer.fromJson<bool>(json['esFiado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'monto': serializer.toJson<double>(monto),
      'fecha': serializer.toJson<DateTime>(fecha),
      'clienteId': serializer.toJson<String?>(clienteId),
      'clienteNombre': serializer.toJson<String?>(clienteNombre),
      'localId': serializer.toJson<String?>(localId),
      'concepto': serializer.toJson<String?>(concepto),
      'productosJson': serializer.toJson<String?>(productosJson),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'esFiado': serializer.toJson<bool>(esFiado),
    };
  }

  VentaData copyWith({
    String? id,
    double? monto,
    DateTime? fecha,
    Value<String?> clienteId = const Value.absent(),
    Value<String?> clienteNombre = const Value.absent(),
    Value<String?> localId = const Value.absent(),
    Value<String?> concepto = const Value.absent(),
    Value<String?> productosJson = const Value.absent(),
    String? syncStatus,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    bool? esFiado,
  }) => VentaData(
    id: id ?? this.id,
    monto: monto ?? this.monto,
    fecha: fecha ?? this.fecha,
    clienteId: clienteId.present ? clienteId.value : this.clienteId,
    clienteNombre: clienteNombre.present
        ? clienteNombre.value
        : this.clienteNombre,
    localId: localId.present ? localId.value : this.localId,
    concepto: concepto.present ? concepto.value : this.concepto,
    productosJson: productosJson.present
        ? productosJson.value
        : this.productosJson,
    syncStatus: syncStatus ?? this.syncStatus,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    esFiado: esFiado ?? this.esFiado,
  );
  VentaData copyWithCompanion(VentasCompanion data) {
    return VentaData(
      id: data.id.present ? data.id.value : this.id,
      monto: data.monto.present ? data.monto.value : this.monto,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      clienteNombre: data.clienteNombre.present
          ? data.clienteNombre.value
          : this.clienteNombre,
      localId: data.localId.present ? data.localId.value : this.localId,
      concepto: data.concepto.present ? data.concepto.value : this.concepto,
      productosJson: data.productosJson.present
          ? data.productosJson.value
          : this.productosJson,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      esFiado: data.esFiado.present ? data.esFiado.value : this.esFiado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VentaData(')
          ..write('id: $id, ')
          ..write('monto: $monto, ')
          ..write('fecha: $fecha, ')
          ..write('clienteId: $clienteId, ')
          ..write('clienteNombre: $clienteNombre, ')
          ..write('localId: $localId, ')
          ..write('concepto: $concepto, ')
          ..write('productosJson: $productosJson, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('esFiado: $esFiado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    monto,
    fecha,
    clienteId,
    clienteNombre,
    localId,
    concepto,
    productosJson,
    syncStatus,
    lastSyncedAt,
    updatedAt,
    esFiado,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VentaData &&
          other.id == this.id &&
          other.monto == this.monto &&
          other.fecha == this.fecha &&
          other.clienteId == this.clienteId &&
          other.clienteNombre == this.clienteNombre &&
          other.localId == this.localId &&
          other.concepto == this.concepto &&
          other.productosJson == this.productosJson &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.updatedAt == this.updatedAt &&
          other.esFiado == this.esFiado);
}

class VentasCompanion extends UpdateCompanion<VentaData> {
  final Value<String> id;
  final Value<double> monto;
  final Value<DateTime> fecha;
  final Value<String?> clienteId;
  final Value<String?> clienteNombre;
  final Value<String?> localId;
  final Value<String?> concepto;
  final Value<String?> productosJson;
  final Value<String> syncStatus;
  final Value<DateTime?> lastSyncedAt;
  final Value<DateTime?> updatedAt;
  final Value<bool> esFiado;
  final Value<int> rowid;
  const VentasCompanion({
    this.id = const Value.absent(),
    this.monto = const Value.absent(),
    this.fecha = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.clienteNombre = const Value.absent(),
    this.localId = const Value.absent(),
    this.concepto = const Value.absent(),
    this.productosJson = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.esFiado = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VentasCompanion.insert({
    required String id,
    required double monto,
    required DateTime fecha,
    this.clienteId = const Value.absent(),
    this.clienteNombre = const Value.absent(),
    this.localId = const Value.absent(),
    this.concepto = const Value.absent(),
    this.productosJson = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.esFiado = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       monto = Value(monto),
       fecha = Value(fecha);
  static Insertable<VentaData> custom({
    Expression<String>? id,
    Expression<double>? monto,
    Expression<DateTime>? fecha,
    Expression<String>? clienteId,
    Expression<String>? clienteNombre,
    Expression<String>? localId,
    Expression<String>? concepto,
    Expression<String>? productosJson,
    Expression<String>? syncStatus,
    Expression<DateTime>? lastSyncedAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? esFiado,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (monto != null) 'monto': monto,
      if (fecha != null) 'fecha': fecha,
      if (clienteId != null) 'cliente_id': clienteId,
      if (clienteNombre != null) 'cliente_nombre': clienteNombre,
      if (localId != null) 'local_id': localId,
      if (concepto != null) 'concepto': concepto,
      if (productosJson != null) 'productos_json': productosJson,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (esFiado != null) 'es_fiado': esFiado,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VentasCompanion copyWith({
    Value<String>? id,
    Value<double>? monto,
    Value<DateTime>? fecha,
    Value<String?>? clienteId,
    Value<String?>? clienteNombre,
    Value<String?>? localId,
    Value<String?>? concepto,
    Value<String?>? productosJson,
    Value<String>? syncStatus,
    Value<DateTime?>? lastSyncedAt,
    Value<DateTime?>? updatedAt,
    Value<bool>? esFiado,
    Value<int>? rowid,
  }) {
    return VentasCompanion(
      id: id ?? this.id,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      clienteId: clienteId ?? this.clienteId,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      localId: localId ?? this.localId,
      concepto: concepto ?? this.concepto,
      productosJson: productosJson ?? this.productosJson,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      esFiado: esFiado ?? this.esFiado,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<String>(clienteId.value);
    }
    if (clienteNombre.present) {
      map['cliente_nombre'] = Variable<String>(clienteNombre.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (concepto.present) {
      map['concepto'] = Variable<String>(concepto.value);
    }
    if (productosJson.present) {
      map['productos_json'] = Variable<String>(productosJson.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (esFiado.present) {
      map['es_fiado'] = Variable<bool>(esFiado.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VentasCompanion(')
          ..write('id: $id, ')
          ..write('monto: $monto, ')
          ..write('fecha: $fecha, ')
          ..write('clienteId: $clienteId, ')
          ..write('clienteNombre: $clienteNombre, ')
          ..write('localId: $localId, ')
          ..write('concepto: $concepto, ')
          ..write('productosJson: $productosJson, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('esFiado: $esFiado, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PedidosProveedorTable extends PedidosProveedor
    with TableInfo<$PedidosProveedorTable, PedidoProveedorData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PedidosProveedorTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proveedorIdMeta = const VerificationMeta(
    'proveedorId',
  );
  @override
  late final GeneratedColumn<String> proveedorId = GeneratedColumn<String>(
    'proveedor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES proveedores (id)',
    ),
  );
  static const VerificationMeta _proveedorNombreMeta = const VerificationMeta(
    'proveedorNombre',
  );
  @override
  late final GeneratedColumn<String> proveedorNombre = GeneratedColumn<String>(
    'proveedor_nombre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locales (id)',
    ),
  );
  static const VerificationMeta _fechaPedidoMeta = const VerificationMeta(
    'fechaPedido',
  );
  @override
  late final GeneratedColumn<DateTime> fechaPedido = GeneratedColumn<DateTime>(
    'fecha_pedido',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaEntregaMeta = const VerificationMeta(
    'fechaEntrega',
  );
  @override
  late final GeneratedColumn<DateTime> fechaEntrega = GeneratedColumn<DateTime>(
    'fecha_entrega',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productosMeta = const VerificationMeta(
    'productos',
  );
  @override
  late final GeneratedColumn<String> productos = GeneratedColumn<String>(
    'productos',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoTotalMeta = const VerificationMeta(
    'montoTotal',
  );
  @override
  late final GeneratedColumn<double> montoTotal = GeneratedColumn<double>(
    'monto_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isEntregadoMeta = const VerificationMeta(
    'isEntregado',
  );
  @override
  late final GeneratedColumn<bool> isEntregado = GeneratedColumn<bool>(
    'is_entregado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_entregado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notasMeta = const VerificationMeta('notas');
  @override
  late final GeneratedColumn<String> notas = GeneratedColumn<String>(
    'notas',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
    proveedorId,
    proveedorNombre,
    localId,
    fechaPedido,
    fechaEntrega,
    productos,
    montoTotal,
    isEntregado,
    notas,
    syncStatus,
    lastSyncedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pedidos_proveedor';
  @override
  VerificationContext validateIntegrity(
    Insertable<PedidoProveedorData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('proveedor_id')) {
      context.handle(
        _proveedorIdMeta,
        proveedorId.isAcceptableOrUnknown(
          data['proveedor_id']!,
          _proveedorIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proveedorIdMeta);
    }
    if (data.containsKey('proveedor_nombre')) {
      context.handle(
        _proveedorNombreMeta,
        proveedorNombre.isAcceptableOrUnknown(
          data['proveedor_nombre']!,
          _proveedorNombreMeta,
        ),
      );
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('fecha_pedido')) {
      context.handle(
        _fechaPedidoMeta,
        fechaPedido.isAcceptableOrUnknown(
          data['fecha_pedido']!,
          _fechaPedidoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaPedidoMeta);
    }
    if (data.containsKey('fecha_entrega')) {
      context.handle(
        _fechaEntregaMeta,
        fechaEntrega.isAcceptableOrUnknown(
          data['fecha_entrega']!,
          _fechaEntregaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaEntregaMeta);
    }
    if (data.containsKey('productos')) {
      context.handle(
        _productosMeta,
        productos.isAcceptableOrUnknown(data['productos']!, _productosMeta),
      );
    } else if (isInserting) {
      context.missing(_productosMeta);
    }
    if (data.containsKey('monto_total')) {
      context.handle(
        _montoTotalMeta,
        montoTotal.isAcceptableOrUnknown(data['monto_total']!, _montoTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_montoTotalMeta);
    }
    if (data.containsKey('is_entregado')) {
      context.handle(
        _isEntregadoMeta,
        isEntregado.isAcceptableOrUnknown(
          data['is_entregado']!,
          _isEntregadoMeta,
        ),
      );
    }
    if (data.containsKey('notas')) {
      context.handle(
        _notasMeta,
        notas.isAcceptableOrUnknown(data['notas']!, _notasMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
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
  PedidoProveedorData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PedidoProveedorData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      proveedorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proveedor_id'],
      )!,
      proveedorNombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proveedor_nombre'],
      ),
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      ),
      fechaPedido: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_pedido'],
      )!,
      fechaEntrega: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_entrega'],
      )!,
      productos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}productos'],
      )!,
      montoTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto_total'],
      )!,
      isEntregado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_entregado'],
      )!,
      notas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notas'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $PedidosProveedorTable createAlias(String alias) {
    return $PedidosProveedorTable(attachedDatabase, alias);
  }
}

class PedidoProveedorData extends DataClass
    implements Insertable<PedidoProveedorData> {
  final String id;
  final String proveedorId;
  final String? proveedorNombre;
  final String? localId;
  final DateTime fechaPedido;
  final DateTime fechaEntrega;
  final String productos;
  final double montoTotal;
  final bool isEntregado;
  final String? notas;
  final String syncStatus;
  final DateTime? lastSyncedAt;
  final DateTime? updatedAt;
  const PedidoProveedorData({
    required this.id,
    required this.proveedorId,
    this.proveedorNombre,
    this.localId,
    required this.fechaPedido,
    required this.fechaEntrega,
    required this.productos,
    required this.montoTotal,
    required this.isEntregado,
    this.notas,
    required this.syncStatus,
    this.lastSyncedAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['proveedor_id'] = Variable<String>(proveedorId);
    if (!nullToAbsent || proveedorNombre != null) {
      map['proveedor_nombre'] = Variable<String>(proveedorNombre);
    }
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<String>(localId);
    }
    map['fecha_pedido'] = Variable<DateTime>(fechaPedido);
    map['fecha_entrega'] = Variable<DateTime>(fechaEntrega);
    map['productos'] = Variable<String>(productos);
    map['monto_total'] = Variable<double>(montoTotal);
    map['is_entregado'] = Variable<bool>(isEntregado);
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  PedidosProveedorCompanion toCompanion(bool nullToAbsent) {
    return PedidosProveedorCompanion(
      id: Value(id),
      proveedorId: Value(proveedorId),
      proveedorNombre: proveedorNombre == null && nullToAbsent
          ? const Value.absent()
          : Value(proveedorNombre),
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
      fechaPedido: Value(fechaPedido),
      fechaEntrega: Value(fechaEntrega),
      productos: Value(productos),
      montoTotal: Value(montoTotal),
      isEntregado: Value(isEntregado),
      notas: notas == null && nullToAbsent
          ? const Value.absent()
          : Value(notas),
      syncStatus: Value(syncStatus),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory PedidoProveedorData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PedidoProveedorData(
      id: serializer.fromJson<String>(json['id']),
      proveedorId: serializer.fromJson<String>(json['proveedorId']),
      proveedorNombre: serializer.fromJson<String?>(json['proveedorNombre']),
      localId: serializer.fromJson<String?>(json['localId']),
      fechaPedido: serializer.fromJson<DateTime>(json['fechaPedido']),
      fechaEntrega: serializer.fromJson<DateTime>(json['fechaEntrega']),
      productos: serializer.fromJson<String>(json['productos']),
      montoTotal: serializer.fromJson<double>(json['montoTotal']),
      isEntregado: serializer.fromJson<bool>(json['isEntregado']),
      notas: serializer.fromJson<String?>(json['notas']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'proveedorId': serializer.toJson<String>(proveedorId),
      'proveedorNombre': serializer.toJson<String?>(proveedorNombre),
      'localId': serializer.toJson<String?>(localId),
      'fechaPedido': serializer.toJson<DateTime>(fechaPedido),
      'fechaEntrega': serializer.toJson<DateTime>(fechaEntrega),
      'productos': serializer.toJson<String>(productos),
      'montoTotal': serializer.toJson<double>(montoTotal),
      'isEntregado': serializer.toJson<bool>(isEntregado),
      'notas': serializer.toJson<String?>(notas),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  PedidoProveedorData copyWith({
    String? id,
    String? proveedorId,
    Value<String?> proveedorNombre = const Value.absent(),
    Value<String?> localId = const Value.absent(),
    DateTime? fechaPedido,
    DateTime? fechaEntrega,
    String? productos,
    double? montoTotal,
    bool? isEntregado,
    Value<String?> notas = const Value.absent(),
    String? syncStatus,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => PedidoProveedorData(
    id: id ?? this.id,
    proveedorId: proveedorId ?? this.proveedorId,
    proveedorNombre: proveedorNombre.present
        ? proveedorNombre.value
        : this.proveedorNombre,
    localId: localId.present ? localId.value : this.localId,
    fechaPedido: fechaPedido ?? this.fechaPedido,
    fechaEntrega: fechaEntrega ?? this.fechaEntrega,
    productos: productos ?? this.productos,
    montoTotal: montoTotal ?? this.montoTotal,
    isEntregado: isEntregado ?? this.isEntregado,
    notas: notas.present ? notas.value : this.notas,
    syncStatus: syncStatus ?? this.syncStatus,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  PedidoProveedorData copyWithCompanion(PedidosProveedorCompanion data) {
    return PedidoProveedorData(
      id: data.id.present ? data.id.value : this.id,
      proveedorId: data.proveedorId.present
          ? data.proveedorId.value
          : this.proveedorId,
      proveedorNombre: data.proveedorNombre.present
          ? data.proveedorNombre.value
          : this.proveedorNombre,
      localId: data.localId.present ? data.localId.value : this.localId,
      fechaPedido: data.fechaPedido.present
          ? data.fechaPedido.value
          : this.fechaPedido,
      fechaEntrega: data.fechaEntrega.present
          ? data.fechaEntrega.value
          : this.fechaEntrega,
      productos: data.productos.present ? data.productos.value : this.productos,
      montoTotal: data.montoTotal.present
          ? data.montoTotal.value
          : this.montoTotal,
      isEntregado: data.isEntregado.present
          ? data.isEntregado.value
          : this.isEntregado,
      notas: data.notas.present ? data.notas.value : this.notas,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PedidoProveedorData(')
          ..write('id: $id, ')
          ..write('proveedorId: $proveedorId, ')
          ..write('proveedorNombre: $proveedorNombre, ')
          ..write('localId: $localId, ')
          ..write('fechaPedido: $fechaPedido, ')
          ..write('fechaEntrega: $fechaEntrega, ')
          ..write('productos: $productos, ')
          ..write('montoTotal: $montoTotal, ')
          ..write('isEntregado: $isEntregado, ')
          ..write('notas: $notas, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    proveedorId,
    proveedorNombre,
    localId,
    fechaPedido,
    fechaEntrega,
    productos,
    montoTotal,
    isEntregado,
    notas,
    syncStatus,
    lastSyncedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PedidoProveedorData &&
          other.id == this.id &&
          other.proveedorId == this.proveedorId &&
          other.proveedorNombre == this.proveedorNombre &&
          other.localId == this.localId &&
          other.fechaPedido == this.fechaPedido &&
          other.fechaEntrega == this.fechaEntrega &&
          other.productos == this.productos &&
          other.montoTotal == this.montoTotal &&
          other.isEntregado == this.isEntregado &&
          other.notas == this.notas &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.updatedAt == this.updatedAt);
}

class PedidosProveedorCompanion extends UpdateCompanion<PedidoProveedorData> {
  final Value<String> id;
  final Value<String> proveedorId;
  final Value<String?> proveedorNombre;
  final Value<String?> localId;
  final Value<DateTime> fechaPedido;
  final Value<DateTime> fechaEntrega;
  final Value<String> productos;
  final Value<double> montoTotal;
  final Value<bool> isEntregado;
  final Value<String?> notas;
  final Value<String> syncStatus;
  final Value<DateTime?> lastSyncedAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const PedidosProveedorCompanion({
    this.id = const Value.absent(),
    this.proveedorId = const Value.absent(),
    this.proveedorNombre = const Value.absent(),
    this.localId = const Value.absent(),
    this.fechaPedido = const Value.absent(),
    this.fechaEntrega = const Value.absent(),
    this.productos = const Value.absent(),
    this.montoTotal = const Value.absent(),
    this.isEntregado = const Value.absent(),
    this.notas = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PedidosProveedorCompanion.insert({
    required String id,
    required String proveedorId,
    this.proveedorNombre = const Value.absent(),
    this.localId = const Value.absent(),
    required DateTime fechaPedido,
    required DateTime fechaEntrega,
    required String productos,
    required double montoTotal,
    this.isEntregado = const Value.absent(),
    this.notas = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       proveedorId = Value(proveedorId),
       fechaPedido = Value(fechaPedido),
       fechaEntrega = Value(fechaEntrega),
       productos = Value(productos),
       montoTotal = Value(montoTotal);
  static Insertable<PedidoProveedorData> custom({
    Expression<String>? id,
    Expression<String>? proveedorId,
    Expression<String>? proveedorNombre,
    Expression<String>? localId,
    Expression<DateTime>? fechaPedido,
    Expression<DateTime>? fechaEntrega,
    Expression<String>? productos,
    Expression<double>? montoTotal,
    Expression<bool>? isEntregado,
    Expression<String>? notas,
    Expression<String>? syncStatus,
    Expression<DateTime>? lastSyncedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (proveedorId != null) 'proveedor_id': proveedorId,
      if (proveedorNombre != null) 'proveedor_nombre': proveedorNombre,
      if (localId != null) 'local_id': localId,
      if (fechaPedido != null) 'fecha_pedido': fechaPedido,
      if (fechaEntrega != null) 'fecha_entrega': fechaEntrega,
      if (productos != null) 'productos': productos,
      if (montoTotal != null) 'monto_total': montoTotal,
      if (isEntregado != null) 'is_entregado': isEntregado,
      if (notas != null) 'notas': notas,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PedidosProveedorCompanion copyWith({
    Value<String>? id,
    Value<String>? proveedorId,
    Value<String?>? proveedorNombre,
    Value<String?>? localId,
    Value<DateTime>? fechaPedido,
    Value<DateTime>? fechaEntrega,
    Value<String>? productos,
    Value<double>? montoTotal,
    Value<bool>? isEntregado,
    Value<String?>? notas,
    Value<String>? syncStatus,
    Value<DateTime?>? lastSyncedAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return PedidosProveedorCompanion(
      id: id ?? this.id,
      proveedorId: proveedorId ?? this.proveedorId,
      proveedorNombre: proveedorNombre ?? this.proveedorNombre,
      localId: localId ?? this.localId,
      fechaPedido: fechaPedido ?? this.fechaPedido,
      fechaEntrega: fechaEntrega ?? this.fechaEntrega,
      productos: productos ?? this.productos,
      montoTotal: montoTotal ?? this.montoTotal,
      isEntregado: isEntregado ?? this.isEntregado,
      notas: notas ?? this.notas,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (proveedorId.present) {
      map['proveedor_id'] = Variable<String>(proveedorId.value);
    }
    if (proveedorNombre.present) {
      map['proveedor_nombre'] = Variable<String>(proveedorNombre.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (fechaPedido.present) {
      map['fecha_pedido'] = Variable<DateTime>(fechaPedido.value);
    }
    if (fechaEntrega.present) {
      map['fecha_entrega'] = Variable<DateTime>(fechaEntrega.value);
    }
    if (productos.present) {
      map['productos'] = Variable<String>(productos.value);
    }
    if (montoTotal.present) {
      map['monto_total'] = Variable<double>(montoTotal.value);
    }
    if (isEntregado.present) {
      map['is_entregado'] = Variable<bool>(isEntregado.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PedidosProveedorCompanion(')
          ..write('id: $id, ')
          ..write('proveedorId: $proveedorId, ')
          ..write('proveedorNombre: $proveedorNombre, ')
          ..write('localId: $localId, ')
          ..write('fechaPedido: $fechaPedido, ')
          ..write('fechaEntrega: $fechaEntrega, ')
          ..write('productos: $productos, ')
          ..write('montoTotal: $montoTotal, ')
          ..write('isEntregado: $isEntregado, ')
          ..write('notas: $notas, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalUsersTable extends LocalUsers
    with TableInfo<$LocalUsersTable, LocalUserData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hashedPasswordMeta = const VerificationMeta(
    'hashedPassword',
  );
  @override
  late final GeneratedColumn<String> hashedPassword = GeneratedColumn<String>(
    'hashed_password',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastLoginMeta = const VerificationMeta(
    'lastLogin',
  );
  @override
  late final GeneratedColumn<DateTime> lastLogin = GeneratedColumn<DateTime>(
    'last_login',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinHashMeta = const VerificationMeta(
    'pinHash',
  );
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
    'pin_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rolMeta = const VerificationMeta('rol');
  @override
  late final GeneratedColumn<String> rol = GeneratedColumn<String>(
    'rol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('vendedor'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    hashedPassword,
    lastLogin,
    pinHash,
    rol,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_users';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalUserData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('hashed_password')) {
      context.handle(
        _hashedPasswordMeta,
        hashedPassword.isAcceptableOrUnknown(
          data['hashed_password']!,
          _hashedPasswordMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hashedPasswordMeta);
    }
    if (data.containsKey('last_login')) {
      context.handle(
        _lastLoginMeta,
        lastLogin.isAcceptableOrUnknown(data['last_login']!, _lastLoginMeta),
      );
    } else if (isInserting) {
      context.missing(_lastLoginMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(
        _pinHashMeta,
        pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta),
      );
    }
    if (data.containsKey('rol')) {
      context.handle(
        _rolMeta,
        rol.isAcceptableOrUnknown(data['rol']!, _rolMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalUserData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUserData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      hashedPassword: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hashed_password'],
      )!,
      lastLogin: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_login'],
      )!,
      pinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_hash'],
      ),
      rol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rol'],
      )!,
    );
  }

  @override
  $LocalUsersTable createAlias(String alias) {
    return $LocalUsersTable(attachedDatabase, alias);
  }
}

class LocalUserData extends DataClass implements Insertable<LocalUserData> {
  final String id;
  final String email;
  final String hashedPassword;
  final DateTime lastLogin;
  final String? pinHash;
  final String rol;
  const LocalUserData({
    required this.id,
    required this.email,
    required this.hashedPassword,
    required this.lastLogin,
    this.pinHash,
    required this.rol,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['hashed_password'] = Variable<String>(hashedPassword);
    map['last_login'] = Variable<DateTime>(lastLogin);
    if (!nullToAbsent || pinHash != null) {
      map['pin_hash'] = Variable<String>(pinHash);
    }
    map['rol'] = Variable<String>(rol);
    return map;
  }

  LocalUsersCompanion toCompanion(bool nullToAbsent) {
    return LocalUsersCompanion(
      id: Value(id),
      email: Value(email),
      hashedPassword: Value(hashedPassword),
      lastLogin: Value(lastLogin),
      pinHash: pinHash == null && nullToAbsent
          ? const Value.absent()
          : Value(pinHash),
      rol: Value(rol),
    );
  }

  factory LocalUserData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUserData(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      hashedPassword: serializer.fromJson<String>(json['hashedPassword']),
      lastLogin: serializer.fromJson<DateTime>(json['lastLogin']),
      pinHash: serializer.fromJson<String?>(json['pinHash']),
      rol: serializer.fromJson<String>(json['rol']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'hashedPassword': serializer.toJson<String>(hashedPassword),
      'lastLogin': serializer.toJson<DateTime>(lastLogin),
      'pinHash': serializer.toJson<String?>(pinHash),
      'rol': serializer.toJson<String>(rol),
    };
  }

  LocalUserData copyWith({
    String? id,
    String? email,
    String? hashedPassword,
    DateTime? lastLogin,
    Value<String?> pinHash = const Value.absent(),
    String? rol,
  }) => LocalUserData(
    id: id ?? this.id,
    email: email ?? this.email,
    hashedPassword: hashedPassword ?? this.hashedPassword,
    lastLogin: lastLogin ?? this.lastLogin,
    pinHash: pinHash.present ? pinHash.value : this.pinHash,
    rol: rol ?? this.rol,
  );
  LocalUserData copyWithCompanion(LocalUsersCompanion data) {
    return LocalUserData(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      hashedPassword: data.hashedPassword.present
          ? data.hashedPassword.value
          : this.hashedPassword,
      lastLogin: data.lastLogin.present ? data.lastLogin.value : this.lastLogin,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      rol: data.rol.present ? data.rol.value : this.rol,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserData(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('hashedPassword: $hashedPassword, ')
          ..write('lastLogin: $lastLogin, ')
          ..write('pinHash: $pinHash, ')
          ..write('rol: $rol')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, email, hashedPassword, lastLogin, pinHash, rol);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUserData &&
          other.id == this.id &&
          other.email == this.email &&
          other.hashedPassword == this.hashedPassword &&
          other.lastLogin == this.lastLogin &&
          other.pinHash == this.pinHash &&
          other.rol == this.rol);
}

class LocalUsersCompanion extends UpdateCompanion<LocalUserData> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> hashedPassword;
  final Value<DateTime> lastLogin;
  final Value<String?> pinHash;
  final Value<String> rol;
  final Value<int> rowid;
  const LocalUsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.hashedPassword = const Value.absent(),
    this.lastLogin = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.rol = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalUsersCompanion.insert({
    required String id,
    required String email,
    required String hashedPassword,
    required DateTime lastLogin,
    this.pinHash = const Value.absent(),
    this.rol = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       email = Value(email),
       hashedPassword = Value(hashedPassword),
       lastLogin = Value(lastLogin);
  static Insertable<LocalUserData> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? hashedPassword,
    Expression<DateTime>? lastLogin,
    Expression<String>? pinHash,
    Expression<String>? rol,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (hashedPassword != null) 'hashed_password': hashedPassword,
      if (lastLogin != null) 'last_login': lastLogin,
      if (pinHash != null) 'pin_hash': pinHash,
      if (rol != null) 'rol': rol,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalUsersCompanion copyWith({
    Value<String>? id,
    Value<String>? email,
    Value<String>? hashedPassword,
    Value<DateTime>? lastLogin,
    Value<String?>? pinHash,
    Value<String>? rol,
    Value<int>? rowid,
  }) {
    return LocalUsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      hashedPassword: hashedPassword ?? this.hashedPassword,
      lastLogin: lastLogin ?? this.lastLogin,
      pinHash: pinHash ?? this.pinHash,
      rol: rol ?? this.rol,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (hashedPassword.present) {
      map['hashed_password'] = Variable<String>(hashedPassword.value);
    }
    if (lastLogin.present) {
      map['last_login'] = Variable<DateTime>(lastLogin.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (rol.present) {
      map['rol'] = Variable<String>(rol.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalUsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('hashedPassword: $hashedPassword, ')
          ..write('lastLogin: $lastLogin, ')
          ..write('pinHash: $pinHash, ')
          ..write('rol: $rol, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AbonosTable extends Abonos with TableInfo<$AbonosTable, AbonoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AbonosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<String> clienteId = GeneratedColumn<String>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id)',
    ),
  );
  static const VerificationMeta _ventaIdMeta = const VerificationMeta(
    'ventaId',
  );
  @override
  late final GeneratedColumn<String> ventaId = GeneratedColumn<String>(
    'venta_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ventas (id)',
    ),
  );
  static const VerificationMeta _montoMeta = const VerificationMeta('monto');
  @override
  late final GeneratedColumn<double> monto = GeneratedColumn<double>(
    'monto',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saldoRestanteMeta = const VerificationMeta(
    'saldoRestante',
  );
  @override
  late final GeneratedColumn<double> saldoRestante = GeneratedColumn<double>(
    'saldo_restante',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conceptoMeta = const VerificationMeta(
    'concepto',
  );
  @override
  late final GeneratedColumn<String> concepto = GeneratedColumn<String>(
    'concepto',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending_upload'),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clienteId,
    ventaId,
    monto,
    fecha,
    saldoRestante,
    concepto,
    syncStatus,
    lastSyncedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'abonos';
  @override
  VerificationContext validateIntegrity(
    Insertable<AbonoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('venta_id')) {
      context.handle(
        _ventaIdMeta,
        ventaId.isAcceptableOrUnknown(data['venta_id']!, _ventaIdMeta),
      );
    }
    if (data.containsKey('monto')) {
      context.handle(
        _montoMeta,
        monto.isAcceptableOrUnknown(data['monto']!, _montoMeta),
      );
    } else if (isInserting) {
      context.missing(_montoMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('saldo_restante')) {
      context.handle(
        _saldoRestanteMeta,
        saldoRestante.isAcceptableOrUnknown(
          data['saldo_restante']!,
          _saldoRestanteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_saldoRestanteMeta);
    }
    if (data.containsKey('concepto')) {
      context.handle(
        _conceptoMeta,
        concepto.isAcceptableOrUnknown(data['concepto']!, _conceptoMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
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
  AbonoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AbonoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_id'],
      )!,
      ventaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}venta_id'],
      ),
      monto: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      saldoRestante: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saldo_restante'],
      )!,
      concepto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concepto'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AbonosTable createAlias(String alias) {
    return $AbonosTable(attachedDatabase, alias);
  }
}

class AbonoData extends DataClass implements Insertable<AbonoData> {
  final String id;
  final String clienteId;
  final String? ventaId;
  final double monto;
  final DateTime fecha;
  final double saldoRestante;
  final String? concepto;
  final String syncStatus;
  final DateTime? lastSyncedAt;
  final DateTime updatedAt;
  const AbonoData({
    required this.id,
    required this.clienteId,
    this.ventaId,
    required this.monto,
    required this.fecha,
    required this.saldoRestante,
    this.concepto,
    required this.syncStatus,
    this.lastSyncedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cliente_id'] = Variable<String>(clienteId);
    if (!nullToAbsent || ventaId != null) {
      map['venta_id'] = Variable<String>(ventaId);
    }
    map['monto'] = Variable<double>(monto);
    map['fecha'] = Variable<DateTime>(fecha);
    map['saldo_restante'] = Variable<double>(saldoRestante);
    if (!nullToAbsent || concepto != null) {
      map['concepto'] = Variable<String>(concepto);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AbonosCompanion toCompanion(bool nullToAbsent) {
    return AbonosCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      ventaId: ventaId == null && nullToAbsent
          ? const Value.absent()
          : Value(ventaId),
      monto: Value(monto),
      fecha: Value(fecha),
      saldoRestante: Value(saldoRestante),
      concepto: concepto == null && nullToAbsent
          ? const Value.absent()
          : Value(concepto),
      syncStatus: Value(syncStatus),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AbonoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AbonoData(
      id: serializer.fromJson<String>(json['id']),
      clienteId: serializer.fromJson<String>(json['clienteId']),
      ventaId: serializer.fromJson<String?>(json['ventaId']),
      monto: serializer.fromJson<double>(json['monto']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      saldoRestante: serializer.fromJson<double>(json['saldoRestante']),
      concepto: serializer.fromJson<String?>(json['concepto']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clienteId': serializer.toJson<String>(clienteId),
      'ventaId': serializer.toJson<String?>(ventaId),
      'monto': serializer.toJson<double>(monto),
      'fecha': serializer.toJson<DateTime>(fecha),
      'saldoRestante': serializer.toJson<double>(saldoRestante),
      'concepto': serializer.toJson<String?>(concepto),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AbonoData copyWith({
    String? id,
    String? clienteId,
    Value<String?> ventaId = const Value.absent(),
    double? monto,
    DateTime? fecha,
    double? saldoRestante,
    Value<String?> concepto = const Value.absent(),
    String? syncStatus,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => AbonoData(
    id: id ?? this.id,
    clienteId: clienteId ?? this.clienteId,
    ventaId: ventaId.present ? ventaId.value : this.ventaId,
    monto: monto ?? this.monto,
    fecha: fecha ?? this.fecha,
    saldoRestante: saldoRestante ?? this.saldoRestante,
    concepto: concepto.present ? concepto.value : this.concepto,
    syncStatus: syncStatus ?? this.syncStatus,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AbonoData copyWithCompanion(AbonosCompanion data) {
    return AbonoData(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      ventaId: data.ventaId.present ? data.ventaId.value : this.ventaId,
      monto: data.monto.present ? data.monto.value : this.monto,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      saldoRestante: data.saldoRestante.present
          ? data.saldoRestante.value
          : this.saldoRestante,
      concepto: data.concepto.present ? data.concepto.value : this.concepto,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AbonoData(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('ventaId: $ventaId, ')
          ..write('monto: $monto, ')
          ..write('fecha: $fecha, ')
          ..write('saldoRestante: $saldoRestante, ')
          ..write('concepto: $concepto, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clienteId,
    ventaId,
    monto,
    fecha,
    saldoRestante,
    concepto,
    syncStatus,
    lastSyncedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AbonoData &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.ventaId == this.ventaId &&
          other.monto == this.monto &&
          other.fecha == this.fecha &&
          other.saldoRestante == this.saldoRestante &&
          other.concepto == this.concepto &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.updatedAt == this.updatedAt);
}

class AbonosCompanion extends UpdateCompanion<AbonoData> {
  final Value<String> id;
  final Value<String> clienteId;
  final Value<String?> ventaId;
  final Value<double> monto;
  final Value<DateTime> fecha;
  final Value<double> saldoRestante;
  final Value<String?> concepto;
  final Value<String> syncStatus;
  final Value<DateTime?> lastSyncedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AbonosCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.ventaId = const Value.absent(),
    this.monto = const Value.absent(),
    this.fecha = const Value.absent(),
    this.saldoRestante = const Value.absent(),
    this.concepto = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AbonosCompanion.insert({
    required String id,
    required String clienteId,
    this.ventaId = const Value.absent(),
    required double monto,
    required DateTime fecha,
    required double saldoRestante,
    this.concepto = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clienteId = Value(clienteId),
       monto = Value(monto),
       fecha = Value(fecha),
       saldoRestante = Value(saldoRestante);
  static Insertable<AbonoData> custom({
    Expression<String>? id,
    Expression<String>? clienteId,
    Expression<String>? ventaId,
    Expression<double>? monto,
    Expression<DateTime>? fecha,
    Expression<double>? saldoRestante,
    Expression<String>? concepto,
    Expression<String>? syncStatus,
    Expression<DateTime>? lastSyncedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (ventaId != null) 'venta_id': ventaId,
      if (monto != null) 'monto': monto,
      if (fecha != null) 'fecha': fecha,
      if (saldoRestante != null) 'saldo_restante': saldoRestante,
      if (concepto != null) 'concepto': concepto,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AbonosCompanion copyWith({
    Value<String>? id,
    Value<String>? clienteId,
    Value<String?>? ventaId,
    Value<double>? monto,
    Value<DateTime>? fecha,
    Value<double>? saldoRestante,
    Value<String?>? concepto,
    Value<String>? syncStatus,
    Value<DateTime?>? lastSyncedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AbonosCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      ventaId: ventaId ?? this.ventaId,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      saldoRestante: saldoRestante ?? this.saldoRestante,
      concepto: concepto ?? this.concepto,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<String>(clienteId.value);
    }
    if (ventaId.present) {
      map['venta_id'] = Variable<String>(ventaId.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (saldoRestante.present) {
      map['saldo_restante'] = Variable<double>(saldoRestante.value);
    }
    if (concepto.present) {
      map['concepto'] = Variable<String>(concepto.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AbonosCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('ventaId: $ventaId, ')
          ..write('monto: $monto, ')
          ..write('fecha: $fecha, ')
          ..write('saldoRestante: $saldoRestante, ')
          ..write('concepto: $concepto, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalesTable locales = $LocalesTable(this);
  late final $ClientesTable clientes = $ClientesTable(this);
  late final $ProveedoresTable proveedores = $ProveedoresTable(this);
  late final $ProductosTable productos = $ProductosTable(this);
  late final $MovimientosTable movimientos = $MovimientosTable(this);
  late final $VentasTable ventas = $VentasTable(this);
  late final $PedidosProveedorTable pedidosProveedor = $PedidosProveedorTable(
    this,
  );
  late final $LocalUsersTable localUsers = $LocalUsersTable(this);
  late final $AbonosTable abonos = $AbonosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    locales,
    clientes,
    proveedores,
    productos,
    movimientos,
    ventas,
    pedidosProveedor,
    localUsers,
    abonos,
  ];
}

typedef $$LocalesTableCreateCompanionBuilder =
    LocalesCompanion Function({
      required String id,
      required String nombre,
      Value<String?> direccion,
      Value<String?> telefono,
      Value<String> tipo,
      Value<String?> userId,
      Value<bool> isActivo,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$LocalesTableUpdateCompanionBuilder =
    LocalesCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String?> direccion,
      Value<String?> telefono,
      Value<String> tipo,
      Value<String?> userId,
      Value<bool> isActivo,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

final class $$LocalesTableReferences
    extends BaseReferences<_$AppDatabase, $LocalesTable, LocalData> {
  $$LocalesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ClientesTable, List<ClienteData>>
  _clientesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.clientes,
    aliasName: $_aliasNameGenerator(db.locales.id, db.clientes.localId),
  );

  $$ClientesTableProcessedTableManager get clientesRefs {
    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.localId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_clientesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProveedoresTable, List<ProveedorData>>
  _proveedoresRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.proveedores,
    aliasName: $_aliasNameGenerator(db.locales.id, db.proveedores.localId),
  );

  $$ProveedoresTableProcessedTableManager get proveedoresRefs {
    final manager = $$ProveedoresTableTableManager(
      $_db,
      $_db.proveedores,
    ).filter((f) => f.localId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_proveedoresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProductosTable, List<ProductoData>>
  _productosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productos,
    aliasName: $_aliasNameGenerator(db.locales.id, db.productos.localId),
  );

  $$ProductosTableProcessedTableManager get productosRefs {
    final manager = $$ProductosTableTableManager(
      $_db,
      $_db.productos,
    ).filter((f) => f.localId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_productosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MovimientosTable, List<MovimientoData>>
  _movimientosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movimientos,
    aliasName: $_aliasNameGenerator(db.locales.id, db.movimientos.localId),
  );

  $$MovimientosTableProcessedTableManager get movimientosRefs {
    final manager = $$MovimientosTableTableManager(
      $_db,
      $_db.movimientos,
    ).filter((f) => f.localId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_movimientosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VentasTable, List<VentaData>> _ventasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ventas,
    aliasName: $_aliasNameGenerator(db.locales.id, db.ventas.localId),
  );

  $$VentasTableProcessedTableManager get ventasRefs {
    final manager = $$VentasTableTableManager(
      $_db,
      $_db.ventas,
    ).filter((f) => f.localId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ventasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PedidosProveedorTable, List<PedidoProveedorData>>
  _pedidosProveedorRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pedidosProveedor,
    aliasName: $_aliasNameGenerator(db.locales.id, db.pedidosProveedor.localId),
  );

  $$PedidosProveedorTableProcessedTableManager get pedidosProveedorRefs {
    final manager = $$PedidosProveedorTableTableManager(
      $_db,
      $_db.pedidosProveedor,
    ).filter((f) => f.localId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _pedidosProveedorRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocalesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalesTable> {
  $$LocalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActivo => $composableBuilder(
    column: $table.isActivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> clientesRefs(
    Expression<bool> Function($$ClientesTableFilterComposer f) f,
  ) {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> proveedoresRefs(
    Expression<bool> Function($$ProveedoresTableFilterComposer f) f,
  ) {
    final $$ProveedoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableFilterComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> productosRefs(
    Expression<bool> Function($$ProductosTableFilterComposer f) f,
  ) {
    final $$ProductosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableFilterComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> movimientosRefs(
    Expression<bool> Function($$MovimientosTableFilterComposer f) f,
  ) {
    final $$MovimientosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableFilterComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ventasRefs(
    Expression<bool> Function($$VentasTableFilterComposer f) f,
  ) {
    final $$VentasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableFilterComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pedidosProveedorRefs(
    Expression<bool> Function($$PedidosProveedorTableFilterComposer f) f,
  ) {
    final $$PedidosProveedorTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pedidosProveedor,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PedidosProveedorTableFilterComposer(
            $db: $db,
            $table: $db.pedidosProveedor,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocalesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalesTable> {
  $$LocalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActivo => $composableBuilder(
    column: $table.isActivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalesTable> {
  $$LocalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<bool> get isActivo =>
      $composableBuilder(column: $table.isActivo, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> clientesRefs<T extends Object>(
    Expression<T> Function($$ClientesTableAnnotationComposer a) f,
  ) {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> proveedoresRefs<T extends Object>(
    Expression<T> Function($$ProveedoresTableAnnotationComposer a) f,
  ) {
    final $$ProveedoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableAnnotationComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> productosRefs<T extends Object>(
    Expression<T> Function($$ProductosTableAnnotationComposer a) f,
  ) {
    final $$ProductosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableAnnotationComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> movimientosRefs<T extends Object>(
    Expression<T> Function($$MovimientosTableAnnotationComposer a) f,
  ) {
    final $$MovimientosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableAnnotationComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ventasRefs<T extends Object>(
    Expression<T> Function($$VentasTableAnnotationComposer a) f,
  ) {
    final $$VentasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableAnnotationComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pedidosProveedorRefs<T extends Object>(
    Expression<T> Function($$PedidosProveedorTableAnnotationComposer a) f,
  ) {
    final $$PedidosProveedorTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pedidosProveedor,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PedidosProveedorTableAnnotationComposer(
            $db: $db,
            $table: $db.pedidosProveedor,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalesTable,
          LocalData,
          $$LocalesTableFilterComposer,
          $$LocalesTableOrderingComposer,
          $$LocalesTableAnnotationComposer,
          $$LocalesTableCreateCompanionBuilder,
          $$LocalesTableUpdateCompanionBuilder,
          (LocalData, $$LocalesTableReferences),
          LocalData,
          PrefetchHooks Function({
            bool clientesRefs,
            bool proveedoresRefs,
            bool productosRefs,
            bool movimientosRefs,
            bool ventasRefs,
            bool pedidosProveedorRefs,
          })
        > {
  $$LocalesTableTableManager(_$AppDatabase db, $LocalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> direccion = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<bool> isActivo = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalesCompanion(
                id: id,
                nombre: nombre,
                direccion: direccion,
                telefono: telefono,
                tipo: tipo,
                userId: userId,
                isActivo: isActivo,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                Value<String?> direccion = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<bool> isActivo = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalesCompanion.insert(
                id: id,
                nombre: nombre,
                direccion: direccion,
                telefono: telefono,
                tipo: tipo,
                userId: userId,
                isActivo: isActivo,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LocalesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                clientesRefs = false,
                proveedoresRefs = false,
                productosRefs = false,
                movimientosRefs = false,
                ventasRefs = false,
                pedidosProveedorRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (clientesRefs) db.clientes,
                    if (proveedoresRefs) db.proveedores,
                    if (productosRefs) db.productos,
                    if (movimientosRefs) db.movimientos,
                    if (ventasRefs) db.ventas,
                    if (pedidosProveedorRefs) db.pedidosProveedor,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (clientesRefs)
                        await $_getPrefetchedData<
                          LocalData,
                          $LocalesTable,
                          ClienteData
                        >(
                          currentTable: table,
                          referencedTable: $$LocalesTableReferences
                              ._clientesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalesTableReferences(
                                db,
                                table,
                                p0,
                              ).clientesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.localId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (proveedoresRefs)
                        await $_getPrefetchedData<
                          LocalData,
                          $LocalesTable,
                          ProveedorData
                        >(
                          currentTable: table,
                          referencedTable: $$LocalesTableReferences
                              ._proveedoresRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalesTableReferences(
                                db,
                                table,
                                p0,
                              ).proveedoresRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.localId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (productosRefs)
                        await $_getPrefetchedData<
                          LocalData,
                          $LocalesTable,
                          ProductoData
                        >(
                          currentTable: table,
                          referencedTable: $$LocalesTableReferences
                              ._productosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalesTableReferences(
                                db,
                                table,
                                p0,
                              ).productosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.localId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (movimientosRefs)
                        await $_getPrefetchedData<
                          LocalData,
                          $LocalesTable,
                          MovimientoData
                        >(
                          currentTable: table,
                          referencedTable: $$LocalesTableReferences
                              ._movimientosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalesTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.localId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ventasRefs)
                        await $_getPrefetchedData<
                          LocalData,
                          $LocalesTable,
                          VentaData
                        >(
                          currentTable: table,
                          referencedTable: $$LocalesTableReferences
                              ._ventasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalesTableReferences(
                                db,
                                table,
                                p0,
                              ).ventasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.localId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pedidosProveedorRefs)
                        await $_getPrefetchedData<
                          LocalData,
                          $LocalesTable,
                          PedidoProveedorData
                        >(
                          currentTable: table,
                          referencedTable: $$LocalesTableReferences
                              ._pedidosProveedorRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalesTableReferences(
                                db,
                                table,
                                p0,
                              ).pedidosProveedorRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.localId == item.id,
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

typedef $$LocalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalesTable,
      LocalData,
      $$LocalesTableFilterComposer,
      $$LocalesTableOrderingComposer,
      $$LocalesTableAnnotationComposer,
      $$LocalesTableCreateCompanionBuilder,
      $$LocalesTableUpdateCompanionBuilder,
      (LocalData, $$LocalesTableReferences),
      LocalData,
      PrefetchHooks Function({
        bool clientesRefs,
        bool proveedoresRefs,
        bool productosRefs,
        bool movimientosRefs,
        bool ventasRefs,
        bool pedidosProveedorRefs,
      })
    >;
typedef $$ClientesTableCreateCompanionBuilder =
    ClientesCompanion Function({
      required String id,
      required String nombre,
      required String telefono,
      Value<String?> email,
      Value<String?> localId,
      Value<bool> esFiado,
      Value<double> saldoPendiente,
      Value<bool> isActivo,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime?> updatedAt,
      Value<double?> limiteCredito,
      Value<DateTime?> promesaPago,
      Value<int> rowid,
    });
typedef $$ClientesTableUpdateCompanionBuilder =
    ClientesCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> telefono,
      Value<String?> email,
      Value<String?> localId,
      Value<bool> esFiado,
      Value<double> saldoPendiente,
      Value<bool> isActivo,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime?> updatedAt,
      Value<double?> limiteCredito,
      Value<DateTime?> promesaPago,
      Value<int> rowid,
    });

final class $$ClientesTableReferences
    extends BaseReferences<_$AppDatabase, $ClientesTable, ClienteData> {
  $$ClientesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LocalesTable _localIdTable(_$AppDatabase db) => db.locales
      .createAlias($_aliasNameGenerator(db.clientes.localId, db.locales.id));

  $$LocalesTableProcessedTableManager? get localId {
    final $_column = $_itemColumn<String>('local_id');
    if ($_column == null) return null;
    final manager = $$LocalesTableTableManager(
      $_db,
      $_db.locales,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_localIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MovimientosTable, List<MovimientoData>>
  _movimientosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movimientos,
    aliasName: $_aliasNameGenerator(db.clientes.id, db.movimientos.clienteId),
  );

  $$MovimientosTableProcessedTableManager get movimientosRefs {
    final manager = $$MovimientosTableTableManager(
      $_db,
      $_db.movimientos,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_movimientosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VentasTable, List<VentaData>> _ventasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ventas,
    aliasName: $_aliasNameGenerator(db.clientes.id, db.ventas.clienteId),
  );

  $$VentasTableProcessedTableManager get ventasRefs {
    final manager = $$VentasTableTableManager(
      $_db,
      $_db.ventas,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ventasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AbonosTable, List<AbonoData>> _abonosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.abonos,
    aliasName: $_aliasNameGenerator(db.clientes.id, db.abonos.clienteId),
  );

  $$AbonosTableProcessedTableManager get abonosRefs {
    final manager = $$AbonosTableTableManager(
      $_db,
      $_db.abonos,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_abonosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClientesTableFilterComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esFiado => $composableBuilder(
    column: $table.esFiado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saldoPendiente => $composableBuilder(
    column: $table.saldoPendiente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActivo => $composableBuilder(
    column: $table.isActivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get limiteCredito => $composableBuilder(
    column: $table.limiteCredito,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get promesaPago => $composableBuilder(
    column: $table.promesaPago,
    builder: (column) => ColumnFilters(column),
  );

  $$LocalesTableFilterComposer get localId {
    final $$LocalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalesTableFilterComposer(
            $db: $db,
            $table: $db.locales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> movimientosRefs(
    Expression<bool> Function($$MovimientosTableFilterComposer f) f,
  ) {
    final $$MovimientosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableFilterComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ventasRefs(
    Expression<bool> Function($$VentasTableFilterComposer f) f,
  ) {
    final $$VentasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableFilterComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> abonosRefs(
    Expression<bool> Function($$AbonosTableFilterComposer f) f,
  ) {
    final $$AbonosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.abonos,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AbonosTableFilterComposer(
            $db: $db,
            $table: $db.abonos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esFiado => $composableBuilder(
    column: $table.esFiado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saldoPendiente => $composableBuilder(
    column: $table.saldoPendiente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActivo => $composableBuilder(
    column: $table.isActivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get limiteCredito => $composableBuilder(
    column: $table.limiteCredito,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get promesaPago => $composableBuilder(
    column: $table.promesaPago,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocalesTableOrderingComposer get localId {
    final $$LocalesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalesTableOrderingComposer(
            $db: $db,
            $table: $db.locales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<bool> get esFiado =>
      $composableBuilder(column: $table.esFiado, builder: (column) => column);

  GeneratedColumn<double> get saldoPendiente => $composableBuilder(
    column: $table.saldoPendiente,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActivo =>
      $composableBuilder(column: $table.isActivo, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<double> get limiteCredito => $composableBuilder(
    column: $table.limiteCredito,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get promesaPago => $composableBuilder(
    column: $table.promesaPago,
    builder: (column) => column,
  );

  $$LocalesTableAnnotationComposer get localId {
    final $$LocalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalesTableAnnotationComposer(
            $db: $db,
            $table: $db.locales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> movimientosRefs<T extends Object>(
    Expression<T> Function($$MovimientosTableAnnotationComposer a) f,
  ) {
    final $$MovimientosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableAnnotationComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ventasRefs<T extends Object>(
    Expression<T> Function($$VentasTableAnnotationComposer a) f,
  ) {
    final $$VentasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableAnnotationComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> abonosRefs<T extends Object>(
    Expression<T> Function($$AbonosTableAnnotationComposer a) f,
  ) {
    final $$AbonosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.abonos,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AbonosTableAnnotationComposer(
            $db: $db,
            $table: $db.abonos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientesTable,
          ClienteData,
          $$ClientesTableFilterComposer,
          $$ClientesTableOrderingComposer,
          $$ClientesTableAnnotationComposer,
          $$ClientesTableCreateCompanionBuilder,
          $$ClientesTableUpdateCompanionBuilder,
          (ClienteData, $$ClientesTableReferences),
          ClienteData,
          PrefetchHooks Function({
            bool localId,
            bool movimientosRefs,
            bool ventasRefs,
            bool abonosRefs,
          })
        > {
  $$ClientesTableTableManager(_$AppDatabase db, $ClientesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> localId = const Value.absent(),
                Value<bool> esFiado = const Value.absent(),
                Value<double> saldoPendiente = const Value.absent(),
                Value<bool> isActivo = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<double?> limiteCredito = const Value.absent(),
                Value<DateTime?> promesaPago = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientesCompanion(
                id: id,
                nombre: nombre,
                telefono: telefono,
                email: email,
                localId: localId,
                esFiado: esFiado,
                saldoPendiente: saldoPendiente,
                isActivo: isActivo,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                updatedAt: updatedAt,
                limiteCredito: limiteCredito,
                promesaPago: promesaPago,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required String telefono,
                Value<String?> email = const Value.absent(),
                Value<String?> localId = const Value.absent(),
                Value<bool> esFiado = const Value.absent(),
                Value<double> saldoPendiente = const Value.absent(),
                Value<bool> isActivo = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<double?> limiteCredito = const Value.absent(),
                Value<DateTime?> promesaPago = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientesCompanion.insert(
                id: id,
                nombre: nombre,
                telefono: telefono,
                email: email,
                localId: localId,
                esFiado: esFiado,
                saldoPendiente: saldoPendiente,
                isActivo: isActivo,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                updatedAt: updatedAt,
                limiteCredito: limiteCredito,
                promesaPago: promesaPago,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClientesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                localId = false,
                movimientosRefs = false,
                ventasRefs = false,
                abonosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (movimientosRefs) db.movimientos,
                    if (ventasRefs) db.ventas,
                    if (abonosRefs) db.abonos,
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
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.localId,
                                    referencedTable: $$ClientesTableReferences
                                        ._localIdTable(db),
                                    referencedColumn: $$ClientesTableReferences
                                        ._localIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (movimientosRefs)
                        await $_getPrefetchedData<
                          ClienteData,
                          $ClientesTable,
                          MovimientoData
                        >(
                          currentTable: table,
                          referencedTable: $$ClientesTableReferences
                              ._movimientosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientesTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ventasRefs)
                        await $_getPrefetchedData<
                          ClienteData,
                          $ClientesTable,
                          VentaData
                        >(
                          currentTable: table,
                          referencedTable: $$ClientesTableReferences
                              ._ventasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientesTableReferences(
                                db,
                                table,
                                p0,
                              ).ventasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (abonosRefs)
                        await $_getPrefetchedData<
                          ClienteData,
                          $ClientesTable,
                          AbonoData
                        >(
                          currentTable: table,
                          referencedTable: $$ClientesTableReferences
                              ._abonosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientesTableReferences(
                                db,
                                table,
                                p0,
                              ).abonosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clienteId == item.id,
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

typedef $$ClientesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientesTable,
      ClienteData,
      $$ClientesTableFilterComposer,
      $$ClientesTableOrderingComposer,
      $$ClientesTableAnnotationComposer,
      $$ClientesTableCreateCompanionBuilder,
      $$ClientesTableUpdateCompanionBuilder,
      (ClienteData, $$ClientesTableReferences),
      ClienteData,
      PrefetchHooks Function({
        bool localId,
        bool movimientosRefs,
        bool ventasRefs,
        bool abonosRefs,
      })
    >;
typedef $$ProveedoresTableCreateCompanionBuilder =
    ProveedoresCompanion Function({
      required String id,
      required String nombre,
      required String telefono,
      required List<String> diasVisita,
      Value<int?> periodoVisita,
      Value<DateTime?> ultimaVisita,
      Value<DateTime?> proximaVisita,
      Value<String?> localId,
      Value<bool> isActivo,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });
typedef $$ProveedoresTableUpdateCompanionBuilder =
    ProveedoresCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> telefono,
      Value<List<String>> diasVisita,
      Value<int?> periodoVisita,
      Value<DateTime?> ultimaVisita,
      Value<DateTime?> proximaVisita,
      Value<String?> localId,
      Value<bool> isActivo,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });

final class $$ProveedoresTableReferences
    extends BaseReferences<_$AppDatabase, $ProveedoresTable, ProveedorData> {
  $$ProveedoresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LocalesTable _localIdTable(_$AppDatabase db) => db.locales
      .createAlias($_aliasNameGenerator(db.proveedores.localId, db.locales.id));

  $$LocalesTableProcessedTableManager? get localId {
    final $_column = $_itemColumn<String>('local_id');
    if ($_column == null) return null;
    final manager = $$LocalesTableTableManager(
      $_db,
      $_db.locales,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_localIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ProductosTable, List<ProductoData>>
  _productosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productos,
    aliasName: $_aliasNameGenerator(
      db.proveedores.id,
      db.productos.proveedorId,
    ),
  );

  $$ProductosTableProcessedTableManager get productosRefs {
    final manager = $$ProductosTableTableManager(
      $_db,
      $_db.productos,
    ).filter((f) => f.proveedorId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_productosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MovimientosTable, List<MovimientoData>>
  _movimientosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movimientos,
    aliasName: $_aliasNameGenerator(
      db.proveedores.id,
      db.movimientos.proveedorId,
    ),
  );

  $$MovimientosTableProcessedTableManager get movimientosRefs {
    final manager = $$MovimientosTableTableManager(
      $_db,
      $_db.movimientos,
    ).filter((f) => f.proveedorId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_movimientosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PedidosProveedorTable, List<PedidoProveedorData>>
  _pedidosProveedorRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pedidosProveedor,
    aliasName: $_aliasNameGenerator(
      db.proveedores.id,
      db.pedidosProveedor.proveedorId,
    ),
  );

  $$PedidosProveedorTableProcessedTableManager get pedidosProveedorRefs {
    final manager = $$PedidosProveedorTableTableManager(
      $_db,
      $_db.pedidosProveedor,
    ).filter((f) => f.proveedorId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _pedidosProveedorRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProveedoresTableFilterComposer
    extends Composer<_$AppDatabase, $ProveedoresTable> {
  $$ProveedoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get diasVisita => $composableBuilder(
    column: $table.diasVisita,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get periodoVisita => $composableBuilder(
    column: $table.periodoVisita,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ultimaVisita => $composableBuilder(
    column: $table.ultimaVisita,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get proximaVisita => $composableBuilder(
    column: $table.proximaVisita,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActivo => $composableBuilder(
    column: $table.isActivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LocalesTableFilterComposer get localId {
    final $$LocalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalesTableFilterComposer(
            $db: $db,
            $table: $db.locales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> productosRefs(
    Expression<bool> Function($$ProductosTableFilterComposer f) f,
  ) {
    final $$ProductosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.proveedorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableFilterComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> movimientosRefs(
    Expression<bool> Function($$MovimientosTableFilterComposer f) f,
  ) {
    final $$MovimientosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.proveedorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableFilterComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pedidosProveedorRefs(
    Expression<bool> Function($$PedidosProveedorTableFilterComposer f) f,
  ) {
    final $$PedidosProveedorTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pedidosProveedor,
      getReferencedColumn: (t) => t.proveedorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PedidosProveedorTableFilterComposer(
            $db: $db,
            $table: $db.pedidosProveedor,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProveedoresTableOrderingComposer
    extends Composer<_$AppDatabase, $ProveedoresTable> {
  $$ProveedoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diasVisita => $composableBuilder(
    column: $table.diasVisita,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get periodoVisita => $composableBuilder(
    column: $table.periodoVisita,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ultimaVisita => $composableBuilder(
    column: $table.ultimaVisita,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get proximaVisita => $composableBuilder(
    column: $table.proximaVisita,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActivo => $composableBuilder(
    column: $table.isActivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocalesTableOrderingComposer get localId {
    final $$LocalesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalesTableOrderingComposer(
            $db: $db,
            $table: $db.locales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProveedoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProveedoresTable> {
  $$ProveedoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get diasVisita =>
      $composableBuilder(
        column: $table.diasVisita,
        builder: (column) => column,
      );

  GeneratedColumn<int> get periodoVisita => $composableBuilder(
    column: $table.periodoVisita,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get ultimaVisita => $composableBuilder(
    column: $table.ultimaVisita,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get proximaVisita => $composableBuilder(
    column: $table.proximaVisita,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActivo =>
      $composableBuilder(column: $table.isActivo, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  $$LocalesTableAnnotationComposer get localId {
    final $$LocalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalesTableAnnotationComposer(
            $db: $db,
            $table: $db.locales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> productosRefs<T extends Object>(
    Expression<T> Function($$ProductosTableAnnotationComposer a) f,
  ) {
    final $$ProductosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.proveedorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableAnnotationComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> movimientosRefs<T extends Object>(
    Expression<T> Function($$MovimientosTableAnnotationComposer a) f,
  ) {
    final $$MovimientosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.proveedorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableAnnotationComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pedidosProveedorRefs<T extends Object>(
    Expression<T> Function($$PedidosProveedorTableAnnotationComposer a) f,
  ) {
    final $$PedidosProveedorTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pedidosProveedor,
      getReferencedColumn: (t) => t.proveedorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PedidosProveedorTableAnnotationComposer(
            $db: $db,
            $table: $db.pedidosProveedor,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProveedoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProveedoresTable,
          ProveedorData,
          $$ProveedoresTableFilterComposer,
          $$ProveedoresTableOrderingComposer,
          $$ProveedoresTableAnnotationComposer,
          $$ProveedoresTableCreateCompanionBuilder,
          $$ProveedoresTableUpdateCompanionBuilder,
          (ProveedorData, $$ProveedoresTableReferences),
          ProveedorData,
          PrefetchHooks Function({
            bool localId,
            bool productosRefs,
            bool movimientosRefs,
            bool pedidosProveedorRefs,
          })
        > {
  $$ProveedoresTableTableManager(_$AppDatabase db, $ProveedoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProveedoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProveedoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProveedoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<List<String>> diasVisita = const Value.absent(),
                Value<int?> periodoVisita = const Value.absent(),
                Value<DateTime?> ultimaVisita = const Value.absent(),
                Value<DateTime?> proximaVisita = const Value.absent(),
                Value<String?> localId = const Value.absent(),
                Value<bool> isActivo = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProveedoresCompanion(
                id: id,
                nombre: nombre,
                telefono: telefono,
                diasVisita: diasVisita,
                periodoVisita: periodoVisita,
                ultimaVisita: ultimaVisita,
                proximaVisita: proximaVisita,
                localId: localId,
                isActivo: isActivo,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required String telefono,
                required List<String> diasVisita,
                Value<int?> periodoVisita = const Value.absent(),
                Value<DateTime?> ultimaVisita = const Value.absent(),
                Value<DateTime?> proximaVisita = const Value.absent(),
                Value<String?> localId = const Value.absent(),
                Value<bool> isActivo = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProveedoresCompanion.insert(
                id: id,
                nombre: nombre,
                telefono: telefono,
                diasVisita: diasVisita,
                periodoVisita: periodoVisita,
                ultimaVisita: ultimaVisita,
                proximaVisita: proximaVisita,
                localId: localId,
                isActivo: isActivo,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProveedoresTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                localId = false,
                productosRefs = false,
                movimientosRefs = false,
                pedidosProveedorRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (productosRefs) db.productos,
                    if (movimientosRefs) db.movimientos,
                    if (pedidosProveedorRefs) db.pedidosProveedor,
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
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.localId,
                                    referencedTable:
                                        $$ProveedoresTableReferences
                                            ._localIdTable(db),
                                    referencedColumn:
                                        $$ProveedoresTableReferences
                                            ._localIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (productosRefs)
                        await $_getPrefetchedData<
                          ProveedorData,
                          $ProveedoresTable,
                          ProductoData
                        >(
                          currentTable: table,
                          referencedTable: $$ProveedoresTableReferences
                              ._productosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProveedoresTableReferences(
                                db,
                                table,
                                p0,
                              ).productosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.proveedorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (movimientosRefs)
                        await $_getPrefetchedData<
                          ProveedorData,
                          $ProveedoresTable,
                          MovimientoData
                        >(
                          currentTable: table,
                          referencedTable: $$ProveedoresTableReferences
                              ._movimientosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProveedoresTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.proveedorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pedidosProveedorRefs)
                        await $_getPrefetchedData<
                          ProveedorData,
                          $ProveedoresTable,
                          PedidoProveedorData
                        >(
                          currentTable: table,
                          referencedTable: $$ProveedoresTableReferences
                              ._pedidosProveedorRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProveedoresTableReferences(
                                db,
                                table,
                                p0,
                              ).pedidosProveedorRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.proveedorId == item.id,
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

typedef $$ProveedoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProveedoresTable,
      ProveedorData,
      $$ProveedoresTableFilterComposer,
      $$ProveedoresTableOrderingComposer,
      $$ProveedoresTableAnnotationComposer,
      $$ProveedoresTableCreateCompanionBuilder,
      $$ProveedoresTableUpdateCompanionBuilder,
      (ProveedorData, $$ProveedoresTableReferences),
      ProveedorData,
      PrefetchHooks Function({
        bool localId,
        bool productosRefs,
        bool movimientosRefs,
        bool pedidosProveedorRefs,
      })
    >;
typedef $$ProductosTableCreateCompanionBuilder =
    ProductosCompanion Function({
      required String id,
      required String nombre,
      required int cantidad,
      required double precio,
      Value<double?> precioCompra,
      Value<int> unidadesPorPaquete,
      Value<bool> esPaquete,
      required String categoria,
      required String proveedorId,
      Value<String?> localId,
      Value<int> stockMinimo,
      Value<String?> codigoBarras,
      Value<String?> codigoPersonalizado,
      Value<String?> proveedorNombre,
      Value<bool> isActivo,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime?> updatedAt,
      Value<String> unidad,
      Value<int> rowid,
    });
typedef $$ProductosTableUpdateCompanionBuilder =
    ProductosCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<int> cantidad,
      Value<double> precio,
      Value<double?> precioCompra,
      Value<int> unidadesPorPaquete,
      Value<bool> esPaquete,
      Value<String> categoria,
      Value<String> proveedorId,
      Value<String?> localId,
      Value<int> stockMinimo,
      Value<String?> codigoBarras,
      Value<String?> codigoPersonalizado,
      Value<String?> proveedorNombre,
      Value<bool> isActivo,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime?> updatedAt,
      Value<String> unidad,
      Value<int> rowid,
    });

final class $$ProductosTableReferences
    extends BaseReferences<_$AppDatabase, $ProductosTable, ProductoData> {
  $$ProductosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProveedoresTable _proveedorIdTable(_$AppDatabase db) =>
      db.proveedores.createAlias(
        $_aliasNameGenerator(db.productos.proveedorId, db.proveedores.id),
      );

  $$ProveedoresTableProcessedTableManager get proveedorId {
    final $_column = $_itemColumn<String>('proveedor_id')!;

    final manager = $$ProveedoresTableTableManager(
      $_db,
      $_db.proveedores,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_proveedorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocalesTable _localIdTable(_$AppDatabase db) => db.locales
      .createAlias($_aliasNameGenerator(db.productos.localId, db.locales.id));

  $$LocalesTableProcessedTableManager? get localId {
    final $_column = $_itemColumn<String>('local_id');
    if ($_column == null) return null;
    final manager = $$LocalesTableTableManager(
      $_db,
      $_db.locales,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_localIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MovimientosTable, List<MovimientoData>>
  _movimientosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movimientos,
    aliasName: $_aliasNameGenerator(db.productos.id, db.movimientos.productoId),
  );

  $$MovimientosTableProcessedTableManager get movimientosRefs {
    final manager = $$MovimientosTableTableManager(
      $_db,
      $_db.movimientos,
    ).filter((f) => f.productoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_movimientosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductosTableFilterComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioCompra => $composableBuilder(
    column: $table.precioCompra,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unidadesPorPaquete => $composableBuilder(
    column: $table.unidadesPorPaquete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esPaquete => $composableBuilder(
    column: $table.esPaquete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stockMinimo => $composableBuilder(
    column: $table.stockMinimo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigoBarras => $composableBuilder(
    column: $table.codigoBarras,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigoPersonalizado => $composableBuilder(
    column: $table.codigoPersonalizado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proveedorNombre => $composableBuilder(
    column: $table.proveedorNombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActivo => $composableBuilder(
    column: $table.isActivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unidad => $composableBuilder(
    column: $table.unidad,
    builder: (column) => ColumnFilters(column),
  );

  $$ProveedoresTableFilterComposer get proveedorId {
    final $$ProveedoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorId,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableFilterComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalesTableFilterComposer get localId {
    final $$LocalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalesTableFilterComposer(
            $db: $db,
            $table: $db.locales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> movimientosRefs(
    Expression<bool> Function($$MovimientosTableFilterComposer f) f,
  ) {
    final $$MovimientosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableFilterComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioCompra => $composableBuilder(
    column: $table.precioCompra,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unidadesPorPaquete => $composableBuilder(
    column: $table.unidadesPorPaquete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esPaquete => $composableBuilder(
    column: $table.esPaquete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stockMinimo => $composableBuilder(
    column: $table.stockMinimo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoBarras => $composableBuilder(
    column: $table.codigoBarras,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoPersonalizado => $composableBuilder(
    column: $table.codigoPersonalizado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proveedorNombre => $composableBuilder(
    column: $table.proveedorNombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActivo => $composableBuilder(
    column: $table.isActivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unidad => $composableBuilder(
    column: $table.unidad,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProveedoresTableOrderingComposer get proveedorId {
    final $$ProveedoresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorId,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableOrderingComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalesTableOrderingComposer get localId {
    final $$LocalesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalesTableOrderingComposer(
            $db: $db,
            $table: $db.locales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get precio =>
      $composableBuilder(column: $table.precio, builder: (column) => column);

  GeneratedColumn<double> get precioCompra => $composableBuilder(
    column: $table.precioCompra,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unidadesPorPaquete => $composableBuilder(
    column: $table.unidadesPorPaquete,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get esPaquete =>
      $composableBuilder(column: $table.esPaquete, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<int> get stockMinimo => $composableBuilder(
    column: $table.stockMinimo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get codigoBarras => $composableBuilder(
    column: $table.codigoBarras,
    builder: (column) => column,
  );

  GeneratedColumn<String> get codigoPersonalizado => $composableBuilder(
    column: $table.codigoPersonalizado,
    builder: (column) => column,
  );

  GeneratedColumn<String> get proveedorNombre => $composableBuilder(
    column: $table.proveedorNombre,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActivo =>
      $composableBuilder(column: $table.isActivo, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get unidad =>
      $composableBuilder(column: $table.unidad, builder: (column) => column);

  $$ProveedoresTableAnnotationComposer get proveedorId {
    final $$ProveedoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorId,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableAnnotationComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalesTableAnnotationComposer get localId {
    final $$LocalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalesTableAnnotationComposer(
            $db: $db,
            $table: $db.locales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> movimientosRefs<T extends Object>(
    Expression<T> Function($$MovimientosTableAnnotationComposer a) f,
  ) {
    final $$MovimientosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableAnnotationComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductosTable,
          ProductoData,
          $$ProductosTableFilterComposer,
          $$ProductosTableOrderingComposer,
          $$ProductosTableAnnotationComposer,
          $$ProductosTableCreateCompanionBuilder,
          $$ProductosTableUpdateCompanionBuilder,
          (ProductoData, $$ProductosTableReferences),
          ProductoData,
          PrefetchHooks Function({
            bool proveedorId,
            bool localId,
            bool movimientosRefs,
          })
        > {
  $$ProductosTableTableManager(_$AppDatabase db, $ProductosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<double> precio = const Value.absent(),
                Value<double?> precioCompra = const Value.absent(),
                Value<int> unidadesPorPaquete = const Value.absent(),
                Value<bool> esPaquete = const Value.absent(),
                Value<String> categoria = const Value.absent(),
                Value<String> proveedorId = const Value.absent(),
                Value<String?> localId = const Value.absent(),
                Value<int> stockMinimo = const Value.absent(),
                Value<String?> codigoBarras = const Value.absent(),
                Value<String?> codigoPersonalizado = const Value.absent(),
                Value<String?> proveedorNombre = const Value.absent(),
                Value<bool> isActivo = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<String> unidad = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductosCompanion(
                id: id,
                nombre: nombre,
                cantidad: cantidad,
                precio: precio,
                precioCompra: precioCompra,
                unidadesPorPaquete: unidadesPorPaquete,
                esPaquete: esPaquete,
                categoria: categoria,
                proveedorId: proveedorId,
                localId: localId,
                stockMinimo: stockMinimo,
                codigoBarras: codigoBarras,
                codigoPersonalizado: codigoPersonalizado,
                proveedorNombre: proveedorNombre,
                isActivo: isActivo,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                updatedAt: updatedAt,
                unidad: unidad,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required int cantidad,
                required double precio,
                Value<double?> precioCompra = const Value.absent(),
                Value<int> unidadesPorPaquete = const Value.absent(),
                Value<bool> esPaquete = const Value.absent(),
                required String categoria,
                required String proveedorId,
                Value<String?> localId = const Value.absent(),
                Value<int> stockMinimo = const Value.absent(),
                Value<String?> codigoBarras = const Value.absent(),
                Value<String?> codigoPersonalizado = const Value.absent(),
                Value<String?> proveedorNombre = const Value.absent(),
                Value<bool> isActivo = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<String> unidad = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductosCompanion.insert(
                id: id,
                nombre: nombre,
                cantidad: cantidad,
                precio: precio,
                precioCompra: precioCompra,
                unidadesPorPaquete: unidadesPorPaquete,
                esPaquete: esPaquete,
                categoria: categoria,
                proveedorId: proveedorId,
                localId: localId,
                stockMinimo: stockMinimo,
                codigoBarras: codigoBarras,
                codigoPersonalizado: codigoPersonalizado,
                proveedorNombre: proveedorNombre,
                isActivo: isActivo,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                updatedAt: updatedAt,
                unidad: unidad,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                proveedorId = false,
                localId = false,
                movimientosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (movimientosRefs) db.movimientos,
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
                        if (proveedorId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.proveedorId,
                                    referencedTable: $$ProductosTableReferences
                                        ._proveedorIdTable(db),
                                    referencedColumn: $$ProductosTableReferences
                                        ._proveedorIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (localId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.localId,
                                    referencedTable: $$ProductosTableReferences
                                        ._localIdTable(db),
                                    referencedColumn: $$ProductosTableReferences
                                        ._localIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (movimientosRefs)
                        await $_getPrefetchedData<
                          ProductoData,
                          $ProductosTable,
                          MovimientoData
                        >(
                          currentTable: table,
                          referencedTable: $$ProductosTableReferences
                              ._movimientosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductosTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productoId == item.id,
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

typedef $$ProductosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductosTable,
      ProductoData,
      $$ProductosTableFilterComposer,
      $$ProductosTableOrderingComposer,
      $$ProductosTableAnnotationComposer,
      $$ProductosTableCreateCompanionBuilder,
      $$ProductosTableUpdateCompanionBuilder,
      (ProductoData, $$ProductosTableReferences),
      ProductoData,
      PrefetchHooks Function({
        bool proveedorId,
        bool localId,
        bool movimientosRefs,
      })
    >;
typedef $$MovimientosTableCreateCompanionBuilder =
    MovimientosCompanion Function({
      required String id,
      required double monto,
      required DateTime fecha,
      required MovimientoType tipo,
      required String concepto,
      Value<String?> categoria,
      Value<String?> productoId,
      Value<String?> clienteId,
      Value<String?> proveedorId,
      Value<String?> localId,
      Value<int?> cantidad,
      Value<bool> esFiado,
      Value<String?> productosJson,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$MovimientosTableUpdateCompanionBuilder =
    MovimientosCompanion Function({
      Value<String> id,
      Value<double> monto,
      Value<DateTime> fecha,
      Value<MovimientoType> tipo,
      Value<String> concepto,
      Value<String?> categoria,
      Value<String?> productoId,
      Value<String?> clienteId,
      Value<String?> proveedorId,
      Value<String?> localId,
      Value<int?> cantidad,
      Value<bool> esFiado,
      Value<String?> productosJson,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

final class $$MovimientosTableReferences
    extends BaseReferences<_$AppDatabase, $MovimientosTable, MovimientoData> {
  $$MovimientosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductosTable _productoIdTable(_$AppDatabase db) =>
      db.productos.createAlias(
        $_aliasNameGenerator(db.movimientos.productoId, db.productos.id),
      );

  $$ProductosTableProcessedTableManager? get productoId {
    final $_column = $_itemColumn<String>('producto_id');
    if ($_column == null) return null;
    final manager = $$ProductosTableTableManager(
      $_db,
      $_db.productos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ClientesTable _clienteIdTable(_$AppDatabase db) =>
      db.clientes.createAlias(
        $_aliasNameGenerator(db.movimientos.clienteId, db.clientes.id),
      );

  $$ClientesTableProcessedTableManager? get clienteId {
    final $_column = $_itemColumn<String>('cliente_id');
    if ($_column == null) return null;
    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProveedoresTable _proveedorIdTable(_$AppDatabase db) =>
      db.proveedores.createAlias(
        $_aliasNameGenerator(db.movimientos.proveedorId, db.proveedores.id),
      );

  $$ProveedoresTableProcessedTableManager? get proveedorId {
    final $_column = $_itemColumn<String>('proveedor_id');
    if ($_column == null) return null;
    final manager = $$ProveedoresTableTableManager(
      $_db,
      $_db.proveedores,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_proveedorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocalesTable _localIdTable(_$AppDatabase db) => db.locales
      .createAlias($_aliasNameGenerator(db.movimientos.localId, db.locales.id));

  $$LocalesTableProcessedTableManager? get localId {
    final $_column = $_itemColumn<String>('local_id');
    if ($_column == null) return null;
    final manager = $$LocalesTableTableManager(
      $_db,
      $_db.locales,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_localIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MovimientosTableFilterComposer
    extends Composer<_$AppDatabase, $MovimientosTable> {
  $$MovimientosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MovimientoType, MovimientoType, int>
  get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get concepto => $composableBuilder(
    column: $table.concepto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esFiado => $composableBuilder(
    column: $table.esFiado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productosJson => $composableBuilder(
    column: $table.productosJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductosTableFilterComposer get productoId {
    final $$ProductosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableFilterComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProveedoresTableFilterComposer get proveedorId {
    final $$ProveedoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorId,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableFilterComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalesTableFilterComposer get localId {
    final $$LocalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalesTableFilterComposer(
            $db: $db,
            $table: $db.locales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosTableOrderingComposer
    extends Composer<_$AppDatabase, $MovimientosTable> {
  $$MovimientosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get concepto => $composableBuilder(
    column: $table.concepto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esFiado => $composableBuilder(
    column: $table.esFiado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productosJson => $composableBuilder(
    column: $table.productosJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductosTableOrderingComposer get productoId {
    final $$ProductosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableOrderingComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProveedoresTableOrderingComposer get proveedorId {
    final $$ProveedoresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorId,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableOrderingComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalesTableOrderingComposer get localId {
    final $$LocalesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalesTableOrderingComposer(
            $db: $db,
            $table: $db.locales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MovimientosTable> {
  $$MovimientosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get monto =>
      $composableBuilder(column: $table.monto, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MovimientoType, int> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get concepto =>
      $composableBuilder(column: $table.concepto, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<bool> get esFiado =>
      $composableBuilder(column: $table.esFiado, builder: (column) => column);

  GeneratedColumn<String> get productosJson => $composableBuilder(
    column: $table.productosJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProductosTableAnnotationComposer get productoId {
    final $$ProductosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableAnnotationComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProveedoresTableAnnotationComposer get proveedorId {
    final $$ProveedoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorId,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableAnnotationComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalesTableAnnotationComposer get localId {
    final $$LocalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalesTableAnnotationComposer(
            $db: $db,
            $table: $db.locales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MovimientosTable,
          MovimientoData,
          $$MovimientosTableFilterComposer,
          $$MovimientosTableOrderingComposer,
          $$MovimientosTableAnnotationComposer,
          $$MovimientosTableCreateCompanionBuilder,
          $$MovimientosTableUpdateCompanionBuilder,
          (MovimientoData, $$MovimientosTableReferences),
          MovimientoData,
          PrefetchHooks Function({
            bool productoId,
            bool clienteId,
            bool proveedorId,
            bool localId,
          })
        > {
  $$MovimientosTableTableManager(_$AppDatabase db, $MovimientosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovimientosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovimientosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovimientosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> monto = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<MovimientoType> tipo = const Value.absent(),
                Value<String> concepto = const Value.absent(),
                Value<String?> categoria = const Value.absent(),
                Value<String?> productoId = const Value.absent(),
                Value<String?> clienteId = const Value.absent(),
                Value<String?> proveedorId = const Value.absent(),
                Value<String?> localId = const Value.absent(),
                Value<int?> cantidad = const Value.absent(),
                Value<bool> esFiado = const Value.absent(),
                Value<String?> productosJson = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MovimientosCompanion(
                id: id,
                monto: monto,
                fecha: fecha,
                tipo: tipo,
                concepto: concepto,
                categoria: categoria,
                productoId: productoId,
                clienteId: clienteId,
                proveedorId: proveedorId,
                localId: localId,
                cantidad: cantidad,
                esFiado: esFiado,
                productosJson: productosJson,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required double monto,
                required DateTime fecha,
                required MovimientoType tipo,
                required String concepto,
                Value<String?> categoria = const Value.absent(),
                Value<String?> productoId = const Value.absent(),
                Value<String?> clienteId = const Value.absent(),
                Value<String?> proveedorId = const Value.absent(),
                Value<String?> localId = const Value.absent(),
                Value<int?> cantidad = const Value.absent(),
                Value<bool> esFiado = const Value.absent(),
                Value<String?> productosJson = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MovimientosCompanion.insert(
                id: id,
                monto: monto,
                fecha: fecha,
                tipo: tipo,
                concepto: concepto,
                categoria: categoria,
                productoId: productoId,
                clienteId: clienteId,
                proveedorId: proveedorId,
                localId: localId,
                cantidad: cantidad,
                esFiado: esFiado,
                productosJson: productosJson,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MovimientosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                productoId = false,
                clienteId = false,
                proveedorId = false,
                localId = false,
              }) {
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
                        if (productoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productoId,
                                    referencedTable:
                                        $$MovimientosTableReferences
                                            ._productoIdTable(db),
                                    referencedColumn:
                                        $$MovimientosTableReferences
                                            ._productoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (clienteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.clienteId,
                                    referencedTable:
                                        $$MovimientosTableReferences
                                            ._clienteIdTable(db),
                                    referencedColumn:
                                        $$MovimientosTableReferences
                                            ._clienteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (proveedorId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.proveedorId,
                                    referencedTable:
                                        $$MovimientosTableReferences
                                            ._proveedorIdTable(db),
                                    referencedColumn:
                                        $$MovimientosTableReferences
                                            ._proveedorIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (localId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.localId,
                                    referencedTable:
                                        $$MovimientosTableReferences
                                            ._localIdTable(db),
                                    referencedColumn:
                                        $$MovimientosTableReferences
                                            ._localIdTable(db)
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

typedef $$MovimientosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MovimientosTable,
      MovimientoData,
      $$MovimientosTableFilterComposer,
      $$MovimientosTableOrderingComposer,
      $$MovimientosTableAnnotationComposer,
      $$MovimientosTableCreateCompanionBuilder,
      $$MovimientosTableUpdateCompanionBuilder,
      (MovimientoData, $$MovimientosTableReferences),
      MovimientoData,
      PrefetchHooks Function({
        bool productoId,
        bool clienteId,
        bool proveedorId,
        bool localId,
      })
    >;
typedef $$VentasTableCreateCompanionBuilder =
    VentasCompanion Function({
      required String id,
      required double monto,
      required DateTime fecha,
      Value<String?> clienteId,
      Value<String?> clienteNombre,
      Value<String?> localId,
      Value<String?> concepto,
      Value<String?> productosJson,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime?> updatedAt,
      Value<bool> esFiado,
      Value<int> rowid,
    });
typedef $$VentasTableUpdateCompanionBuilder =
    VentasCompanion Function({
      Value<String> id,
      Value<double> monto,
      Value<DateTime> fecha,
      Value<String?> clienteId,
      Value<String?> clienteNombre,
      Value<String?> localId,
      Value<String?> concepto,
      Value<String?> productosJson,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime?> updatedAt,
      Value<bool> esFiado,
      Value<int> rowid,
    });

final class $$VentasTableReferences
    extends BaseReferences<_$AppDatabase, $VentasTable, VentaData> {
  $$VentasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientesTable _clienteIdTable(_$AppDatabase db) => db.clientes
      .createAlias($_aliasNameGenerator(db.ventas.clienteId, db.clientes.id));

  $$ClientesTableProcessedTableManager? get clienteId {
    final $_column = $_itemColumn<String>('cliente_id');
    if ($_column == null) return null;
    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocalesTable _localIdTable(_$AppDatabase db) => db.locales
      .createAlias($_aliasNameGenerator(db.ventas.localId, db.locales.id));

  $$LocalesTableProcessedTableManager? get localId {
    final $_column = $_itemColumn<String>('local_id');
    if ($_column == null) return null;
    final manager = $$LocalesTableTableManager(
      $_db,
      $_db.locales,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_localIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AbonosTable, List<AbonoData>> _abonosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.abonos,
    aliasName: $_aliasNameGenerator(db.ventas.id, db.abonos.ventaId),
  );

  $$AbonosTableProcessedTableManager get abonosRefs {
    final manager = $$AbonosTableTableManager(
      $_db,
      $_db.abonos,
    ).filter((f) => f.ventaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_abonosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VentasTableFilterComposer
    extends Composer<_$AppDatabase, $VentasTable> {
  $$VentasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clienteNombre => $composableBuilder(
    column: $table.clienteNombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get concepto => $composableBuilder(
    column: $table.concepto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productosJson => $composableBuilder(
    column: $table.productosJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esFiado => $composableBuilder(
    column: $table.esFiado,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalesTableFilterComposer get localId {
    final $$LocalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalesTableFilterComposer(
            $db: $db,
            $table: $db.locales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> abonosRefs(
    Expression<bool> Function($$AbonosTableFilterComposer f) f,
  ) {
    final $$AbonosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.abonos,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AbonosTableFilterComposer(
            $db: $db,
            $table: $db.abonos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VentasTableOrderingComposer
    extends Composer<_$AppDatabase, $VentasTable> {
  $$VentasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clienteNombre => $composableBuilder(
    column: $table.clienteNombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get concepto => $composableBuilder(
    column: $table.concepto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productosJson => $composableBuilder(
    column: $table.productosJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esFiado => $composableBuilder(
    column: $table.esFiado,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalesTableOrderingComposer get localId {
    final $$LocalesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalesTableOrderingComposer(
            $db: $db,
            $table: $db.locales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VentasTableAnnotationComposer
    extends Composer<_$AppDatabase, $VentasTable> {
  $$VentasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get monto =>
      $composableBuilder(column: $table.monto, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get clienteNombre => $composableBuilder(
    column: $table.clienteNombre,
    builder: (column) => column,
  );

  GeneratedColumn<String> get concepto =>
      $composableBuilder(column: $table.concepto, builder: (column) => column);

  GeneratedColumn<String> get productosJson => $composableBuilder(
    column: $table.productosJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get esFiado =>
      $composableBuilder(column: $table.esFiado, builder: (column) => column);

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalesTableAnnotationComposer get localId {
    final $$LocalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalesTableAnnotationComposer(
            $db: $db,
            $table: $db.locales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> abonosRefs<T extends Object>(
    Expression<T> Function($$AbonosTableAnnotationComposer a) f,
  ) {
    final $$AbonosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.abonos,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AbonosTableAnnotationComposer(
            $db: $db,
            $table: $db.abonos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VentasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VentasTable,
          VentaData,
          $$VentasTableFilterComposer,
          $$VentasTableOrderingComposer,
          $$VentasTableAnnotationComposer,
          $$VentasTableCreateCompanionBuilder,
          $$VentasTableUpdateCompanionBuilder,
          (VentaData, $$VentasTableReferences),
          VentaData,
          PrefetchHooks Function({
            bool clienteId,
            bool localId,
            bool abonosRefs,
          })
        > {
  $$VentasTableTableManager(_$AppDatabase db, $VentasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VentasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VentasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VentasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> monto = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String?> clienteId = const Value.absent(),
                Value<String?> clienteNombre = const Value.absent(),
                Value<String?> localId = const Value.absent(),
                Value<String?> concepto = const Value.absent(),
                Value<String?> productosJson = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<bool> esFiado = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VentasCompanion(
                id: id,
                monto: monto,
                fecha: fecha,
                clienteId: clienteId,
                clienteNombre: clienteNombre,
                localId: localId,
                concepto: concepto,
                productosJson: productosJson,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                updatedAt: updatedAt,
                esFiado: esFiado,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required double monto,
                required DateTime fecha,
                Value<String?> clienteId = const Value.absent(),
                Value<String?> clienteNombre = const Value.absent(),
                Value<String?> localId = const Value.absent(),
                Value<String?> concepto = const Value.absent(),
                Value<String?> productosJson = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<bool> esFiado = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VentasCompanion.insert(
                id: id,
                monto: monto,
                fecha: fecha,
                clienteId: clienteId,
                clienteNombre: clienteNombre,
                localId: localId,
                concepto: concepto,
                productosJson: productosJson,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                updatedAt: updatedAt,
                esFiado: esFiado,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$VentasTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({clienteId = false, localId = false, abonosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (abonosRefs) db.abonos],
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
                        if (clienteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.clienteId,
                                    referencedTable: $$VentasTableReferences
                                        ._clienteIdTable(db),
                                    referencedColumn: $$VentasTableReferences
                                        ._clienteIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (localId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.localId,
                                    referencedTable: $$VentasTableReferences
                                        ._localIdTable(db),
                                    referencedColumn: $$VentasTableReferences
                                        ._localIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (abonosRefs)
                        await $_getPrefetchedData<
                          VentaData,
                          $VentasTable,
                          AbonoData
                        >(
                          currentTable: table,
                          referencedTable: $$VentasTableReferences
                              ._abonosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VentasTableReferences(db, table, p0).abonosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ventaId == item.id,
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

typedef $$VentasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VentasTable,
      VentaData,
      $$VentasTableFilterComposer,
      $$VentasTableOrderingComposer,
      $$VentasTableAnnotationComposer,
      $$VentasTableCreateCompanionBuilder,
      $$VentasTableUpdateCompanionBuilder,
      (VentaData, $$VentasTableReferences),
      VentaData,
      PrefetchHooks Function({bool clienteId, bool localId, bool abonosRefs})
    >;
typedef $$PedidosProveedorTableCreateCompanionBuilder =
    PedidosProveedorCompanion Function({
      required String id,
      required String proveedorId,
      Value<String?> proveedorNombre,
      Value<String?> localId,
      required DateTime fechaPedido,
      required DateTime fechaEntrega,
      required String productos,
      required double montoTotal,
      Value<bool> isEntregado,
      Value<String?> notas,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$PedidosProveedorTableUpdateCompanionBuilder =
    PedidosProveedorCompanion Function({
      Value<String> id,
      Value<String> proveedorId,
      Value<String?> proveedorNombre,
      Value<String?> localId,
      Value<DateTime> fechaPedido,
      Value<DateTime> fechaEntrega,
      Value<String> productos,
      Value<double> montoTotal,
      Value<bool> isEntregado,
      Value<String?> notas,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

final class $$PedidosProveedorTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PedidosProveedorTable,
          PedidoProveedorData
        > {
  $$PedidosProveedorTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProveedoresTable _proveedorIdTable(_$AppDatabase db) =>
      db.proveedores.createAlias(
        $_aliasNameGenerator(
          db.pedidosProveedor.proveedorId,
          db.proveedores.id,
        ),
      );

  $$ProveedoresTableProcessedTableManager get proveedorId {
    final $_column = $_itemColumn<String>('proveedor_id')!;

    final manager = $$ProveedoresTableTableManager(
      $_db,
      $_db.proveedores,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_proveedorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocalesTable _localIdTable(_$AppDatabase db) =>
      db.locales.createAlias(
        $_aliasNameGenerator(db.pedidosProveedor.localId, db.locales.id),
      );

  $$LocalesTableProcessedTableManager? get localId {
    final $_column = $_itemColumn<String>('local_id');
    if ($_column == null) return null;
    final manager = $$LocalesTableTableManager(
      $_db,
      $_db.locales,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_localIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PedidosProveedorTableFilterComposer
    extends Composer<_$AppDatabase, $PedidosProveedorTable> {
  $$PedidosProveedorTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proveedorNombre => $composableBuilder(
    column: $table.proveedorNombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaPedido => $composableBuilder(
    column: $table.fechaPedido,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaEntrega => $composableBuilder(
    column: $table.fechaEntrega,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productos => $composableBuilder(
    column: $table.productos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get montoTotal => $composableBuilder(
    column: $table.montoTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEntregado => $composableBuilder(
    column: $table.isEntregado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProveedoresTableFilterComposer get proveedorId {
    final $$ProveedoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorId,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableFilterComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalesTableFilterComposer get localId {
    final $$LocalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalesTableFilterComposer(
            $db: $db,
            $table: $db.locales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PedidosProveedorTableOrderingComposer
    extends Composer<_$AppDatabase, $PedidosProveedorTable> {
  $$PedidosProveedorTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proveedorNombre => $composableBuilder(
    column: $table.proveedorNombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaPedido => $composableBuilder(
    column: $table.fechaPedido,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaEntrega => $composableBuilder(
    column: $table.fechaEntrega,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productos => $composableBuilder(
    column: $table.productos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get montoTotal => $composableBuilder(
    column: $table.montoTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEntregado => $composableBuilder(
    column: $table.isEntregado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProveedoresTableOrderingComposer get proveedorId {
    final $$ProveedoresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorId,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableOrderingComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalesTableOrderingComposer get localId {
    final $$LocalesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalesTableOrderingComposer(
            $db: $db,
            $table: $db.locales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PedidosProveedorTableAnnotationComposer
    extends Composer<_$AppDatabase, $PedidosProveedorTable> {
  $$PedidosProveedorTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get proveedorNombre => $composableBuilder(
    column: $table.proveedorNombre,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaPedido => $composableBuilder(
    column: $table.fechaPedido,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaEntrega => $composableBuilder(
    column: $table.fechaEntrega,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productos =>
      $composableBuilder(column: $table.productos, builder: (column) => column);

  GeneratedColumn<double> get montoTotal => $composableBuilder(
    column: $table.montoTotal,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEntregado => $composableBuilder(
    column: $table.isEntregado,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProveedoresTableAnnotationComposer get proveedorId {
    final $$ProveedoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorId,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableAnnotationComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalesTableAnnotationComposer get localId {
    final $$LocalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalesTableAnnotationComposer(
            $db: $db,
            $table: $db.locales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PedidosProveedorTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PedidosProveedorTable,
          PedidoProveedorData,
          $$PedidosProveedorTableFilterComposer,
          $$PedidosProveedorTableOrderingComposer,
          $$PedidosProveedorTableAnnotationComposer,
          $$PedidosProveedorTableCreateCompanionBuilder,
          $$PedidosProveedorTableUpdateCompanionBuilder,
          (PedidoProveedorData, $$PedidosProveedorTableReferences),
          PedidoProveedorData,
          PrefetchHooks Function({bool proveedorId, bool localId})
        > {
  $$PedidosProveedorTableTableManager(
    _$AppDatabase db,
    $PedidosProveedorTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PedidosProveedorTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PedidosProveedorTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PedidosProveedorTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> proveedorId = const Value.absent(),
                Value<String?> proveedorNombre = const Value.absent(),
                Value<String?> localId = const Value.absent(),
                Value<DateTime> fechaPedido = const Value.absent(),
                Value<DateTime> fechaEntrega = const Value.absent(),
                Value<String> productos = const Value.absent(),
                Value<double> montoTotal = const Value.absent(),
                Value<bool> isEntregado = const Value.absent(),
                Value<String?> notas = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PedidosProveedorCompanion(
                id: id,
                proveedorId: proveedorId,
                proveedorNombre: proveedorNombre,
                localId: localId,
                fechaPedido: fechaPedido,
                fechaEntrega: fechaEntrega,
                productos: productos,
                montoTotal: montoTotal,
                isEntregado: isEntregado,
                notas: notas,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String proveedorId,
                Value<String?> proveedorNombre = const Value.absent(),
                Value<String?> localId = const Value.absent(),
                required DateTime fechaPedido,
                required DateTime fechaEntrega,
                required String productos,
                required double montoTotal,
                Value<bool> isEntregado = const Value.absent(),
                Value<String?> notas = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PedidosProveedorCompanion.insert(
                id: id,
                proveedorId: proveedorId,
                proveedorNombre: proveedorNombre,
                localId: localId,
                fechaPedido: fechaPedido,
                fechaEntrega: fechaEntrega,
                productos: productos,
                montoTotal: montoTotal,
                isEntregado: isEntregado,
                notas: notas,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PedidosProveedorTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({proveedorId = false, localId = false}) {
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
                    if (proveedorId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.proveedorId,
                                referencedTable:
                                    $$PedidosProveedorTableReferences
                                        ._proveedorIdTable(db),
                                referencedColumn:
                                    $$PedidosProveedorTableReferences
                                        ._proveedorIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (localId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.localId,
                                referencedTable:
                                    $$PedidosProveedorTableReferences
                                        ._localIdTable(db),
                                referencedColumn:
                                    $$PedidosProveedorTableReferences
                                        ._localIdTable(db)
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

typedef $$PedidosProveedorTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PedidosProveedorTable,
      PedidoProveedorData,
      $$PedidosProveedorTableFilterComposer,
      $$PedidosProveedorTableOrderingComposer,
      $$PedidosProveedorTableAnnotationComposer,
      $$PedidosProveedorTableCreateCompanionBuilder,
      $$PedidosProveedorTableUpdateCompanionBuilder,
      (PedidoProveedorData, $$PedidosProveedorTableReferences),
      PedidoProveedorData,
      PrefetchHooks Function({bool proveedorId, bool localId})
    >;
typedef $$LocalUsersTableCreateCompanionBuilder =
    LocalUsersCompanion Function({
      required String id,
      required String email,
      required String hashedPassword,
      required DateTime lastLogin,
      Value<String?> pinHash,
      Value<String> rol,
      Value<int> rowid,
    });
typedef $$LocalUsersTableUpdateCompanionBuilder =
    LocalUsersCompanion Function({
      Value<String> id,
      Value<String> email,
      Value<String> hashedPassword,
      Value<DateTime> lastLogin,
      Value<String?> pinHash,
      Value<String> rol,
      Value<int> rowid,
    });

class $$LocalUsersTableFilterComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hashedPassword => $composableBuilder(
    column: $table.hashedPassword,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastLogin => $composableBuilder(
    column: $table.lastLogin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rol => $composableBuilder(
    column: $table.rol,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hashedPassword => $composableBuilder(
    column: $table.hashedPassword,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastLogin => $composableBuilder(
    column: $table.lastLogin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rol => $composableBuilder(
    column: $table.rol,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get hashedPassword => $composableBuilder(
    column: $table.hashedPassword,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastLogin =>
      $composableBuilder(column: $table.lastLogin, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get rol =>
      $composableBuilder(column: $table.rol, builder: (column) => column);
}

class $$LocalUsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalUsersTable,
          LocalUserData,
          $$LocalUsersTableFilterComposer,
          $$LocalUsersTableOrderingComposer,
          $$LocalUsersTableAnnotationComposer,
          $$LocalUsersTableCreateCompanionBuilder,
          $$LocalUsersTableUpdateCompanionBuilder,
          (
            LocalUserData,
            BaseReferences<_$AppDatabase, $LocalUsersTable, LocalUserData>,
          ),
          LocalUserData,
          PrefetchHooks Function()
        > {
  $$LocalUsersTableTableManager(_$AppDatabase db, $LocalUsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> hashedPassword = const Value.absent(),
                Value<DateTime> lastLogin = const Value.absent(),
                Value<String?> pinHash = const Value.absent(),
                Value<String> rol = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUsersCompanion(
                id: id,
                email: email,
                hashedPassword: hashedPassword,
                lastLogin: lastLogin,
                pinHash: pinHash,
                rol: rol,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String email,
                required String hashedPassword,
                required DateTime lastLogin,
                Value<String?> pinHash = const Value.absent(),
                Value<String> rol = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUsersCompanion.insert(
                id: id,
                email: email,
                hashedPassword: hashedPassword,
                lastLogin: lastLogin,
                pinHash: pinHash,
                rol: rol,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalUsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalUsersTable,
      LocalUserData,
      $$LocalUsersTableFilterComposer,
      $$LocalUsersTableOrderingComposer,
      $$LocalUsersTableAnnotationComposer,
      $$LocalUsersTableCreateCompanionBuilder,
      $$LocalUsersTableUpdateCompanionBuilder,
      (
        LocalUserData,
        BaseReferences<_$AppDatabase, $LocalUsersTable, LocalUserData>,
      ),
      LocalUserData,
      PrefetchHooks Function()
    >;
typedef $$AbonosTableCreateCompanionBuilder =
    AbonosCompanion Function({
      required String id,
      required String clienteId,
      Value<String?> ventaId,
      required double monto,
      required DateTime fecha,
      required double saldoRestante,
      Value<String?> concepto,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AbonosTableUpdateCompanionBuilder =
    AbonosCompanion Function({
      Value<String> id,
      Value<String> clienteId,
      Value<String?> ventaId,
      Value<double> monto,
      Value<DateTime> fecha,
      Value<double> saldoRestante,
      Value<String?> concepto,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$AbonosTableReferences
    extends BaseReferences<_$AppDatabase, $AbonosTable, AbonoData> {
  $$AbonosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientesTable _clienteIdTable(_$AppDatabase db) => db.clientes
      .createAlias($_aliasNameGenerator(db.abonos.clienteId, db.clientes.id));

  $$ClientesTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<String>('cliente_id')!;

    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $VentasTable _ventaIdTable(_$AppDatabase db) => db.ventas.createAlias(
    $_aliasNameGenerator(db.abonos.ventaId, db.ventas.id),
  );

  $$VentasTableProcessedTableManager? get ventaId {
    final $_column = $_itemColumn<String>('venta_id');
    if ($_column == null) return null;
    final manager = $$VentasTableTableManager(
      $_db,
      $_db.ventas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ventaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AbonosTableFilterComposer
    extends Composer<_$AppDatabase, $AbonosTable> {
  $$AbonosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saldoRestante => $composableBuilder(
    column: $table.saldoRestante,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get concepto => $composableBuilder(
    column: $table.concepto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VentasTableFilterComposer get ventaId {
    final $$VentasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableFilterComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AbonosTableOrderingComposer
    extends Composer<_$AppDatabase, $AbonosTable> {
  $$AbonosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saldoRestante => $composableBuilder(
    column: $table.saldoRestante,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get concepto => $composableBuilder(
    column: $table.concepto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VentasTableOrderingComposer get ventaId {
    final $$VentasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableOrderingComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AbonosTableAnnotationComposer
    extends Composer<_$AppDatabase, $AbonosTable> {
  $$AbonosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get monto =>
      $composableBuilder(column: $table.monto, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<double> get saldoRestante => $composableBuilder(
    column: $table.saldoRestante,
    builder: (column) => column,
  );

  GeneratedColumn<String> get concepto =>
      $composableBuilder(column: $table.concepto, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VentasTableAnnotationComposer get ventaId {
    final $$VentasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableAnnotationComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AbonosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AbonosTable,
          AbonoData,
          $$AbonosTableFilterComposer,
          $$AbonosTableOrderingComposer,
          $$AbonosTableAnnotationComposer,
          $$AbonosTableCreateCompanionBuilder,
          $$AbonosTableUpdateCompanionBuilder,
          (AbonoData, $$AbonosTableReferences),
          AbonoData,
          PrefetchHooks Function({bool clienteId, bool ventaId})
        > {
  $$AbonosTableTableManager(_$AppDatabase db, $AbonosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AbonosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AbonosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AbonosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clienteId = const Value.absent(),
                Value<String?> ventaId = const Value.absent(),
                Value<double> monto = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<double> saldoRestante = const Value.absent(),
                Value<String?> concepto = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AbonosCompanion(
                id: id,
                clienteId: clienteId,
                ventaId: ventaId,
                monto: monto,
                fecha: fecha,
                saldoRestante: saldoRestante,
                concepto: concepto,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clienteId,
                Value<String?> ventaId = const Value.absent(),
                required double monto,
                required DateTime fecha,
                required double saldoRestante,
                Value<String?> concepto = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AbonosCompanion.insert(
                id: id,
                clienteId: clienteId,
                ventaId: ventaId,
                monto: monto,
                fecha: fecha,
                saldoRestante: saldoRestante,
                concepto: concepto,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$AbonosTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({clienteId = false, ventaId = false}) {
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
                    if (clienteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.clienteId,
                                referencedTable: $$AbonosTableReferences
                                    ._clienteIdTable(db),
                                referencedColumn: $$AbonosTableReferences
                                    ._clienteIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (ventaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ventaId,
                                referencedTable: $$AbonosTableReferences
                                    ._ventaIdTable(db),
                                referencedColumn: $$AbonosTableReferences
                                    ._ventaIdTable(db)
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

typedef $$AbonosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AbonosTable,
      AbonoData,
      $$AbonosTableFilterComposer,
      $$AbonosTableOrderingComposer,
      $$AbonosTableAnnotationComposer,
      $$AbonosTableCreateCompanionBuilder,
      $$AbonosTableUpdateCompanionBuilder,
      (AbonoData, $$AbonosTableReferences),
      AbonoData,
      PrefetchHooks Function({bool clienteId, bool ventaId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalesTableTableManager get locales =>
      $$LocalesTableTableManager(_db, _db.locales);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db, _db.clientes);
  $$ProveedoresTableTableManager get proveedores =>
      $$ProveedoresTableTableManager(_db, _db.proveedores);
  $$ProductosTableTableManager get productos =>
      $$ProductosTableTableManager(_db, _db.productos);
  $$MovimientosTableTableManager get movimientos =>
      $$MovimientosTableTableManager(_db, _db.movimientos);
  $$VentasTableTableManager get ventas =>
      $$VentasTableTableManager(_db, _db.ventas);
  $$PedidosProveedorTableTableManager get pedidosProveedor =>
      $$PedidosProveedorTableTableManager(_db, _db.pedidosProveedor);
  $$LocalUsersTableTableManager get localUsers =>
      $$LocalUsersTableTableManager(_db, _db.localUsers);
  $$AbonosTableTableManager get abonos =>
      $$AbonosTableTableManager(_db, _db.abonos);
}
