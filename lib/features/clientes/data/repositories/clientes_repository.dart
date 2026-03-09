import 'package:InkTrack/core/data/base_repository.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';

abstract class ClientesRepository implements BaseRepository<Cliente> {}

class InMemoryClientesRepository implements ClientesRepository {
  final List<Cliente> _items = [];

  @override
  Future<List<Cliente>> getAll() async {
    return List.unmodifiable(_items);
  }

  @override
  Future<Cliente?> getById(String id) async {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> save(Cliente item) async {
    _items.add(item);
  }

  @override
  Future<void> update(String id, Cliente item) async {
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
