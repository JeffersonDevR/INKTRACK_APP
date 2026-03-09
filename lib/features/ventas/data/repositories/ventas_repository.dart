import 'package:InkTrack/core/data/base_repository.dart';
import 'package:InkTrack/features/ventas/data/models/venta.dart';

abstract class VentasRepository implements BaseRepository<Venta> {}

class InMemoryVentasRepository implements VentasRepository {
  final List<Venta> _items = [];

  @override
  Future<List<Venta>> getAll() async {
    return List.unmodifiable(_items);
  }

  @override
  Future<Venta?> getById(String id) async {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> save(Venta item) async {
    _items.add(item);
  }

  @override
  Future<void> update(String id, Venta item) async {
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
