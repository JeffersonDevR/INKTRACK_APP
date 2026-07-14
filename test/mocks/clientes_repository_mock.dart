import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/clientes/data/repositories/clientes_repository.dart';

class MockClientesRepository implements ClientesRepository {
  final List<Cliente> _items = [];
  bool shouldThrow = false;
  String? errorMessage;

  @override
  Future<List<Cliente>> getAll() async {
    if (shouldThrow) throw Exception(errorMessage ?? 'Mock error');
    return List.unmodifiable(_items.where((c) => c.isActivo));
  }

  @override
  Future<Cliente?> getById(String id) async {
    if (shouldThrow) throw Exception(errorMessage ?? 'Mock error');
    try {
      return _items.firstWhere((item) => item.id == id && item.isActivo);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Cliente?> getByIdIncludingInactive(String id) async {
    if (shouldThrow) throw Exception(errorMessage ?? 'Mock error');
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(Cliente item) async {
    if (shouldThrow) throw Exception(errorMessage ?? 'Mock error');
    _items.add(item);
  }

  @override
  Future<void> update(String id, Cliente item) async {
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

  void addCliente(Cliente cliente) => _items.add(cliente);
  void clear() => _items.clear();
}
