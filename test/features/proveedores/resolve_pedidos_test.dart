// test/features/proveedores/resolve_pedidos_test.dart
// Chain 5 — feat/m3-pedidos-recepcion-reorder
// TDD anchors:
//   "pedidos header server-wins" (5.12)
//   "reception line LWW" (5.12)
//   "reception progress preserved across devices" (5.12)

import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/core/services/sync/conflict_resolver.dart';
import 'package:InkTrack/features/proveedores/data/models/pedido_proveedor.dart';

PedidoProveedor makePedido({
  required String id,
  required String proveedorId,
  required List<PedidoProducto> productos,
  bool isEntregado = false,
  DateTime? updatedAt,
  String? notas,
}) =>
    PedidoProveedor(
      id: id,
      proveedorId: proveedorId,
      fechaPedido: DateTime(2025, 1, 1),
      fechaEntrega: DateTime(2025, 1, 10),
      productos: productos,
      montoTotal: productos.fold(0.0, (s, p) => s + p.subtotal),
      isEntregado: isEntregado,
      updatedAt: updatedAt,
      notas: notas,
    );

PedidoProducto makeLinea({
  required String productoId,
  required int cantidad,
  int recibido = 0,
}) =>
    PedidoProducto(
      productoId: productoId,
      nombre: 'Producto $productoId',
      cantidad: cantidad,
      precioUnitario: 3200,
      recibido: recibido,
    );

void main() {
  group('ConflictResolver.resolvePedidos (task 5.12 adversarial)', () {
    final t1 = DateTime(2025, 1, 5, 10, 0, 0);
    final t2 = DateTime(2025, 1, 6, 10, 0, 0); // newer

    final linea = makeLinea(productoId: 'prod-1', cantidad: 10);

    test('header differs → server header prevails (server-wins header)', () {
      final localPedido = makePedido(
        id: 'ped-1',
        proveedorId: 'prov-1',
        productos: [linea],
        notas: 'Local notes',
        updatedAt: t1,
      );
      final serverPedido = makePedido(
        id: 'ped-1',
        proveedorId: 'prov-1',
        productos: [linea],
        notas: 'Server notes (newer)',
        updatedAt: t2, // server is newer
      );

      final resolved = ConflictResolver.resolvePedidos(localPedido, serverPedido);

      // Server header (notas) should win
      expect(resolved.notas, equals('Server notes (newer)'));
    });

    test('local header newer than server → local header wins', () {
      final localPedido = makePedido(
        id: 'ped-1',
        proveedorId: 'prov-1',
        productos: [linea],
        notas: 'Local notes (newer)',
        updatedAt: t2, // local is newer
      );
      final serverPedido = makePedido(
        id: 'ped-1',
        proveedorId: 'prov-1',
        productos: [linea],
        notas: 'Server notes',
        updatedAt: t1,
      );

      final resolved = ConflictResolver.resolvePedidos(localPedido, serverPedido);

      // Local header wins because it's newer
      expect(resolved.notas, equals('Local notes (newer)'));
    });

    test('reception line LWW: device2 (t2) recibido=5 beats device1 (t1) recibido=3', () {
      // device1 scanned 3 items at t1
      final lineaDevice1 = PedidoProducto(
        productoId: 'prod-1',
        nombre: 'Arroz',
        cantidad: 10,
        precioUnitario: 3200,
        recibido: 3,
      );
      // device2 scanned 5 items at t2 (newer)
      final lineaDevice2 = PedidoProducto(
        productoId: 'prod-1',
        nombre: 'Arroz',
        cantidad: 10,
        precioUnitario: 3200,
        recibido: 5,
      );

      final localPedido = makePedido(
        id: 'ped-1',
        proveedorId: 'prov-1',
        productos: [lineaDevice1],
        updatedAt: t1,
      );
      final serverPedido = makePedido(
        id: 'ped-1',
        proveedorId: 'prov-1',
        productos: [lineaDevice2],
        updatedAt: t2, // server has newer reception
      );

      final resolved = ConflictResolver.resolvePedidos(localPedido, serverPedido);

      // LWW on updatedAt: server (t2 > t1) recibido=5 should prevail
      expect(resolved.productos.first.recibido, equals(5));
    });

    test('local reception progress preserved against stale server header', () {
      // Local has newer reception progress (e.g., device scanned while offline)
      final lineaLocalAdvanced = PedidoProducto(
        productoId: 'prod-1',
        nombre: 'Arroz',
        cantidad: 10,
        precioUnitario: 3200,
        recibido: 8, // local scanned more
      );
      final lineaServer = PedidoProducto(
        productoId: 'prod-1',
        nombre: 'Arroz',
        cantidad: 10,
        precioUnitario: 3200,
        recibido: 2, // server has stale reception
      );

      final localPedido = makePedido(
        id: 'ped-1',
        proveedorId: 'prov-1',
        productos: [lineaLocalAdvanced],
        updatedAt: t2, // local is newer → its recibido should win
      );
      final serverPedido = makePedido(
        id: 'ped-1',
        proveedorId: 'prov-1',
        productos: [lineaServer],
        updatedAt: t1, // server is older
      );

      final resolved = ConflictResolver.resolvePedidos(localPedido, serverPedido);

      // Local recibido=8 (t2) beats server recibido=2 (t1)
      expect(resolved.productos.first.recibido, equals(8));
    });

    test('both null updatedAt → server wins (safe default)', () {
      final localPedido = makePedido(
        id: 'ped-1',
        proveedorId: 'prov-1',
        productos: [linea],
        notas: 'Local',
        updatedAt: null,
      );
      final serverPedido = makePedido(
        id: 'ped-1',
        proveedorId: 'prov-1',
        productos: [linea],
        notas: 'Server',
        updatedAt: null,
      );

      final resolved = ConflictResolver.resolvePedidos(localPedido, serverPedido);

      // When both null → server wins by convention
      expect(resolved.notas, equals('Server'));
    });

    test('resolved pedido preserves product count', () {
      final linea2 = makeLinea(productoId: 'prod-2', cantidad: 5, recibido: 3);
      final localPedido = makePedido(
        id: 'ped-1',
        proveedorId: 'prov-1',
        productos: [linea, linea2],
        updatedAt: t1,
      );
      final serverPedido = makePedido(
        id: 'ped-1',
        proveedorId: 'prov-1',
        productos: [linea, linea2],
        updatedAt: t2,
      );

      final resolved = ConflictResolver.resolvePedidos(localPedido, serverPedido);

      expect(resolved.productos.length, equals(2));
    });
  });
}
