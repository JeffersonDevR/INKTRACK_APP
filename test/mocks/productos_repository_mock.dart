import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/inventario/data/repositories/productos_repository.dart';

class MockProductosRepository implements ProductosRepository {
  final List<Producto> _items = [];
  bool shouldThrow = false;
  String? errorMessage;

  @override
  Future<List<Producto>> getAll() async {
    if (shouldThrow) throw Exception(errorMessage ?? 'Mock error');
    return List.unmodifiable(_items.where((p) => p.isActivo));
  }

  @override
  Future<Producto?> getById(String id) async {
    if (shouldThrow) throw Exception(errorMessage ?? 'Mock error');
    try {
      return _items.firstWhere((item) => item.id == id && item.isActivo);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Producto?> getByIdIncludingInactive(String id) async {
    if (shouldThrow) throw Exception(errorMessage ?? 'Mock error');
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(Producto item) async {
    if (shouldThrow) throw Exception(errorMessage ?? 'Mock error');
    _items.add(item);
  }

  @override
  Future<void> update(String id, Producto item) async {
    if (shouldThrow) throw Exception(errorMessage ?? 'Mock error');
    final index = _items.indexWhere((i) => i.id == id);
    if (index != -1) _items[index] = item;
  }

  @override
  Future<void> delete(String id) async {
    if (shouldThrow) throw Exception(errorMessage ?? 'Mock error');
    _items.removeWhere((item) => item.id == id);
  }

  @override
  Future<void> softDelete(String id) async {
    if (shouldThrow) throw Exception(errorMessage ?? 'Mock error');
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(isActivo: false);
    }
  }

  @override
  Future<Producto?> getByBarcode(String barcode) async {
    if (shouldThrow) throw Exception(errorMessage ?? 'Mock error');
    try {
      return _items.firstWhere((p) => p.codigoBarras == barcode && p.isActivo);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Producto?> getByAnyCode(String code) async {
    if (shouldThrow) throw Exception(errorMessage ?? 'Mock error');
    try {
      return _items.firstWhere(
        (p) =>
            (p.codigoBarras == code ||
                p.codigoPersonalizado == code ||
                p.id == code) &&
            p.isActivo,
      );
    } catch (_) {
      return null;
    }
  }

  void addProducto(Producto producto) => _items.add(producto);
  void clear() => _items.clear();
}
