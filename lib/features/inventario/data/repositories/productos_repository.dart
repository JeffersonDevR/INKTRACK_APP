import 'package:InkTrack/core/data/base_repository.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';

abstract class ProductosRepository implements BaseRepository<Producto> {
  Future<Producto?> getByBarcode(String barcode);
  Future<Producto?> getByAnyCode(String code);
  Future<void> softDelete(String id);
  Future<Producto?> getByIdIncludingInactive(String id);
}

class InMemoryProductosRepository implements ProductosRepository {
  final List<Producto> _items = [];

  @override
  Future<List<Producto>> getAll() async {
    return List.unmodifiable(_items.where((p) => p.isActivo).toList());
  }

  @override
  Future<Producto?> getById(String id) async {
    try {
      return _items.firstWhere((item) => item.id == id && item.isActivo);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Producto?> getByIdIncludingInactive(String id) async {
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
  Future<void> softDelete(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(isActivo: false);
    }
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((item) => item.id == id);
  }

  @override
  Future<Producto?> getByBarcode(String barcode) async {
    try {
      return _items.firstWhere((p) => p.codigoBarras == barcode && p.isActivo);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Producto?> getByAnyCode(String code) async {
    try {
      return _items.firstWhere(
        (p) =>
            (p.codigoBarras == code ||
                p.codigoPersonalizado == code ||
                p.id == code) &&
            p.isActivo,
      );
    } catch (e) {
      return null;
    }
  }
}
