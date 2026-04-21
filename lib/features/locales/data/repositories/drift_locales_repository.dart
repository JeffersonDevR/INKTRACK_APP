import 'package:drift/drift.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/locales/data/models/local.dart';
import 'package:InkTrack/features/locales/data/repositories/locales_repository.dart';

class DriftLocalesRepository implements LocalesRepository {
  final AppDatabase _db;

  DriftLocalesRepository(this._db);

  @override
  Future<List<Local>> getAll() async {
    final rows = await _db.select(_db.locales).get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<Local?> getById(String id) async {
    final query = _db.select(_db.locales)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  @override
  Future<void> save(Local local) async {
    await _db
        .into(_db.locales)
        .insert(
          LocalesCompanion.insert(
            id: local.id,
            nombre: local.nombre,
            direccion: Value(local.direccion),
            telefono: Value(local.telefono),
            tipo: Value(local.tipo),
            userId: Value(local.userId),
            isActivo: Value(local.isActivo),
            syncStatus: const Value('pending_upload'),
          ),
        );
  }

  @override
  Future<void> update(String id, Local local) async {
    await (_db.update(_db.locales)..where((t) => t.id.equals(id))).write(
      LocalesCompanion(
        nombre: Value(local.nombre),
        direccion: Value(local.direccion),
        telefono: Value(local.telefono),
        tipo: Value(local.tipo),
        userId: Value(local.userId),
        isActivo: Value(local.isActivo),
        syncStatus: const Value('pending_upload'),
      ),
    );
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.locales)..where((t) => t.id.equals(id))).go();
  }

  Local _toModel(LocalData data) {
    return Local(
      id: data.id,
      nombre: data.nombre,
      direccion: data.direccion,
      telefono: data.telefono,
      tipo: data.tipo,
      userId: data.userId,
      isActivo: data.isActivo,
    );
  }
}
