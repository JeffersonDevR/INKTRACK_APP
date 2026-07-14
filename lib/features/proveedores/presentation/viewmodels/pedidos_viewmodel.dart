import 'package:InkTrack/core/base_crud_viewmodel.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/proveedores/data/models/pedido_proveedor.dart';
import 'package:InkTrack/features/proveedores/data/repositories/pedidos_repository.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import '../../../inventario/presentation/viewmodels/inventario_viewmodel.dart';
import '../../../movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import '../../../movimientos/data/models/movimiento.dart';
import 'proveedores_viewmodel.dart';

class PedidosProveedorViewModel extends BaseCrudViewModel<PedidoProveedor> {
  final PedidosProveedorRepository _repository;
  String? _localId;

  PedidosProveedorViewModel(this._repository) {
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
    MovimientosViewModel? movimientosVM,
  }) async {
    final montoTotal = productos.fold(0.0, (sum, p) => sum + p.subtotal);

    final pedido = PedidoProveedor(
      id: IdUtils.generateId(),
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

    if (movimientosVM != null) {
      final movimiento = Movimiento(
        id: IdUtils.generateId(),
        monto: montoTotal,
        fecha: DateTime.now(),
        tipo: MovimientoType.actividad,
        concepto:
            'Pedido a proveedor: ${proveedorNombre ?? "Proveedor #$proveedorId"}',
        categoria: 'Pedidos',
      );
      await movimientosVM.guardar(movimiento);
    }
  }

  Future<void> marcarEntregado(
    String id,
    InventarioViewModel? inventarioVM, {
    MovimientosViewModel? movimientosVM,
    ProveedoresViewModel? proveedoresVM,
  }) async {
    final pedido = getById(id);
    if (pedido == null) return;

    if (inventarioVM != null) {
      for (final producto in pedido.productos) {
        final existing = inventarioVM.getById(producto.productoId);
        if (existing != null) {
          if (!existing.isActivo) {
            await inventarioVM.reactivar(producto.productoId);
          }
          await inventarioVM.actualizarStock(
            producto.productoId,
            producto.cantidad,
          );
        }
      }
    }

    await _repository.marcarEntregado(id);
    // Only mark as delivered when every product line has been fully received
    // (recibido >= solicitado). Partial receptions keep isEntregado=false.
    final allReceived = pedido.productos.every((p) => p.recibido >= p.cantidad);
    final actualizado = pedido.copyWith(isEntregado: allReceived);
    update(id, actualizado);

    if (movimientosVM != null) {
      final movimiento = Movimiento(
        id: IdUtils.generateId(),
        monto: pedido.montoTotal,
        fecha: DateTime.now(),
        tipo: MovimientoType.egreso,
        concepto: 'Entrega pedido: ${pedido.proveedorNombre ?? "Proveedor"}',
        categoria: 'Pedidos',
      );
      await movimientosVM.guardar(movimiento);
    }

    if (proveedoresVM != null) {
      await proveedoresVM.actualizarVisita(pedido.proveedorId, DateTime.now());
    }
  }

  List<PedidoProveedor> getPorProveedor(String proveedorId) {
    return items.where((p) => p.proveedorId == proveedorId).toList();
  }

  Future<void> eliminar(String id) async {
    await _repository.delete(id);
    delete(id);
  }

  // -----------------------------------------------------------------------
  // Chain 5 — Reception tracking (task 5.7)
  // -----------------------------------------------------------------------

  /// Returns lines of [pedidoId] where [PedidoProducto.recibido] < [PedidoProducto.cantidad].
  List<PedidoProducto> discrepancyFor(String pedidoId) {
    final pedido = getById(pedidoId);
    if (pedido == null) return [];
    return pedido.productos.where((p) => p.recibido < p.cantidad).toList();
  }

  /// Discrepancy diff for a single [line]: solicitado − recibido.
  int discrepancyCount(PedidoProducto line) => line.cantidad - line.recibido;

  /// Increments [recibido] by 1 for the product line matching [productoId]
  /// within the pedido identified by [pedidoId].
  /// Updates in-memory state only (persist via repository when confirmed).
  Future<void> incrementRecibido(String pedidoId, String productoId) async {
    final pedido = getById(pedidoId);
    if (pedido == null) return;

    final updatedLineas = pedido.productos.map((p) {
      if (p.productoId == productoId) {
        return p.copyWith(recibido: p.recibido + 1);
      }
      return p;
    }).toList();

    final updated = pedido.copyWith(
      productos: updatedLineas,
      updatedAt: DateTime.now(),
    );
    update(pedidoId, updated);
    await _repository.update(pedidoId, updated);
  }

  // -----------------------------------------------------------------------
  // Chain 5 — Reorder suggestions (task 5.11)
  // -----------------------------------------------------------------------

  /// Returns productos whose [Producto.cantidad] <= [Producto.stockMinimo].
  /// Call with the full producto list from [InventarioViewModel].
  static List<Producto> reorderSuggestions(List<Producto> allProductos) {
    return allProductos.where((p) => p.cantidad <= p.stockMinimo && p.isActivo).toList();
  }
}
