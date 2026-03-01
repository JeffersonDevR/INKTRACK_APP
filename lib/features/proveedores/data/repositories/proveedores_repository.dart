import '../../../../core/data/base_repository.dart';
import '../models/proveedor.dart';

class ProveedoresRepository implements BaseRepository<Proveedor> {
  final List<Proveedor> _items = [];

  @override
  Future<List<Proveedor>> getAll() async {
    return List.unmodifiable(_items);
  }

  @override
  Future<Proveedor?> getById(String id) async {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> save(Proveedor item) async {
    _items.add(item);
  }

  @override
  Future<void> update(String id, Proveedor item) async {
    final index = _items.indexWhere((i) => i.id == id);
    if (index != -1) {
      _items[index] = item;
    }
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((item) => item.id == id);
  }
}
