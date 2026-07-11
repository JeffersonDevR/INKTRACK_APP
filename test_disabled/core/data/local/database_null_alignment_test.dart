import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:InkTrack/core/data/local/database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Database — nullable attribute alignment', () {
    test('ClienteData.telefono defaults to null when omitted', () async {
      await db.into(db.clientes).insert(ClientesCompanion.insert(
        id: 'cli-null-test',
        nombre: 'Sin Telefono',
      ));

      final row = await db.select(db.clientes).getSingle();
      expect(row.telefono, isNull,
          reason: 'Clientes.telefono must default to null when omitted');
    });

    test('ClienteData.telefono stores non-null value', () async {
      await db.into(db.clientes).insert(ClientesCompanion.insert(
        id: 'cli-ph-test',
        nombre: 'Con Telefono',
        telefono: const Value<String?>('555-1234'),
      ));

      final row = await db.select(db.clientes).getSingle();
      expect(row.telefono, '555-1234',
          reason: 'Clientes.telefono must store non-null values');
    });

    test('ProveedorData.telefono defaults to null when omitted', () async {
      await db.into(db.proveedores).insert(ProveedoresCompanion.insert(
        id: 'prov-null-test',
        nombre: 'Sin Telefono',
        diasVisita: ['Lunes', 'Viernes'],
      ));

      final row = await db.select(db.proveedores).getSingle();
      expect(row.telefono, isNull,
          reason: 'Proveedores.telefono must default to null when omitted');
    });

    test('ProveedorData.telefono stores non-null value', () async {
      await db.into(db.proveedores).insert(ProveedoresCompanion.insert(
        id: 'prov-ph-test',
        nombre: 'Con Telefono',
        telefono: const Value<String?>('555-5678'),
        diasVisita: ['Lunes'],
      ));

      final row = await db.select(db.proveedores).getSingle();
      expect(row.telefono, '555-5678',
          reason: 'Proveedores.telefono must store non-null values');
    });

    test('PedidoProveedorData.fechaEntrega defaults to null when omitted',
        () async {
      final now = DateTime.now();
      await db.into(db.pedidosProveedor).insert(
        PedidosProveedorCompanion.insert(
          id: 'ped-null-test',
          proveedorId: 'prov-1',
          fechaPedido: now,
          productos: '[]',
          montoTotal: 0.0,
        ),
      );

      final row = await db.select(db.pedidosProveedor).getSingle();
      expect(row.fechaEntrega, isNull,
          reason: 'PedidosProveedor.fechaEntrega must default to null when omitted');
    });

    test('PedidoProveedorData.fechaEntrega stores non-null value', () async {
      final now = DateTime.now();
      await db.into(db.pedidosProveedor).insert(
        PedidosProveedorCompanion.insert(
          id: 'ped-date-test',
          proveedorId: 'prov-2',
          fechaPedido: now,
          fechaEntrega: Value<DateTime?>(now.add(const Duration(days: 7))),
          productos: '[]',
          montoTotal: 500.0,
        ),
      );

      final row = await db.select(db.pedidosProveedor).getSingle();
      expect(row.fechaEntrega, isNotNull,
          reason: 'PedidosProveedor.fechaEntrega must store non-null values');
    });
  });
}
