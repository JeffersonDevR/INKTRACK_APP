import 'package:drift/drift.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/proveedores/data/models/proveedor.dart';
import 'package:InkTrack/features/proveedores/data/repositories/proveedores_repository.dart';

class DriftProveedoresRepository implements ProveedoresRepository {
  final AppDatabase _db;

  DriftProveedoresRepository(this._db);

  @override
  Future<List<Proveedor>> getAll() async {
    final query = _db.select(_db.proveedores)
      ..where((t) => t.isActivo.equals(true));
    final rows = await query.get();
    return rows.map((row) => _toModel(row)).toList();
  }

  Future<List<Proveedor>> getAllIncludingInactive() async {
    final rows = await _db.select(_db.proveedores).get();
    return rows.map((row) => _toModel(row)).toList();
  }

  @override
  Future<Proveedor?> getById(String id) async {
    final query = _db.select(_db.proveedores)
      ..where((t) => t.id.equals(id) & t.isActivo.equals(true));
    final row = await query.getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  Future<Proveedor?> getByIdIncludingInactive(String id) async {
    final query = _db.select(_db.proveedores)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  @override
  Future<void> save(Proveedor item) async {
    await _db
        .into(_db.proveedores)
        .insert(
          ProveedoresCompanion.insert(
            id: item.id,
            nombre: item.nombre,
            telefono: item.telefono,
            diasVisita: item.diasVisita,
            isActivo: Value(item.isActivo),
            syncStatus: const Value('pending_upload'),
          ),
        );
  }

  @override
  Future<void> update(String id, Proveedor item) async {
    await (_db.update(_db.proveedores)..where((t) => t.id.equals(id))).write(
      ProveedoresCompanion(
        nombre: Value(item.nombre),
        telefono: Value(item.telefono),
        diasVisita: Value(item.diasVisita),
        isActivo: Value(item.isActivo),
        syncStatus: const Value('pending_upload'),
      ),
    );
  }

  Future<void> softDelete(String id) async {
    await (_db.update(_db.proveedores)..where((t) => t.id.equals(id))).write(
      const ProveedoresCompanion(
        isActivo: Value(false),
        syncStatus: Value('pending_upload'),
      ),
    );
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.proveedores)..where((t) => t.id.equals(id))).go();
  }

  Proveedor _toModel(ProveedorData data) {
    return Proveedor(
      id: data.id,
      nombre: data.nombre,
      telefono: data.telefono,
      diasVisita: data.diasVisita,
      isActivo: data.isActivo,
    );
  }
}
