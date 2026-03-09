import 'package:InkTrack/core/data/base_repository.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';

abstract class MovimientosRepository implements BaseRepository<Movimiento> {}

class InMemoryMovimientosRepository implements MovimientosRepository {
  final List<Movimiento> _items = [];

  @override
  Future<List<Movimiento>> getAll() async {
    return List.unmodifiable(_items);
  }

  @override
  Future<Movimiento?> getById(String id) async {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> save(Movimiento item) async {
    _items.add(item);
  }

  @override
  Future<void> update(String id, Movimiento item) async {
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
