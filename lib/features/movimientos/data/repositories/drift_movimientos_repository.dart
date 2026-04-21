import 'package:drift/drift.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/movimientos/data/repositories/movimientos_repository.dart';

class DriftMovimientosRepository implements MovimientosRepository {
  final AppDatabase _db;

  DriftMovimientosRepository(this._db);

  @override
  Future<List<Movimiento>> getAll() async {
    final rows = await _db.select(_db.movimientos).get();
    return rows.map((row) => _toModel(row)).toList();
  }

  @override
  Future<Movimiento?> getById(String id) async {
    final query = _db.select(_db.movimientos)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  @override
  Future<void> save(Movimiento item) async {
    await _db
        .into(_db.movimientos)
        .insert(
          MovimientosCompanion.insert(
            id: item.id,
            monto: item.monto,
            fecha: item.fecha,
            tipo: item.tipo,
            concepto: item.concepto,
            categoria: Value(item.categoria),
            productoId: Value(item.productoId),
            clienteId: Value(item.clienteId),
            proveedorId: Value(item.proveedorId),
            localId: item.localId != null
                ? Value(item.localId)
                : const Value.absent(),
            cantidad: Value(item.cantidad),
            esFiado: Value(item.esFiado),
            productosJson: Value(item.productosJson),
            syncStatus: const Value('pending_upload'),
          ),
        );
  }

  @override
  Future<void> update(String id, Movimiento item) async {
    await (_db.update(_db.movimientos)..where((t) => t.id.equals(id))).write(
      MovimientosCompanion(
        monto: Value(item.monto),
        fecha: Value(item.fecha),
        tipo: Value(item.tipo),
        concepto: Value(item.concepto),
        categoria: Value(item.categoria),
        productoId: Value(item.productoId),
        clienteId: Value(item.clienteId),
        proveedorId: Value(item.proveedorId),
        localId: item.localId != null
            ? Value(item.localId)
            : const Value.absent(),
        cantidad: Value(item.cantidad),
        esFiado: Value(item.esFiado),
        productosJson: Value(item.productosJson),
        syncStatus: const Value('pending_upload'),
      ),
    );
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.movimientos)..where((t) => t.id.equals(id))).go();
  }

  Movimiento _toModel(MovimientoData data) {
    return Movimiento(
      id: data.id,
      monto: data.monto,
      fecha: data.fecha,
      tipo: data.tipo,
      concepto: data.concepto,
      categoria: data.categoria,
      productoId: data.productoId,
      clienteId: data.clienteId,
      proveedorId: data.proveedorId,
      localId: data.localId,
      cantidad: data.cantidad,
      esFiado: data.esFiado,
      productosJson: data.productosJson,
    );
  }
}
