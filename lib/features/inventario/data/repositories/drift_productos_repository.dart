import 'package:drift/drift.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/inventario/data/repositories/productos_repository.dart';

class DriftProductosRepository implements ProductosRepository {
  final AppDatabase _db;

  DriftProductosRepository(this._db);

  @override
  Future<List<Producto>> getAll() async {
    final rows = await _db.select(_db.productos).get();
    return rows.map((row) => _toModel(row)).toList();
  }

  @override
  Future<Producto?> getById(String id) async {
    final query = _db.select(_db.productos)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  @override
  Future<void> save(Producto item) async {
    await _db.into(_db.productos).insert(
      ProductosCompanion.insert(
        id: item.id,
        nombre: item.nombre,
        cantidad: item.cantidad,
        precio: item.precio,
        categoria: item.categoria,
        proveedorId: item.proveedorId,
        stockMinimo: Value(item.stockMinimo),
        codigoBarras: Value(item.codigoBarras),
        proveedorNombre: Value(item.proveedorNombre),
      ),
    );
  }

  @override
  Future<void> update(String id, Producto item) async {
    await (_db.update(_db.productos)..where((t) => t.id.equals(id))).write(
      ProductosCompanion(
        nombre: Value(item.nombre),
        cantidad: Value(item.cantidad),
        precio: Value(item.precio),
        categoria: Value(item.categoria),
        proveedorId: Value(item.proveedorId),
        stockMinimo: Value(item.stockMinimo),
        codigoBarras: Value(item.codigoBarras),
        proveedorNombre: Value(item.proveedorNombre),
      ),
    );
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.productos)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<Producto?> getByBarcode(String barcode) async {
    final query = _db.select(_db.productos)
      ..where((t) => t.codigoBarras.equals(barcode));
    final row = await query.getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  Producto _toModel(ProductoData data) {
    return Producto(
      id: data.id,
      nombre: data.nombre,
      cantidad: data.cantidad,
      precio: data.precio,
      categoria: data.categoria,
      proveedorId: data.proveedorId,
      stockMinimo: data.stockMinimo,
      codigoBarras: data.codigoBarras,
      proveedorNombre: data.proveedorNombre,
    );
  }
}
