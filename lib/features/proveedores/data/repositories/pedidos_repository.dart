import '../../../../core/data/base_repository.dart';
import '../models/pedido_proveedor.dart';

abstract class PedidosProveedorRepository
    implements BaseRepository<PedidoProveedor> {
  Future<List<PedidoProveedor>> getPendientes();
  Future<List<PedidoProveedor>> getPorProveedor(String proveedorId);
  Future<List<PedidoProveedor>> getEntregados();
  Future<void> marcarEntregado(String id);
}

class InMemoryPedidosProveedorRepository implements PedidosProveedorRepository {
  final List<PedidoProveedor> _items = [];

  @override
  Future<List<PedidoProveedor>> getAll() async {
    return List.unmodifiable(_items);
  }

  @override
  Future<PedidoProveedor?> getById(String id) async {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> save(PedidoProveedor item) async {
    _items.add(item);
  }

  @override
  Future<void> update(String id, PedidoProveedor item) async {
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
  Future<List<PedidoProveedor>> getPendientes() async {
    return _items.where((p) => !p.isEntregado).toList();
  }

  @override
  Future<List<PedidoProveedor>> getPorProveedor(String proveedorId) async {
    return _items.where((p) => p.proveedorId == proveedorId).toList();
  }

  @override
  Future<List<PedidoProveedor>> getEntregados() async {
    return _items.where((p) => p.isEntregado).toList();
  }

  @override
  Future<void> marcarEntregado(String id) async {
    final index = _items.indexWhere((i) => i.id == id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(isEntregado: true);
    }
  }
}
