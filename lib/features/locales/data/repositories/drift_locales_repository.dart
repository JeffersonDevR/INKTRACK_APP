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
            updatedAt: Value(DateTime.now()),
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
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.locales)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<MigrationSummary> getOrphanedCounts() async {
    final productos =
        await _countWhereNull(_db.productos, _db.productos.localId);
    final clientes =
        await _countWhereNull(_db.clientes, _db.clientes.localId);
    final proveedores =
        await _countWhereNull(_db.proveedores, _db.proveedores.localId);
    final movimientos =
        await _countWhereNull(_db.movimientos, _db.movimientos.localId);
    final ventas = await _countWhereNull(_db.ventas, _db.ventas.localId);
    final pedidos =
        await _countWhereNull(_db.pedidosProveedor, _db.pedidosProveedor.localId);

    return MigrationSummary(
      productos: productos,
      clientes: clientes,
      proveedores: proveedores,
      movimientos: movimientos,
      ventas: ventas,
      pedidos: pedidos,
    );
  }

  @override
  Future<void> assignLocalId(String localId) async {
    await _db.transaction(() async {
      await _assignToTable(
        _db.productos,
        _db.productos.localId,
        _db.productos.syncStatus,
        localId,
      );
      await _assignToTable(
        _db.clientes,
        _db.clientes.localId,
        _db.clientes.syncStatus,
        localId,
      );
      await _assignToTable(
        _db.proveedores,
        _db.proveedores.localId,
        _db.proveedores.syncStatus,
        localId,
      );
      await _assignToTable(
        _db.movimientos,
        _db.movimientos.localId,
        _db.movimientos.syncStatus,
        localId,
      );
      await _assignToTable(
        _db.ventas,
        _db.ventas.localId,
        _db.ventas.syncStatus,
        localId,
      );
      await _assignToTable(
        _db.pedidosProveedor,
        _db.pedidosProveedor.localId,
        _db.pedidosProveedor.syncStatus,
        localId,
      );
    });
  }

  /// Count rows where the given column is NULL.
  Future<int> _countWhereNull(
    TableInfo table,
    GeneratedColumn<String> column,
  ) async {
    final result = await _db.customSelect(
      'SELECT COUNT(*) AS cnt FROM ${table.actualTableName} '
      'WHERE ${column.name} IS NULL',
    ).getSingle();
    return result.read<int>('cnt');
  }

  /// Update rows where localId IS NULL, setting localId and syncStatus.
  Future<void> _assignToTable(
    TableInfo table,
    GeneratedColumn<String> localIdCol,
    GeneratedColumn<String> syncStatusCol,
    String localId,
  ) async {
    await _db.customUpdate(
      'UPDATE ${table.actualTableName} '
      'SET ${localIdCol.name} = ?, ${syncStatusCol.name} = ? '
      'WHERE ${localIdCol.name} IS NULL',
      variables: [Variable(localId), const Variable('pending_upload')],
    );
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
      updatedAt: data.updatedAt,
      syncStatus: data.syncStatus,
    );
  }
}

