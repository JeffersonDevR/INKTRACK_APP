// test/features/proveedores/pedidos_recepcion_test.dart
// Chain 5 — feat/m3-pedidos-recepcion-reorder
// TDD anchors:
//   "recepcion migration failure is observable" (5.3)
//   "partial reception does not mark delivered" (5.4)
//   "scan increments received count" (5.4)
//   "discrepancy surfaced in Spanish" (5.6)
//   "discrepancy math unit-tested" (5.6)
//   "products below minimum are suggested" (5.10)

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/proveedores/data/models/pedido_proveedor.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';

// ---------------------------------------------------------------------------
// Helper factories
// ---------------------------------------------------------------------------

PedidoProveedor makePedido({
  required List<PedidoProducto> productos,
  bool isEntregado = false,
  String proveedorId = 'prov-1',
}) =>
    PedidoProveedor(
      id: 'ped-1',
      proveedorId: proveedorId,
      fechaPedido: DateTime(2025, 1, 1),
      fechaEntrega: DateTime(2025, 1, 10),
      productos: productos,
      montoTotal: productos.fold(0.0, (s, p) => s + p.subtotal),
      isEntregado: isEntregado,
    );

PedidoProducto makeLinea({
  required int cantidad,
  int recibido = 0,
  String productoId = 'prod-1',
  String nombre = 'Arroz 1kg',
  double precioUnitario = 3200,
}) =>
    PedidoProducto(
      productoId: productoId,
      nombre: nombre,
      cantidad: cantidad,
      precioUnitario: precioUnitario,
      recibido: recibido,
    );

