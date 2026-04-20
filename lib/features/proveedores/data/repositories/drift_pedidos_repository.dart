import 'package:drift/drift.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/proveedores/data/models/pedido_proveedor.dart';
import 'package:InkTrack/features/proveedores/data/repositories/pedidos_repository.dart';

class DriftPedidosProveedorRepository implements PedidosProveedorRepository {
  final AppDatabase _db;

  DriftPedidosProveedorRepository(this._db);

  @override
  Future<List<PedidoProveedor>> getAll() async {
    final rows = await _db.select(_db.pedidosProveedor).get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<PedidoProveedor?> getById(String id) async {
    final query = _db.select(_db.pedidosProveedor)
      ..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  @override
  Future<void> save(PedidoProveedor item) async {
    await _db
        .into(_db.pedidosProveedor)
        .insert(
          PedidosProveedorCompanion.insert(
            id: item.id,
            proveedorId: item.proveedorId,
            proveedorNombre: Value(item.proveedorNombre),
            fechaPedido: item.fechaPedido,
            fechaEntrega: item.fechaEntrega,
            productos: item.productosJson,
            montoTotal: item.montoTotal,
            isEntregado: Value(item.isEntregado),
            notas: Value(item.notas),
            syncStatus: const Value('pending_upload'),
          ),
        );
  }

  @override
  Future<void> update(String id, PedidoProveedor item) async {
    await (_db.update(
      _db.pedidosProveedor,
    )..where((t) => t.id.equals(id))).write(
      PedidosProveedorCompanion(
        proveedorId: Value(item.proveedorId),
        proveedorNombre: Value(item.proveedorNombre),
        fechaPedido: Value(item.fechaPedido),
        fechaEntrega: Value(item.fechaEntrega),
        productos: Value(item.productosJson),
        montoTotal: Value(item.montoTotal),
        isEntregado: Value(item.isEntregado),
        notas: Value(item.notas),
        syncStatus: const Value('pending_upload'),
      ),
    );
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(
      _db.pedidosProveedor,
    )..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<PedidoProveedor>> getPendientes() async {
    final query = _db.select(_db.pedidosProveedor)
      ..where((t) => t.isEntregado.equals(false));
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<PedidoProveedor>> getPorProveedor(String proveedorId) async {
    final query = _db.select(_db.pedidosProveedor)
      ..where((t) => t.proveedorId.equals(proveedorId));
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<PedidoProveedor>> getEntregados() async {
    final query = _db.select(_db.pedidosProveedor)
      ..where((t) => t.isEntregado.equals(true));
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<void> marcarEntregado(String id) async {
    await (_db.update(
      _db.pedidosProveedor,
    )..where((t) => t.id.equals(id))).write(
      const PedidosProveedorCompanion(
        isEntregado: Value(true),
        syncStatus: Value('pending_upload'),
      ),
    );
  }

  PedidoProveedor _toModel(PedidoProveedorData data) {
    return PedidoProveedor(
      id: data.id,
      proveedorId: data.proveedorId,
      proveedorNombre: data.proveedorNombre,
      fechaPedido: data.fechaPedido,
      fechaEntrega: data.fechaEntrega,
      productos: PedidoProveedor.productosFromJson(data.productos),
      montoTotal: data.montoTotal,
      isEntregado: data.isEntregado,
      notas: data.notas,
    );
  }
}
