import 'package:drift/drift.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/clientes/data/repositories/clientes_repository.dart';

class DriftClientesRepository implements ClientesRepository {
  final AppDatabase _db;

  DriftClientesRepository(this._db);

  @override
  Future<List<Cliente>> getAll() async {
    final query = _db.select(_db.clientes)
      ..where((t) => t.isActivo.equals(true));
    final rows = await query.get();
    return rows.map((row) => _toModel(row)).toList();
  }

  Future<List<Cliente>> getAllIncludingInactive() async {
    final rows = await _db.select(_db.clientes).get();
    return rows.map((row) => _toModel(row)).toList();
  }

  @override
  Future<Cliente?> getById(String id) async {
    final query = _db.select(_db.clientes)
      ..where((t) => t.id.equals(id) & t.isActivo.equals(true));
    final row = await query.getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  Future<Cliente?> getByIdIncludingInactive(String id) async {
    final query = _db.select(_db.clientes)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  @override
  Future<void> save(Cliente item) async {
    await _db
        .into(_db.clientes)
        .insert(
          ClientesCompanion.insert(
            id: item.id,
            nombre: item.nombre,
            telefono: item.telefono,
            email: item.email != null
                ? Value(item.email)
                : const Value.absent(),
            esFiado: Value(item.esFiado),
            saldoPendiente: Value(item.saldoPendiente),
            isActivo: Value(item.isActivo),
            syncStatus: const Value('pending_upload'),
          ),
        );
  }

  @override
  Future<void> update(String id, Cliente item) async {
    await (_db.update(_db.clientes)..where((t) => t.id.equals(id))).write(
      ClientesCompanion(
        nombre: Value(item.nombre),
        telefono: Value(item.telefono),
        email: item.email != null ? Value(item.email) : const Value.absent(),
        esFiado: Value(item.esFiado),
        saldoPendiente: Value(item.saldoPendiente),
        isActivo: Value(item.isActivo),
        syncStatus: const Value('pending_upload'),
      ),
    );
  }

  Future<void> softDelete(String id) async {
    await (_db.update(_db.clientes)..where((t) => t.id.equals(id))).write(
      const ClientesCompanion(
        isActivo: Value(false),
        syncStatus: Value('pending_upload'),
      ),
    );
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.clientes)..where((t) => t.id.equals(id))).go();
  }

  Cliente _toModel(ClienteData data) {
    return Cliente(
      id: data.id,
      nombre: data.nombre,
      telefono: data.telefono,
      email: data.email == null || data.email!.isEmpty ? null : data.email,
      esFiado: data.esFiado,
      saldoPendiente: data.saldoPendiente,
      isActivo: data.isActivo,
    );
  }
}
