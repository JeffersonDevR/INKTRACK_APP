// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    telefono,
    email,
    esFiado,
    saldoPendiente,
    isActivo,
    syncStatus,
    lastSyncedAt,
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
    } else if (isInserting) {
      context.missing(_emailMeta);
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
      )!,
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
  final String email;
  final bool esFiado;
  final double saldoPendiente;
  final bool isActivo;
  final String syncStatus;
  final DateTime? lastSyncedAt;
  const ClienteData({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.email,
    required this.esFiado,
    required this.saldoPendiente,
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
    map['email'] = Variable<String>(email);
    map['es_fiado'] = Variable<bool>(esFiado);
    map['saldo_pendiente'] = Variable<double>(saldoPendiente);
    map['is_activo'] = Variable<bool>(isActivo);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  ClientesCompanion toCompanion(bool nullToAbsent) {
    return ClientesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      telefono: Value(telefono),
      email: Value(email),
      esFiado: Value(esFiado),
      saldoPendiente: Value(saldoPendiente),
      isActivo: Value(isActivo),
      syncStatus: Value(syncStatus),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
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
      email: serializer.fromJson<String>(json['email']),
      esFiado: serializer.fromJson<bool>(json['esFiado']),
      saldoPendiente: serializer.fromJson<double>(json['saldoPendiente']),
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
      'email': serializer.toJson<String>(email),
      'esFiado': serializer.toJson<bool>(esFiado),
      'saldoPendiente': serializer.toJson<double>(saldoPendiente),
      'isActivo': serializer.toJson<bool>(isActivo),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  ClienteData copyWith({
    String? id,
    String? nombre,
    String? telefono,
    String? email,
    bool? esFiado,
    double? saldoPendiente,
    bool? isActivo,
    String? syncStatus,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => ClienteData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    telefono: telefono ?? this.telefono,
    email: email ?? this.email,
    esFiado: esFiado ?? this.esFiado,
    saldoPendiente: saldoPendiente ?? this.saldoPendiente,
    isActivo: isActivo ?? this.isActivo,
    syncStatus: syncStatus ?? this.syncStatus,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  ClienteData copyWithCompanion(ClientesCompanion data) {
    return ClienteData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      email: data.email.present ? data.email.value : this.email,
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
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClienteData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('esFiado: $esFiado, ')
          ..write('saldoPendiente: $saldoPendiente, ')
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
    email,
    esFiado,
    saldoPendiente,
    isActivo,
    syncStatus,
    lastSyncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClienteData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.telefono == this.telefono &&
          other.email == this.email &&
          other.esFiado == this.esFiado &&
          other.saldoPendiente == this.saldoPendiente &&
          other.isActivo == this.isActivo &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class ClientesCompanion extends UpdateCompanion<ClienteData> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> telefono;
  final Value<String> email;
  final Value<bool> esFiado;
  final Value<double> saldoPendiente;
  final Value<bool> isActivo;
  final Value<String> syncStatus;
  final Value<DateTime?> lastSyncedAt;
  final Value<int> rowid;
  const ClientesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.esFiado = const Value.absent(),
    this.saldoPendiente = const Value.absent(),
    this.isActivo = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientesCompanion.insert({
    required String id,
    required String nombre,
    required String telefono,
    required String email,
    this.esFiado = const Value.absent(),
    this.saldoPendiente = const Value.absent(),
    this.isActivo = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       telefono = Value(telefono),
       email = Value(email);
  static Insertable<ClienteData> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? telefono,
    Expression<String>? email,
    Expression<bool>? esFiado,
    Expression<double>? saldoPendiente,
    Expression<bool>? isActivo,
    Expression<String>? syncStatus,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (telefono != null) 'telefono': telefono,
      if (email != null) 'email': email,
      if (esFiado != null) 'es_fiado': esFiado,
      if (saldoPendiente != null) 'saldo_pendiente': saldoPendiente,
      if (isActivo != null) 'is_activo': isActivo,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientesCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? telefono,
    Value<String>? email,
    Value<bool>? esFiado,
    Value<double>? saldoPendiente,
    Value<bool>? isActivo,
    Value<String>? syncStatus,
    Value<DateTime?>? lastSyncedAt,
    Value<int>? rowid,
  }) {
    return ClientesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      esFiado: esFiado ?? this.esFiado,
      saldoPendiente: saldoPendiente ?? this.saldoPendiente,
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
    if (email.present) {
      map['email'] = Variable<String>(email.value);
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
          ..write('esFiado: $esFiado, ')
          ..write('saldoPendiente: $saldoPendiente, ')
          ..write('isActivo: $isActivo, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
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
  final bool isActivo;
  final String syncStatus;
  final DateTime? lastSyncedAt;
  const ProveedorData({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.diasVisita,
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
    bool? isActivo,
    String? syncStatus,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => ProveedorData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    telefono: telefono ?? this.telefono,
    diasVisita: diasVisita ?? this.diasVisita,
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
          other.isActivo == this.isActivo &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class ProveedoresCompanion extends UpdateCompanion<ProveedorData> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> telefono;
  final Value<List<String>> diasVisita;
  final Value<bool> isActivo;
  final Value<String> syncStatus;
  final Value<DateTime?> lastSyncedAt;
  final Value<int> rowid;
  const ProveedoresCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.telefono = const Value.absent(),
    this.diasVisita = const Value.absent(),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    cantidad,
    precio,
    categoria,
    proveedorId,
    stockMinimo,
    codigoBarras,
    codigoPersonalizado,
    proveedorNombre,
    isActivo,
    syncStatus,
    lastSyncedAt,
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
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      )!,
      proveedorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proveedor_id'],
      )!,
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
  final String categoria;
  final String proveedorId;
  final int stockMinimo;
  final String? codigoBarras;
  final String? codigoPersonalizado;
  final String? proveedorNombre;
  final bool isActivo;
  final String syncStatus;
  final DateTime? lastSyncedAt;
  const ProductoData({
    required this.id,
    required this.nombre,
    required this.cantidad,
    required this.precio,
    required this.categoria,
    required this.proveedorId,
    required this.stockMinimo,
    this.codigoBarras,
    this.codigoPersonalizado,
    this.proveedorNombre,
    required this.isActivo,
    required this.syncStatus,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['cantidad'] = Variable<int>(cantidad);
    map['precio'] = Variable<double>(precio);
    map['categoria'] = Variable<String>(categoria);
    map['proveedor_id'] = Variable<String>(proveedorId);
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
    return map;
  }

  ProductosCompanion toCompanion(bool nullToAbsent) {
    return ProductosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      cantidad: Value(cantidad),
      precio: Value(precio),
      categoria: Value(categoria),
      proveedorId: Value(proveedorId),
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
      categoria: serializer.fromJson<String>(json['categoria']),
      proveedorId: serializer.fromJson<String>(json['proveedorId']),
      stockMinimo: serializer.fromJson<int>(json['stockMinimo']),
      codigoBarras: serializer.fromJson<String?>(json['codigoBarras']),
      codigoPersonalizado: serializer.fromJson<String?>(
        json['codigoPersonalizado'],
      ),
      proveedorNombre: serializer.fromJson<String?>(json['proveedorNombre']),
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
      'cantidad': serializer.toJson<int>(cantidad),
      'precio': serializer.toJson<double>(precio),
      'categoria': serializer.toJson<String>(categoria),
      'proveedorId': serializer.toJson<String>(proveedorId),
      'stockMinimo': serializer.toJson<int>(stockMinimo),
      'codigoBarras': serializer.toJson<String?>(codigoBarras),
      'codigoPersonalizado': serializer.toJson<String?>(codigoPersonalizado),
      'proveedorNombre': serializer.toJson<String?>(proveedorNombre),
      'isActivo': serializer.toJson<bool>(isActivo),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  ProductoData copyWith({
    String? id,
    String? nombre,
    int? cantidad,
    double? precio,
    String? categoria,
    String? proveedorId,
    int? stockMinimo,
    Value<String?> codigoBarras = const Value.absent(),
    Value<String?> codigoPersonalizado = const Value.absent(),
    Value<String?> proveedorNombre = const Value.absent(),
    bool? isActivo,
    String? syncStatus,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => ProductoData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    cantidad: cantidad ?? this.cantidad,
    precio: precio ?? this.precio,
    categoria: categoria ?? this.categoria,
    proveedorId: proveedorId ?? this.proveedorId,
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
  );
  ProductoData copyWithCompanion(ProductosCompanion data) {
    return ProductoData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precio: data.precio.present ? data.precio.value : this.precio,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      proveedorId: data.proveedorId.present
          ? data.proveedorId.value
          : this.proveedorId,
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
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductoData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('cantidad: $cantidad, ')
          ..write('precio: $precio, ')
          ..write('categoria: $categoria, ')
          ..write('proveedorId: $proveedorId, ')
          ..write('stockMinimo: $stockMinimo, ')
          ..write('codigoBarras: $codigoBarras, ')
          ..write('codigoPersonalizado: $codigoPersonalizado, ')
          ..write('proveedorNombre: $proveedorNombre, ')
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
    cantidad,
    precio,
    categoria,
    proveedorId,
    stockMinimo,
    codigoBarras,
    codigoPersonalizado,
    proveedorNombre,
    isActivo,
    syncStatus,
    lastSyncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductoData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.cantidad == this.cantidad &&
          other.precio == this.precio &&
          other.categoria == this.categoria &&
          other.proveedorId == this.proveedorId &&
          other.stockMinimo == this.stockMinimo &&
          other.codigoBarras == this.codigoBarras &&
          other.codigoPersonalizado == this.codigoPersonalizado &&
          other.proveedorNombre == this.proveedorNombre &&
          other.isActivo == this.isActivo &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class ProductosCompanion extends UpdateCompanion<ProductoData> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<int> cantidad;
  final Value<double> precio;
  final Value<String> categoria;
  final Value<String> proveedorId;
  final Value<int> stockMinimo;
  final Value<String?> codigoBarras;
  final Value<String?> codigoPersonalizado;
  final Value<String?> proveedorNombre;
  final Value<bool> isActivo;
  final Value<String> syncStatus;
  final Value<DateTime?> lastSyncedAt;
  final Value<int> rowid;
  const ProductosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precio = const Value.absent(),
    this.categoria = const Value.absent(),
    this.proveedorId = const Value.absent(),
    this.stockMinimo = const Value.absent(),
    this.codigoBarras = const Value.absent(),
    this.codigoPersonalizado = const Value.absent(),
    this.proveedorNombre = const Value.absent(),
    this.isActivo = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductosCompanion.insert({
    required String id,
    required String nombre,
    required int cantidad,
    required double precio,
    required String categoria,
    required String proveedorId,
    this.stockMinimo = const Value.absent(),
    this.codigoBarras = const Value.absent(),
    this.codigoPersonalizado = const Value.absent(),
    this.proveedorNombre = const Value.absent(),
    this.isActivo = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
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
    Expression<String>? categoria,
    Expression<String>? proveedorId,
    Expression<int>? stockMinimo,
    Expression<String>? codigoBarras,
    Expression<String>? codigoPersonalizado,
    Expression<String>? proveedorNombre,
    Expression<bool>? isActivo,
    Expression<String>? syncStatus,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (cantidad != null) 'cantidad': cantidad,
      if (precio != null) 'precio': precio,
      if (categoria != null) 'categoria': categoria,
      if (proveedorId != null) 'proveedor_id': proveedorId,
      if (stockMinimo != null) 'stock_minimo': stockMinimo,
      if (codigoBarras != null) 'codigo_barras': codigoBarras,
      if (codigoPersonalizado != null)
        'codigo_personalizado': codigoPersonalizado,
      if (proveedorNombre != null) 'proveedor_nombre': proveedorNombre,
      if (isActivo != null) 'is_activo': isActivo,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductosCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<int>? cantidad,
    Value<double>? precio,
    Value<String>? categoria,
    Value<String>? proveedorId,
    Value<int>? stockMinimo,
    Value<String?>? codigoBarras,
    Value<String?>? codigoPersonalizado,
    Value<String?>? proveedorNombre,
    Value<bool>? isActivo,
    Value<String>? syncStatus,
    Value<DateTime?>? lastSyncedAt,
    Value<int>? rowid,
  }) {
    return ProductosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      cantidad: cantidad ?? this.cantidad,
      precio: precio ?? this.precio,
      categoria: categoria ?? this.categoria,
      proveedorId: proveedorId ?? this.proveedorId,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      codigoPersonalizado: codigoPersonalizado ?? this.codigoPersonalizado,
      proveedorNombre: proveedorNombre ?? this.proveedorNombre,
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
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (precio.present) {
      map['precio'] = Variable<double>(precio.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (proveedorId.present) {
      map['proveedor_id'] = Variable<String>(proveedorId.value);
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
          ..write('categoria: $categoria, ')
          ..write('proveedorId: $proveedorId, ')
          ..write('stockMinimo: $stockMinimo, ')
          ..write('codigoBarras: $codigoBarras, ')
          ..write('codigoPersonalizado: $codigoPersonalizado, ')
          ..write('proveedorNombre: $proveedorNombre, ')
          ..write('isActivo: $isActivo, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
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
    monto,
    fecha,
    tipo,
    concepto,
    categoria,
    productoId,
    clienteId,
    proveedorId,
    cantidad,
    esFiado,
    syncStatus,
    lastSyncedAt,
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
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      ),
      esFiado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_fiado'],
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
  final int? cantidad;
  final bool esFiado;
  final String syncStatus;
  final DateTime? lastSyncedAt;
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
    this.cantidad,
    required this.esFiado,
    required this.syncStatus,
    this.lastSyncedAt,
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
    if (!nullToAbsent || cantidad != null) {
      map['cantidad'] = Variable<int>(cantidad);
    }
    map['es_fiado'] = Variable<bool>(esFiado);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
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
      cantidad: cantidad == null && nullToAbsent
          ? const Value.absent()
          : Value(cantidad),
      esFiado: Value(esFiado),
      syncStatus: Value(syncStatus),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
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
      cantidad: serializer.fromJson<int?>(json['cantidad']),
      esFiado: serializer.fromJson<bool>(json['esFiado']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
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
      'cantidad': serializer.toJson<int?>(cantidad),
      'esFiado': serializer.toJson<bool>(esFiado),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
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
    Value<int?> cantidad = const Value.absent(),
    bool? esFiado,
    String? syncStatus,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
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
    cantidad: cantidad.present ? cantidad.value : this.cantidad,
    esFiado: esFiado ?? this.esFiado,
    syncStatus: syncStatus ?? this.syncStatus,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
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
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      esFiado: data.esFiado.present ? data.esFiado.value : this.esFiado,
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
          ..write('cantidad: $cantidad, ')
          ..write('esFiado: $esFiado, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt')
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
    cantidad,
    esFiado,
    syncStatus,
    lastSyncedAt,
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
          other.cantidad == this.cantidad &&
          other.esFiado == this.esFiado &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncedAt == this.lastSyncedAt);
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
  final Value<int?> cantidad;
  final Value<bool> esFiado;
  final Value<String> syncStatus;
  final Value<DateTime?> lastSyncedAt;
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
    this.cantidad = const Value.absent(),
    this.esFiado = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
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
    this.cantidad = const Value.absent(),
    this.esFiado = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
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
    Expression<int>? cantidad,
    Expression<bool>? esFiado,
    Expression<String>? syncStatus,
    Expression<DateTime>? lastSyncedAt,
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
      if (cantidad != null) 'cantidad': cantidad,
      if (esFiado != null) 'es_fiado': esFiado,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
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
    Value<int?>? cantidad,
    Value<bool>? esFiado,
    Value<String>? syncStatus,
    Value<DateTime?>? lastSyncedAt,
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
      cantidad: cantidad ?? this.cantidad,
      esFiado: esFiado ?? this.esFiado,
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
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (esFiado.present) {
      map['es_fiado'] = Variable<bool>(esFiado.value);
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
          ..write('cantidad: $cantidad, ')
          ..write('esFiado: $esFiado, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
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
    monto,
    fecha,
    clienteId,
    clienteNombre,
    concepto,
    syncStatus,
    lastSyncedAt,
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
  final String? concepto;
  final String syncStatus;
  final DateTime? lastSyncedAt;
  const VentaData({
    required this.id,
    required this.monto,
    required this.fecha,
    this.clienteId,
    this.clienteNombre,
    this.concepto,
    required this.syncStatus,
    this.lastSyncedAt,
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
    if (!nullToAbsent || concepto != null) {
      map['concepto'] = Variable<String>(concepto);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
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
      concepto: concepto == null && nullToAbsent
          ? const Value.absent()
          : Value(concepto),
      syncStatus: Value(syncStatus),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
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
      concepto: serializer.fromJson<String?>(json['concepto']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
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
      'concepto': serializer.toJson<String?>(concepto),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  VentaData copyWith({
    String? id,
    double? monto,
    DateTime? fecha,
    Value<String?> clienteId = const Value.absent(),
    Value<String?> clienteNombre = const Value.absent(),
    Value<String?> concepto = const Value.absent(),
    String? syncStatus,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => VentaData(
    id: id ?? this.id,
    monto: monto ?? this.monto,
    fecha: fecha ?? this.fecha,
    clienteId: clienteId.present ? clienteId.value : this.clienteId,
    clienteNombre: clienteNombre.present
        ? clienteNombre.value
        : this.clienteNombre,
    concepto: concepto.present ? concepto.value : this.concepto,
    syncStatus: syncStatus ?? this.syncStatus,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
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
      concepto: data.concepto.present ? data.concepto.value : this.concepto,
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
    return (StringBuffer('VentaData(')
          ..write('id: $id, ')
          ..write('monto: $monto, ')
          ..write('fecha: $fecha, ')
          ..write('clienteId: $clienteId, ')
          ..write('clienteNombre: $clienteNombre, ')
          ..write('concepto: $concepto, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt')
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
    concepto,
    syncStatus,
    lastSyncedAt,
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
          other.concepto == this.concepto &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class VentasCompanion extends UpdateCompanion<VentaData> {
  final Value<String> id;
  final Value<double> monto;
  final Value<DateTime> fecha;
  final Value<String?> clienteId;
  final Value<String?> clienteNombre;
  final Value<String?> concepto;
  final Value<String> syncStatus;
  final Value<DateTime?> lastSyncedAt;
  final Value<int> rowid;
  const VentasCompanion({
    this.id = const Value.absent(),
    this.monto = const Value.absent(),
    this.fecha = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.clienteNombre = const Value.absent(),
    this.concepto = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VentasCompanion.insert({
    required String id,
    required double monto,
    required DateTime fecha,
    this.clienteId = const Value.absent(),
    this.clienteNombre = const Value.absent(),
    this.concepto = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
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
    Expression<String>? concepto,
    Expression<String>? syncStatus,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (monto != null) 'monto': monto,
      if (fecha != null) 'fecha': fecha,
      if (clienteId != null) 'cliente_id': clienteId,
      if (clienteNombre != null) 'cliente_nombre': clienteNombre,
      if (concepto != null) 'concepto': concepto,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VentasCompanion copyWith({
    Value<String>? id,
    Value<double>? monto,
    Value<DateTime>? fecha,
    Value<String?>? clienteId,
    Value<String?>? clienteNombre,
    Value<String?>? concepto,
    Value<String>? syncStatus,
    Value<DateTime?>? lastSyncedAt,
    Value<int>? rowid,
  }) {
    return VentasCompanion(
      id: id ?? this.id,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      clienteId: clienteId ?? this.clienteId,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      concepto: concepto ?? this.concepto,
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
    if (concepto.present) {
      map['concepto'] = Variable<String>(concepto.value);
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
    return (StringBuffer('VentasCompanion(')
          ..write('id: $id, ')
          ..write('monto: $monto, ')
          ..write('fecha: $fecha, ')
          ..write('clienteId: $clienteId, ')
          ..write('clienteNombre: $clienteNombre, ')
          ..write('concepto: $concepto, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientesTable clientes = $ClientesTable(this);
  late final $ProveedoresTable proveedores = $ProveedoresTable(this);
  late final $ProductosTable productos = $ProductosTable(this);
  late final $MovimientosTable movimientos = $MovimientosTable(this);
  late final $VentasTable ventas = $VentasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    clientes,
    proveedores,
    productos,
    movimientos,
    ventas,
  ];
}

typedef $$ClientesTableCreateCompanionBuilder =
    ClientesCompanion Function({
      required String id,
      required String nombre,
      required String telefono,
      required String email,
      Value<bool> esFiado,
      Value<double> saldoPendiente,
      Value<bool> isActivo,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });
typedef $$ClientesTableUpdateCompanionBuilder =
    ClientesCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> telefono,
      Value<String> email,
      Value<bool> esFiado,
      Value<double> saldoPendiente,
      Value<bool> isActivo,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });

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
          (
            ClienteData,
            BaseReferences<_$AppDatabase, $ClientesTable, ClienteData>,
          ),
          ClienteData,
          PrefetchHooks Function()
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
                Value<String> email = const Value.absent(),
                Value<bool> esFiado = const Value.absent(),
                Value<double> saldoPendiente = const Value.absent(),
                Value<bool> isActivo = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientesCompanion(
                id: id,
                nombre: nombre,
                telefono: telefono,
                email: email,
                esFiado: esFiado,
                saldoPendiente: saldoPendiente,
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
                required String email,
                Value<bool> esFiado = const Value.absent(),
                Value<double> saldoPendiente = const Value.absent(),
                Value<bool> isActivo = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientesCompanion.insert(
                id: id,
                nombre: nombre,
                telefono: telefono,
                email: email,
                esFiado: esFiado,
                saldoPendiente: saldoPendiente,
                isActivo: isActivo,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (ClienteData, BaseReferences<_$AppDatabase, $ClientesTable, ClienteData>),
      ClienteData,
      PrefetchHooks Function()
    >;
typedef $$ProveedoresTableCreateCompanionBuilder =
    ProveedoresCompanion Function({
      required String id,
      required String nombre,
      required String telefono,
      required List<String> diasVisita,
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
      Value<bool> isActivo,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });

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
          (
            ProveedorData,
            BaseReferences<_$AppDatabase, $ProveedoresTable, ProveedorData>,
          ),
          ProveedorData,
          PrefetchHooks Function()
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
                Value<bool> isActivo = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProveedoresCompanion(
                id: id,
                nombre: nombre,
                telefono: telefono,
                diasVisita: diasVisita,
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
                Value<bool> isActivo = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProveedoresCompanion.insert(
                id: id,
                nombre: nombre,
                telefono: telefono,
                diasVisita: diasVisita,
                isActivo: isActivo,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (
        ProveedorData,
        BaseReferences<_$AppDatabase, $ProveedoresTable, ProveedorData>,
      ),
      ProveedorData,
      PrefetchHooks Function()
    >;
typedef $$ProductosTableCreateCompanionBuilder =
    ProductosCompanion Function({
      required String id,
      required String nombre,
      required int cantidad,
      required double precio,
      required String categoria,
      required String proveedorId,
      Value<int> stockMinimo,
      Value<String?> codigoBarras,
      Value<String?> codigoPersonalizado,
      Value<String?> proveedorNombre,
      Value<bool> isActivo,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });
typedef $$ProductosTableUpdateCompanionBuilder =
    ProductosCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<int> cantidad,
      Value<double> precio,
      Value<String> categoria,
      Value<String> proveedorId,
      Value<int> stockMinimo,
      Value<String?> codigoBarras,
      Value<String?> codigoPersonalizado,
      Value<String?> proveedorNombre,
      Value<bool> isActivo,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });

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

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proveedorId => $composableBuilder(
    column: $table.proveedorId,
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

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proveedorId => $composableBuilder(
    column: $table.proveedorId,
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

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<String> get proveedorId => $composableBuilder(
    column: $table.proveedorId,
    builder: (column) => column,
  );

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
          (
            ProductoData,
            BaseReferences<_$AppDatabase, $ProductosTable, ProductoData>,
          ),
          ProductoData,
          PrefetchHooks Function()
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
                Value<String> categoria = const Value.absent(),
                Value<String> proveedorId = const Value.absent(),
                Value<int> stockMinimo = const Value.absent(),
                Value<String?> codigoBarras = const Value.absent(),
                Value<String?> codigoPersonalizado = const Value.absent(),
                Value<String?> proveedorNombre = const Value.absent(),
                Value<bool> isActivo = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductosCompanion(
                id: id,
                nombre: nombre,
                cantidad: cantidad,
                precio: precio,
                categoria: categoria,
                proveedorId: proveedorId,
                stockMinimo: stockMinimo,
                codigoBarras: codigoBarras,
                codigoPersonalizado: codigoPersonalizado,
                proveedorNombre: proveedorNombre,
                isActivo: isActivo,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required int cantidad,
                required double precio,
                required String categoria,
                required String proveedorId,
                Value<int> stockMinimo = const Value.absent(),
                Value<String?> codigoBarras = const Value.absent(),
                Value<String?> codigoPersonalizado = const Value.absent(),
                Value<String?> proveedorNombre = const Value.absent(),
                Value<bool> isActivo = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductosCompanion.insert(
                id: id,
                nombre: nombre,
                cantidad: cantidad,
                precio: precio,
                categoria: categoria,
                proveedorId: proveedorId,
                stockMinimo: stockMinimo,
                codigoBarras: codigoBarras,
                codigoPersonalizado: codigoPersonalizado,
                proveedorNombre: proveedorNombre,
                isActivo: isActivo,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (
        ProductoData,
        BaseReferences<_$AppDatabase, $ProductosTable, ProductoData>,
      ),
      ProductoData,
      PrefetchHooks Function()
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
      Value<int?> cantidad,
      Value<bool> esFiado,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
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
      Value<int?> cantidad,
      Value<bool> esFiado,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });

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

  ColumnFilters<String> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clienteId => $composableBuilder(
    column: $table.clienteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proveedorId => $composableBuilder(
    column: $table.proveedorId,
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

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
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

  ColumnOrderings<String> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clienteId => $composableBuilder(
    column: $table.clienteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proveedorId => $composableBuilder(
    column: $table.proveedorId,
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

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
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

  GeneratedColumn<String> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clienteId =>
      $composableBuilder(column: $table.clienteId, builder: (column) => column);

  GeneratedColumn<String> get proveedorId => $composableBuilder(
    column: $table.proveedorId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<bool> get esFiado =>
      $composableBuilder(column: $table.esFiado, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );
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
          (
            MovimientoData,
            BaseReferences<_$AppDatabase, $MovimientosTable, MovimientoData>,
          ),
          MovimientoData,
          PrefetchHooks Function()
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
                Value<int?> cantidad = const Value.absent(),
                Value<bool> esFiado = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
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
                cantidad: cantidad,
                esFiado: esFiado,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
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
                Value<int?> cantidad = const Value.absent(),
                Value<bool> esFiado = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
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
                cantidad: cantidad,
                esFiado: esFiado,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (
        MovimientoData,
        BaseReferences<_$AppDatabase, $MovimientosTable, MovimientoData>,
      ),
      MovimientoData,
      PrefetchHooks Function()
    >;
typedef $$VentasTableCreateCompanionBuilder =
    VentasCompanion Function({
      required String id,
      required double monto,
      required DateTime fecha,
      Value<String?> clienteId,
      Value<String?> clienteNombre,
      Value<String?> concepto,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });
typedef $$VentasTableUpdateCompanionBuilder =
    VentasCompanion Function({
      Value<String> id,
      Value<double> monto,
      Value<DateTime> fecha,
      Value<String?> clienteId,
      Value<String?> clienteNombre,
      Value<String?> concepto,
      Value<String> syncStatus,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });

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

  ColumnFilters<String> get clienteId => $composableBuilder(
    column: $table.clienteId,
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

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
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

  ColumnOrderings<String> get clienteId => $composableBuilder(
    column: $table.clienteId,
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

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
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

  GeneratedColumn<String> get clienteId =>
      $composableBuilder(column: $table.clienteId, builder: (column) => column);

  GeneratedColumn<String> get clienteNombre => $composableBuilder(
    column: $table.clienteNombre,
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
          (VentaData, BaseReferences<_$AppDatabase, $VentasTable, VentaData>),
          VentaData,
          PrefetchHooks Function()
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
                Value<String?> concepto = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VentasCompanion(
                id: id,
                monto: monto,
                fecha: fecha,
                clienteId: clienteId,
                clienteNombre: clienteNombre,
                concepto: concepto,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required double monto,
                required DateTime fecha,
                Value<String?> clienteId = const Value.absent(),
                Value<String?> clienteNombre = const Value.absent(),
                Value<String?> concepto = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VentasCompanion.insert(
                id: id,
                monto: monto,
                fecha: fecha,
                clienteId: clienteId,
                clienteNombre: clienteNombre,
                concepto: concepto,
                syncStatus: syncStatus,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (VentaData, BaseReferences<_$AppDatabase, $VentasTable, VentaData>),
      VentaData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
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
}
