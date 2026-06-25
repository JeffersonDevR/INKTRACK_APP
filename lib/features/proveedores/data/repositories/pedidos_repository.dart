import '../../../../core/data/base_repository.dart';
import '../models/pedido_proveedor.dart';

abstract class PedidosProveedorRepository
    implements BaseRepository<PedidoProveedor> {
  Future<List<PedidoProveedor>> getPendientes();
  Future<List<PedidoProveedor>> getPorProveedor(String proveedorId);
  Future<List<PedidoProveedor>> getEntregados();
  Future<void> marcarEntregado(String id);
}