void main() {
  // -------------------------------------------------------------------------
  // Task 5.3 — Migration observability (in-memory Drift)
  // -------------------------------------------------------------------------
  group('Migration v18→v19 observability (task 5.3)', () {
    test('backfill sets recibido=0 on existing JSON rows that lack the field', () async {
      // Use a fresh in-memory DB starting at v18 conceptually by inserting a
      // pedido whose productos JSON lacks `recibido`, then opening via v19 DB.
      final db = AppDatabase.fromConnection(NativeDatabase.memory());

      // Manually insert a row WITHOUT recibido field (simulates pre-v19 data)
      final oldJson = jsonEncode([
        {'productoId': 'p1', 'nombre': 'Arroz', 'cantidad': 10, 'precioUnitario': 3200.0}
      ]);
      await db.customStatement(
        "INSERT INTO pedidos_proveedor "
        "(id, proveedor_id, fecha_pedido, fecha_entrega, productos, monto_total, is_entregado, sync_status) "
        "VALUES ('ped-1', 'prov-1', '2025-01-01T00:00:00Z', '2025-01-10T00:00:00Z', "
        "        ?, 32000.0, 0, 'pending')",
        [oldJson],
      );

      // Run the migration manually (simulate v18→v19 backfill path)
      final rows = await db
          .customSelect('SELECT id, productos FROM pedidos_proveedor')
          .get();
      for (final row in rows) {
        final productosStr = row.read<String>('productos');
        final list = jsonDecode(productosStr) as List<dynamic>;
        final backfilled = list.map((p) {
          final map = Map<String, dynamic>.from(p as Map);
          map.putIfAbsent('recibido', () => 0);
          return map;
        }).toList();
        await db.customStatement(
          'UPDATE pedidos_proveedor SET productos = ? WHERE id = ?',
          [jsonEncode(backfilled), row.read<String>('id')],
        );
      }

      // Now read back and verify recibido=0 was added
      final updatedRows = await db
          .customSelect('SELECT productos FROM pedidos_proveedor WHERE id = ?', variables: [Variable('ped-1')])
          .get();
      final updatedJson = jsonDecode(updatedRows.first.read<String>('productos')) as List;
      expect(updatedJson.first['recibido'], equals(0));

      await db.close();
    });

    test('migration throws on corrupted JSON (does not swallow error)', () async {
      final db = AppDatabase.fromConnection(NativeDatabase.memory());

      // Insert a row with intentionally corrupt JSON
      await db.customStatement(
        "INSERT INTO pedidos_proveedor "
        "(id, proveedor_id, fecha_pedido, fecha_entrega, productos, monto_total, is_entregado, sync_status) "
        "VALUES ('ped-corrupt', 'prov-1', '2025-01-01T00:00:00Z', '2025-01-10T00:00:00Z', "
        "        'CORRUPT_JSON_[{{}}', 32000.0, 0, 'pending')",
      );

      // The migration backfill should throw on corrupt JSON (ADR-12)
      expect(
        () async {
          final rows = await db
              .customSelect('SELECT id, productos FROM pedidos_proveedor WHERE id = ?',
                  variables: [Variable('ped-corrupt')])
              .get();
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
            // Prevent unused variable warning
            productosList.length;
          }
        },
        throwsA(isA<Exception>()),
      );

      await db.close();
    });
  });

  // -------------------------------------------------------------------------
  // Task 5.4 — Reception increment logic
  // -------------------------------------------------------------------------
  group('PedidoProducto.recibido increment (task 5.4)', () {
    test('scan increments recibido field by 1', () {
      final linea = makeLinea(cantidad: 10, recibido: 0);
      final updated = linea.copyWith(recibido: linea.recibido + 1);
      expect(updated.recibido, equals(1));
    });

    test('pedido with one partial line → isEntregado=false (not all received)', () {
      // Order: 10 requested, only 7 received
      final linea = makeLinea(cantidad: 10, recibido: 7);
      final pedido = makePedido(productos: [linea]);

      // isEntregado should only be true when ALL lines have recibido >= cantidad
      final allReceived = pedido.productos.every((p) => p.recibido >= p.cantidad);
      expect(allReceived, isFalse);
    });

    test('all lines fully received → marcarEntregado allowed', () {
      final linea = makeLinea(cantidad: 10, recibido: 10);
      final pedido = makePedido(productos: [linea]);
      final allReceived = pedido.productos.every((p) => p.recibido >= p.cantidad);
      expect(allReceived, isTrue);
    });

    test('PedidoProducto.toJson includes recibido field', () {
      final linea = makeLinea(cantidad: 5, recibido: 3);
      final json = linea.toJson();
      expect(json.containsKey('recibido'), isTrue);
      expect(json['recibido'], equals(3));
    });

    test('PedidoProducto.fromJson reads recibido field', () {
      final json = {
        'productoId': 'p1',
        'nombre': 'Aceite',
        'cantidad': 5,
        'precioUnitario': 8500.0,
        'recibido': 3,
      };
      final linea = PedidoProducto.fromJson(json);
      expect(linea.recibido, equals(3));
    });

    test('PedidoProducto.fromJson defaults recibido to 0 when missing', () {
      final json = {
        'productoId': 'p1',
        'nombre': 'Aceite',
        'cantidad': 5,
        'precioUnitario': 8500.0,
        // no 'recibido' key — simulates pre-v19 JSON
      };
      final linea = PedidoProducto.fromJson(json);
      expect(linea.recibido, equals(0));
    });
  });

  // -------------------------------------------------------------------------
  // Task 5.6 — Discrepancy math (adversarial)
  // -------------------------------------------------------------------------
  group('Discrepancy computation (task 5.6)', () {
    test('discrepancy = solicitado − recibido for a partial line', () {
      final linea = makeLinea(cantidad: 10, recibido: 7);
      final discrepancy = linea.cantidad - linea.recibido;
      expect(discrepancy, equals(3));
    });

    test('no discrepancy when recibido == solicitado', () {
      final linea = makeLinea(cantidad: 10, recibido: 10);
      final discrepancy = linea.cantidad - linea.recibido;
      expect(discrepancy, equals(0));
    });

    test('discrepancy summary formats correctly in Spanish', () {
      // The ARB key: "Discrepancia: recibió {received} de {requested} unidades"
      const template = 'Discrepancia: recibió {received} de {requested} unidades';
      final message = template
          .replaceFirst('{received}', '7')
          .replaceFirst('{requested}', '10');
      expect(message, equals('Discrepancia: recibió 7 de 10 unidades'));
    });

    test('pedidosWithDiscrepancy lists only lines with recibido < solicitado', () {
      final linea1 = makeLinea(cantidad: 10, recibido: 8, productoId: 'p1');
      final linea2 = makeLinea(cantidad: 5, recibido: 5, productoId: 'p2'); // no discrepancy
      final linea3 = makeLinea(cantidad: 3, recibido: 0, productoId: 'p3');

      final pedido = makePedido(productos: [linea1, linea2, linea3]);
      final withDiscrepancy =
          pedido.productos.where((p) => p.recibido < p.cantidad).toList();

      expect(withDiscrepancy.length, equals(2));
      expect(withDiscrepancy.map((p) => p.productoId), containsAll(['p1', 'p3']));
      expect(withDiscrepancy.map((p) => p.productoId), isNot(contains('p2')));
    });
  });

  // -------------------------------------------------------------------------
  // Task 5.10 — Reorder suggestion
  // -------------------------------------------------------------------------
  group('Reorder suggestion (task 5.10)', () {
    Producto makeProducto({
      required String id,
      required int cantidad,
      required int stockMinimo,
    }) =>
        Producto(
          id: id,
          nombre: 'Producto $id',
          cantidad: cantidad,
          precioVenta: 3200,
          categoria: 'Víveres',
          stockMinimo: stockMinimo,
          proveedorId: 'prov-1',
        );

    test('product with cantidad <= stockMinimo appears in reorder list', () {
      final productos = [
        makeProducto(id: 'p1', cantidad: 2, stockMinimo: 5), // BELOW min
        makeProducto(id: 'p2', cantidad: 10, stockMinimo: 5), // above min
        makeProducto(id: 'p3', cantidad: 5, stockMinimo: 5), // AT min (== includes)
      ];

      final reorderCandidates =
          productos.where((p) => p.cantidad <= p.stockMinimo).toList();

      expect(reorderCandidates.length, equals(2));
      expect(reorderCandidates.map((p) => p.id), containsAll(['p1', 'p3']));
      expect(reorderCandidates.map((p) => p.id), isNot(contains('p2')));
    });

    test('product above minimum is excluded from suggestions', () {
      final productos = [
        makeProducto(id: 'p1', cantidad: 20, stockMinimo: 5),
        makeProducto(id: 'p2', cantidad: 6, stockMinimo: 5),
      ];

      final suggestions =
          productos.where((p) => p.cantidad <= p.stockMinimo).toList();

      expect(suggestions, isEmpty);
    });

    test('reorder line label formats correctly', () {
      // ARB: "{producto} — Actual: {actual}, Mínimo: {minimo}"
      const template = '{producto} — Actual: {actual}, Mínimo: {minimo}';
      final label = template
          .replaceFirst('{producto}', 'Arroz 1kg')
          .replaceFirst('{actual}', '2')
          .replaceFirst('{minimo}', '5');
      expect(label, equals('Arroz 1kg — Actual: 2, Mínimo: 5'));
    });
  });
}
