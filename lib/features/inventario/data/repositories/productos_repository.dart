import 'package:InkTrack/core/data/base_repository.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';

abstract class ProductosRepository implements BaseRepository<Producto> {
  Future<Producto?> getByBarcode(String barcode);
}

class InMemoryProductosRepository implements ProductosRepository {
  final List<Producto> _items = [];

  @override
  Future<List<Producto>> getAll() async {
    return List.unmodifiable(_items);
  }

  @override
  Future<Producto?> getById(String id) async {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> save(Producto item) async {
    _items.add(item);
  }

  @override
  Future<void> update(String id, Producto item) async {
    final index = _items.indexWhere((i) => i.id == id);
    if (index != -1) {
      _items[index] = item;
    }
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((item) => item.id == id);
  }

  @override
  Future<Producto?> getByBarcode(String barcode) async {
    try {
      return _items.firstWhere((p) => p.codigoBarras == barcode);
    } catch (e) {
      return null;
    }
  }
}
