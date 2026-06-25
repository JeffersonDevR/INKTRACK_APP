import 'package:drift/drift.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/utils/id_utils.dart';

class CategoriasRepository {
  final AppDatabase _db;

  CategoriasRepository(this._db);

  Future<List<CategoriaData>> getAll(String tipo) async {
    return await (_db.select(_db.categorias)
      ..where((t) => t.tipo.equals(tipo))
    ).get();
  }

  Future<void> save(String nombre, String tipo) async {
    await _db.into(_db.categorias).insert(
      CategoriasCompanion.insert(
        id: IdUtils.generateTimestampId(),
        nombre: nombre,
        tipo: tipo,
      ),
    );
  }

  Future<void> update(String id, String nuevoNombre) async {
    await (_db.update(_db.categorias)..where((t) => t.id.equals(id))).write(
      CategoriasCompanion(nombre: Value(nuevoNombre)),
    );
  }

  Future<void> delete(String id) async {
    await (_db.delete(_db.categorias)..where((t) => t.id.equals(id))).go();
  }

  Future<bool> exists(String nombre, String tipo) async {
    final rows = await (_db.select(_db.categorias)
      ..where((t) => Expression.and([t.tipo.equals(tipo), t.nombre.equals(nombre)]))
    ).get();
    return rows.isNotEmpty;
  }
}
