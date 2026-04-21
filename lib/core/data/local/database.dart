import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';

part 'database.g.dart';

@DataClassName('LocalData')
class Locales extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get direccion => text().nullable()();
  TextColumn get telefono => text().nullable()();
  TextColumn get tipo => text().withDefault(const Constant('tienda'))();
  BoolColumn get isActivo => boolean().withDefault(const Constant(true))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ClienteData')
class Clientes extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get telefono => text()();
  TextColumn get email => text().nullable()();
  TextColumn get localId => text().nullable()();
  BoolColumn get esFiado => boolean().withDefault(const Constant(false))();
  RealColumn get saldoPendiente => real().withDefault(const Constant(0.0))();
  BoolColumn get isActivo => boolean().withDefault(const Constant(true))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ProveedorData')
class Proveedores extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get telefono => text()();
  TextColumn get diasVisita => text().map(const StringListConverter())();
  TextColumn get localId => text().nullable()();
  BoolColumn get isActivo => boolean().withDefault(const Constant(true))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ProductoData')
class Productos extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  IntColumn get cantidad => integer()();
  RealColumn get precio => real()();
  TextColumn get categoria => text()();
  TextColumn get proveedorId => text()();
  TextColumn get localId => text().nullable()();
  IntColumn get stockMinimo => integer().withDefault(const Constant(5))();
  TextColumn get codigoBarras => text().nullable()();
  TextColumn get codigoPersonalizado => text().nullable()();
  TextColumn get proveedorNombre => text().nullable()();
  BoolColumn get isActivo => boolean().withDefault(const Constant(true))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MovimientoData')
class Movimientos extends Table {
  TextColumn get id => text()();
  RealColumn get monto => real()();
  DateTimeColumn get fecha => dateTime()();
  IntColumn get tipo => intEnum<MovimientoType>()();
  TextColumn get concepto => text()();
  TextColumn get categoria => text().nullable()();
  TextColumn get productoId => text().nullable()();
  TextColumn get clienteId => text().nullable()();
  TextColumn get proveedorId => text().nullable()();
  TextColumn get localId => text().nullable()();
  IntColumn get cantidad => integer().nullable()();
  BoolColumn get esFiado => boolean().withDefault(const Constant(false))();
  TextColumn get productosJson => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [];
}

@DataClassName('VentaData')
class Ventas extends Table {
  TextColumn get id => text()();
  RealColumn get monto => real()();
  DateTimeColumn get fecha => dateTime()();
  TextColumn get clienteId => text().nullable()();
  TextColumn get clienteNombre => text().nullable()();
  TextColumn get localId => text().nullable()();
  TextColumn get concepto => text().nullable()();
  TextColumn get productosJson => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PedidoProveedorData')
class PedidosProveedor extends Table {
  TextColumn get id => text()();
  TextColumn get proveedorId => text()();
  TextColumn get proveedorNombre => text().nullable()();
  TextColumn get localId => text().nullable()();
  DateTimeColumn get fechaPedido => dateTime()();
  DateTimeColumn get fechaEntrega => dateTime()();
  TextColumn get productos => text()();
  RealColumn get montoTotal => real()();
  BoolColumn get isEntregado => boolean().withDefault(const Constant(false))();
  TextColumn get notas => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    return fromDb.isEmpty ? [] : fromDb.split(',');
  }

  @override
  String toSql(List<String> value) {
    return value.join(',');
  }
}

@DriftDatabase(
  tables: [
    Locales,
    Clientes,
    Proveedores,
    Productos,
    Movimientos,
    Ventas,
    PedidosProveedor,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      debugPrint("Migrating from $from to $to");
      try {
        if (from < 2) {
          await m.addColumn(productos, productos.codigoPersonalizado);
        }
      } catch (e) {
        debugPrint("Migration v2 skip: $e");
      }
      try {
        if (from < 3) {
          await m.addColumn(productos, productos.isActivo);
          await m.addColumn(clientes, clientes.isActivo);
          await m.addColumn(proveedores, proveedores.isActivo);
        }
      } catch (e) {
        debugPrint("Migration v3 skip: $e");
      }
      try {
        if (from < 4) {
          await m.addColumn(productos, productos.syncStatus);
          await m.addColumn(productos, productos.lastSyncedAt);
          await m.addColumn(clientes, clientes.syncStatus);
          await m.addColumn(clientes, clientes.lastSyncedAt);
          await m.addColumn(proveedores, proveedores.syncStatus);
          await m.addColumn(proveedores, proveedores.lastSyncedAt);
          await m.addColumn(movimientos, movimientos.syncStatus);
          await m.addColumn(movimientos, movimientos.lastSyncedAt);
          await m.addColumn(ventas, ventas.syncStatus);
          await m.addColumn(ventas, ventas.lastSyncedAt);
        }
      } catch (e) {
        debugPrint("Migration v4 skip: $e");
      }
      try {
        if (from < 5) {
          await m.createTable(pedidosProveedor);
        }
      } catch (e) {
        debugPrint("Migration v5 skip: $e");
      }
      try {
        if (from < 6) {
          await m.addColumn(ventas, ventas.productosJson);
        }
      } catch (e) {
        debugPrint("Migration v6 skip: $e");
      }
      try {
        if (from < 7) {
          await m.addColumn(movimientos, movimientos.productosJson);
        }
      } catch (e) {
        debugPrint("Migration v7 skip: $e");
      }
      try {
        if (from < 9) {
          await m.createTable(locales);
        }
      } catch (e) {
        debugPrint("Migration v9 skip: $e");
      }
      try {
        if (from < 9) {
          await m.addColumn(productos, productos.localId);
          await m.addColumn(clientes, clientes.localId);
          await m.addColumn(proveedores, proveedores.localId);
        }
      } catch (e) {
        debugPrint("Migration v9 columns skip: $e");
      }
      try {
        if (from < 10) {
          await m.addColumn(movimientos, movimientos.localId);
          await m.addColumn(ventas, ventas.localId);
          await m.addColumn(pedidosProveedor, pedidosProveedor.localId);
        }
      } catch (e) {
        debugPrint("Migration v10 skip: $e");
      }
    },
    beforeOpen: (details) async {
      debugPrint(
        "Database opened: ${details.versionBefore} -> ${details.versionNow}",
      );
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
