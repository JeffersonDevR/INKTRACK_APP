import '../../../../core/data/base_repository.dart';
import '../models/proveedor.dart';

abstract class ProveedoresRepository implements BaseRepository<Proveedor> {
  Future<void> softDelete(String id);
  Future<Proveedor?> getByIdIncludingInactive(String id);
}

class InMemoryProveedoresRepository implements ProveedoresRepository {
  final List<Proveedor> _items = [];

  @override
  Future<List<Proveedor>> getAll() async {
    return List.unmodifiable(_items.where((p) => p.isActivo).toList());
  }

  @override
  Future<Proveedor?> getById(String id) async {
    try {
      return _items.firstWhere((item) => item.id == id && item.isActivo);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Proveedor?> getByIdIncludingInactive(String id) async {
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
}
