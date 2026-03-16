import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';

part 'database.g.dart';

@DataClassName('ClienteData')
class Clientes extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get telefono => text()();
  TextColumn get email => text()();
  BoolColumn get esFiado => boolean().withDefault(const Constant(false))();
  RealColumn get saldoPendiente => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ProveedorData')
class Proveedores extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get telefono => text()();
  TextColumn get diasVisita => text().map(const StringListConverter())();

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
  IntColumn get stockMinimo => integer().withDefault(const Constant(5))();
  TextColumn get codigoBarras => text().nullable()();
  TextColumn get codigoPersonalizado => text().nullable()();
  TextColumn get proveedorNombre => text().nullable()();

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
  IntColumn get cantidad => integer().nullable()();
  BoolColumn get esFiado => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('VentaData')
class Ventas extends Table {
  TextColumn get id => text()();
  RealColumn get monto => real()();
  DateTimeColumn get fecha => dateTime()();
  TextColumn get clienteId => text().nullable()();
  TextColumn get clienteNombre => text().nullable()();
  TextColumn get concepto => text().nullable()();

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

@DriftDatabase(tables: [Clientes, Proveedores, Productos, Movimientos, Ventas])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(productos, productos.codigoPersonalizado);
      }
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
