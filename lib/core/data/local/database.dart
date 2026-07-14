import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:drift/native.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/core/data/local/database_path_resolver.dart';

part 'database.g.dart';

@DataClassName('LocalData')
class Locales extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get direccion => text().nullable()();
  TextColumn get telefono => text().nullable()();
  TextColumn get tipo => text().withDefault(const Constant('tienda'))();
  TextColumn get userId => text().nullable()();
  BoolColumn get isActivo => boolean().withDefault(const Constant(true))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ClienteData')
class Clientes extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get telefono => text()();
  TextColumn get email => text().nullable()();
  TextColumn get localId => text().nullable().references(Locales, #id)();
  BoolColumn get esFiado => boolean().withDefault(const Constant(false))();
  RealColumn get saldoPendiente => real().withDefault(const Constant(0.0))();
  BoolColumn get isActivo => boolean().withDefault(const Constant(true))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  RealColumn get limiteCredito => real().nullable()();
  DateTimeColumn get promesaPago => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ProveedorData')
class Proveedores extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get telefono => text()();
  TextColumn get diasVisita => text().map(const StringListConverter())();
  IntColumn get periodoVisita => integer().nullable()();
  DateTimeColumn get ultimaVisita => dateTime().nullable()();
  DateTimeColumn get proximaVisita => dateTime().nullable()();
  TextColumn get localId => text().nullable().references(Locales, #id)();
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
  RealColumn get precioCompra => real().nullable()();
  IntColumn get unidadesPorPaquete =>
      integer().withDefault(const Constant(1))();
  BoolColumn get esPaquete => boolean().withDefault(const Constant(false))();
  TextColumn get categoria => text()();
  TextColumn get proveedorId => text().references(Proveedores, #id)();
  TextColumn get localId => text().nullable().references(Locales, #id)();
  IntColumn get stockMinimo => integer().withDefault(const Constant(5))();
  TextColumn get codigoBarras => text().nullable()();
  TextColumn get codigoPersonalizado => text().nullable()();
  TextColumn get proveedorNombre => text().nullable()();
  BoolColumn get isActivo => boolean().withDefault(const Constant(true))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get unidad => text().withDefault(const Constant('unidad'))();

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
  TextColumn get productoId => text().nullable().references(Productos, #id)();
  TextColumn get clienteId => text().nullable().references(Clientes, #id)();
  TextColumn get proveedorId =>
      text().nullable().references(Proveedores, #id)();
  TextColumn get localId => text().nullable().references(Locales, #id)();
  IntColumn get cantidad => integer().nullable()();
  BoolColumn get esFiado => boolean().withDefault(const Constant(false))();
  TextColumn get productosJson => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

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
  TextColumn get clienteId => text().nullable().references(Clientes, #id)();
  TextColumn get clienteNombre => text().nullable()();
  TextColumn get localId => text().nullable().references(Locales, #id)();
  TextColumn get concepto => text().nullable()();
  TextColumn get productosJson => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  BoolColumn get esFiado => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PedidoProveedorData')
class PedidosProveedor extends Table {
  TextColumn get id => text()();
  TextColumn get proveedorId => text().references(Proveedores, #id)();
  TextColumn get proveedorNombre => text().nullable()();
  TextColumn get localId => text().nullable().references(Locales, #id)();
  DateTimeColumn get fechaPedido => dateTime()();
  DateTimeColumn get fechaEntrega => dateTime()();
  TextColumn get productos => text()();
  RealColumn get montoTotal => real()();
  BoolColumn get isEntregado => boolean().withDefault(const Constant(false))();
  TextColumn get notas => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalUserData')
class LocalUsers extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get hashedPassword => text()();
  DateTimeColumn get lastLogin => dateTime()();
  TextColumn get pinHash => text().nullable()();
  TextColumn get rol => text().withDefault(const Constant('vendedor'))();

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

@DataClassName('AbonoData')
class Abonos extends Table {
  TextColumn get id => text()();
  TextColumn get clienteId => text().references(Clientes, #id)();
  TextColumn get ventaId => text().nullable().references(Ventas, #id)();
  RealColumn get monto => real()();
  DateTimeColumn get fecha => dateTime()();
  RealColumn get saldoRestante => real()();
  TextColumn get concepto => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending_upload'))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
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
    LocalUsers,
    Abonos,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Creates an in-memory database for testing.
  AppDatabase.fromConnection(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 19;

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
      try {
        if (from < 11) {
          await m.addColumn(locales, locales.userId);
        }
      } catch (e) {
        debugPrint("Migration v11 skip: $e");
      }
      // Note: Migration v12 temporarily disabled - build_runner needs to regenerate
      // try {
      //   if (from < 12) {
      //     await m.addColumn(productos, productos.precioCompra);
      //     await m.addColumn(productos, productos.unidadesPorPaquete);
      //     await m.addColumn(productos, productos.esPaquete);
      //     await m.addColumn(proveedores, proveedores.periodoVisita);
      //     await m.addColumn(proveedores, proveedores.ultimaVisita);
      //     await m.addColumn(proveedores, proveedores.proximaVisita);
      //   }
      // } catch (e) {
      //   debugPrint("Migration v12 skip: $e");
      // }
      try {
        if (from < 13) {
          // Temporarily commented out to allow build_runner to run
          /*
          await m.addColumn(productos, productos.precioCompra);
          await m.addColumn(productos, productos.unidadesPorPaquete);
          await m.addColumn(productos, productos.esPaquete);
          await m.addColumn(proveedores, proveedores.periodoVisita);
          await m.addColumn(proveedores, proveedores.ultimaVisita);
          await m.addColumn(proveedores, proveedores.proximaVisita);
          */
        }
      } catch (e) {
        debugPrint("Migration v13 skip: $e");
      }
      try {
        if (from < 14) {
          await m.createTable(localUsers);
        }
      } catch (e) {
        debugPrint("Migration v14 skip: $e");
      }
      try {
        if (from < 15) {
          // Recreate tables to add foreign key constraints.
          // Order matters: parents must exist before children.
          await m.alterTable(TableMigration(locales));
          await m.alterTable(TableMigration(localUsers));
          await m.alterTable(TableMigration(clientes));
          await m.alterTable(TableMigration(proveedores));
          await m.alterTable(TableMigration(productos));
          await m.alterTable(TableMigration(movimientos));
          await m.alterTable(TableMigration(ventas));
          await m.alterTable(TableMigration(pedidosProveedor));
        }
      } catch (e) {
        debugPrint("Migration v15 skip: $e");
      }
      if (from < 16) {
        await m.addColumn(productos, productos.updatedAt);
        await m.addColumn(productos, productos.unidad);
      }
      if (from < 17) {
        await m.addColumn(clientes, clientes.updatedAt);
        await m.addColumn(movimientos, movimientos.updatedAt);
        await m.addColumn(ventas, ventas.updatedAt);
        await m.addColumn(locales, locales.updatedAt);
        await m.addColumn(pedidosProveedor, pedidosProveedor.updatedAt);
      }
      if (from < 18) {
        await m.createTable(abonos);
        await m.addColumn(clientes, clientes.limiteCredito);
        await m.addColumn(clientes, clientes.promesaPago);
        await m.addColumn(ventas, ventas.esFiado);
        await m.addColumn(localUsers, localUsers.pinHash);
        await m.addColumn(localUsers, localUsers.rol);
      }
      // v18 → v19: data-only JSON backfill — add `recibido=0` to every
      // PedidoProducto line where the field is absent. No DDL change.
      // Throws on decode failure (ADR-12 — no silent swallow).
      if (from < 19) {
        final rows = await customSelect('SELECT id, productos FROM pedidos_proveedor').get();
        for (final row in rows) {
          final id = row.read<String>('id');
          final productosStr = row.read<String>('productos');
          List<dynamic> productosList;
          try {
            productosList = jsonDecode(productosStr) as List<dynamic>;
          } catch (e) {
            throw Exception(
              'Migration v19 failed: could not decode productos JSON for pedido $id: $e',
            );
          }
          final backfilled = productosList.map((p) {
            final map = Map<String, dynamic>.from(p as Map);
            map.putIfAbsent('recibido', () => 0);
            return map;
          }).toList();
          final encoded = jsonEncode(backfilled);
          await customStatement(
            'UPDATE pedidos_proveedor SET productos = ? WHERE id = ?',
            [encoded, id],
          );
        }
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
    final file = await DatabasePathResolver.resolve();
    return NativeDatabase(
      file,
      setup: (rawDb) {
        rawDb.execute('PRAGMA foreign_keys = ON;');
      },
    );
  });
}

/// Copies the SQLite database file to [targetPath].
///
/// Useful for inspecting the database with external tools such as DBeaver.
/// The target directory is created if needed. Returns the copied [File].
Future<File> exportDatabaseTo(String targetPath) async {
  final currentFile = await DatabasePathResolver.resolve();
  final targetFile = File(targetPath);
  final targetDir = targetFile.parent;
  if (!targetDir.existsSync()) {
    targetDir.createSync(recursive: true);
  }
  await currentFile.copy(targetFile.path);
  debugPrint('[AppDatabase] Exported SQLite to ${targetFile.absolute.path}');
  return targetFile;
}
