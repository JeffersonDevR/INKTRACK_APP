import 'package:drift/drift.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/ventas/data/models/venta.dart';
import 'package:InkTrack/features/ventas/data/repositories/ventas_repository.dart';

class DriftVentasRepository implements VentasRepository {
  final AppDatabase _db;

  DriftVentasRepository(this._db);

  @override
  Future<List<Venta>> getAll() async {
    final rows = await _db.select(_db.ventas).get();
    return rows.map((row) => _toModel(row)).toList();
  }

  @override
  Future<Venta?> getById(String id) async {
    final query = _db.select(_db.ventas)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  @override
  Future<void> save(Venta item) async {
    await _db
        .into(_db.ventas)
        .insert(
          VentasCompanion.insert(
            id: item.id,
            monto: item.monto,
            fecha: item.fecha,
            clienteId: Value(item.clienteId),
            clienteNombre: Value(item.clienteNombre),
            localId: item.localId != null
                ? Value(item.localId)
                : const Value.absent(),
            concepto: Value(item.concepto),
            productosJson: Value(item.productosJson),
            syncStatus: const Value('pending_upload'),
          ),
        );
  }

  @override
  Future<void> update(String id, Venta item) async {
    await (_db.update(_db.ventas)..where((t) => t.id.equals(id))).write(
      VentasCompanion(
        monto: Value(item.monto),
        fecha: Value(item.fecha),
        clienteId: Value(item.clienteId),
        clienteNombre: Value(item.clienteNombre),
        localId: item.localId != null
            ? Value(item.localId)
            : const Value.absent(),
        concepto: Value(item.concepto),
        productosJson: Value(item.productosJson),
        syncStatus: const Value('pending_upload'),
      ),
    );
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.ventas)..where((t) => t.id.equals(id))).go();
  }

  Venta _toModel(VentaData data) {
    return Venta(
      id: data.id,
      monto: data.monto,
      fecha: data.fecha,
      clienteId: data.clienteId,
      clienteNombre: data.clienteNombre,
      localId: data.localId,
      concepto: data.concepto,
      productosJson: data.productosJson,
    );
  }
}
