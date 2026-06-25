import 'package:InkTrack/core/base_crud_viewmodel.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/proveedores/data/models/pedido_proveedor.dart';
import 'package:InkTrack/features/proveedores/data/repositories/pedidos_repository.dart';
import 'package:InkTrack/features/proveedores/domain/use_cases/marcar_pedido_entregado_use_case.dart';
import 'package:InkTrack/features/movimientos/domain/use_cases/crear_movimiento_use_case.dart';

class PedidosProveedorViewModel extends BaseCrudViewModel<PedidoProveedor> {
  final PedidosProveedorRepository _repository;
  final MarcarPedidoEntregadoUseCase _marcarEntregado;
  final CrearMovimientoUseCase _crearMovimiento;
  String? _localId;

  PedidosProveedorViewModel(
    this._repository,
    this._marcarEntregado,
    this._crearMovimiento,
  ) {
    _loadPedidos();
  }

  void setLocalId(String? localId) {
    _localId = localId;
    notifyListeners();
  }

  List<PedidoProveedor> get _pedidosFiltrados {
    if (_localId == null) return items;
    return items.where((p) => p.localId == _localId).toList();
  }

  List<PedidoProveedor> get pedidosPendientes {
    return _pedidosFiltrados.where((p) => !p.isEntregado).toList();
  }

  List<PedidoProveedor> get pedidosEntregados {
    return _pedidosFiltrados.where((p) => p.isEntregado).toList();
  }

  List<PedidoProveedor> get pedidosConAlerta {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _pedidosFiltrados.where((p) {
      if (p.isEntregado) return false;
      final entrega = DateTime(
        p.fechaEntrega.year,
        p.fechaEntrega.month,
        p.fechaEntrega.day,
      );
      final diff = entrega.difference(today).inDays;
      return diff >= -2 && diff <= 0;
    }).toList();
  }

  int get countAlertas => pedidosConAlerta.length;

  Future<void> _loadPedidos() async {
    clearAll();
    final loaded = await _repository.getAll();
    for (var pedido in loaded) {
      add(pedido);
    }
  }

  @override
  Future<void> refresh() async {
    await _loadPedidos();
    notifyListeners();
  }

  Future<void> crearPedido({
    required String proveedorId,
    required String? proveedorNombre,
    required DateTime fechaEntrega,
    required List<PedidoProducto> productos,
    String? notas,
  }) async {
    final montoTotal = productos.fold(0.0, (sum, p) => sum + p.subtotal);

    final pedido = PedidoProveedor(
      id: IdUtils.generateTimestampId(),
      proveedorId: proveedorId,
      proveedorNombre: proveedorNombre,
      localId: _localId,
      fechaPedido: DateTime.now(),
      fechaEntrega: fechaEntrega,
      productos: productos,
      montoTotal: montoTotal,
      notas: notas,
    );

    await _repository.save(pedido);
    add(pedido);

    await _crearMovimiento.registrarActividad(
      monto: montoTotal,
      concepto:
          'Pedido a proveedor: ${proveedorNombre ?? "Proveedor #$proveedorId"}',
      categoria: 'Pedidos',
    );
  }

  Future<void> marcarEntregado(String id) async {
    await _marcarEntregado(id);

    final pedido = getById(id);
    if (pedido != null) {
      update(id, pedido.copyWith(isEntregado: true));
    }
  }

  List<PedidoProveedor> getPorProveedor(String proveedorId) {
    return items.where((p) => p.proveedorId == proveedorId).toList();
  }

  Future<void> eliminar(String id) async {
    await _repository.delete(id);
    delete(id);
  }
}
