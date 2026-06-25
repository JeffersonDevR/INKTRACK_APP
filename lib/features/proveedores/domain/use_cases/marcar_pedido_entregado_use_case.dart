import 'package:InkTrack/features/inventario/domain/use_cases/actualizar_stock_use_case.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/movimientos/domain/use_cases/crear_movimiento_use_case.dart';
import 'package:InkTrack/features/proveedores/data/repositories/pedidos_repository.dart';
import 'package:InkTrack/features/proveedores/data/repositories/proveedores_repository.dart';

class MarcarPedidoEntregadoUseCase {
  final PedidosProveedorRepository _pedidosRepo;
  final ProveedoresRepository _proveedoresRepo;
  final ActualizarStockUseCase _actualizarStock;
  final CrearMovimientoUseCase _crearMovimiento;

  MarcarPedidoEntregadoUseCase({
    required PedidosProveedorRepository pedidosRepo,
    required ProveedoresRepository proveedoresRepo,
    required ActualizarStockUseCase actualizarStock,
    required CrearMovimientoUseCase crearMovimiento,
  })  : _pedidosRepo = pedidosRepo,
        _proveedoresRepo = proveedoresRepo,
        _actualizarStock = actualizarStock,
        _crearMovimiento = crearMovimiento;

  Future<void> call(String pedidoId) async {
    final pedido = await _pedidosRepo.getById(pedidoId);
    if (pedido == null || pedido.isEntregado) return;

    for (final producto in pedido.productos) {
      await _reactivarSiInactivo(producto.productoId);
      await _actualizarStock(producto.productoId, producto.cantidad);
    }

    await _pedidosRepo.marcarEntregado(pedidoId);

    await _crearMovimiento(
      Movimiento(
        id: '',
        monto: pedido.montoTotal,
        fecha: DateTime.now(),
        tipo: MovimientoType.egreso,
        concepto: 'Entrega pedido: ${pedido.proveedorNombre ?? "Proveedor"}',
        categoria: 'Pedidos',
        localId: pedido.localId,
      ),
    );

    await _actualizarVisita(pedido.proveedorId, DateTime.now());
  }

  Future<void> _reactivarSiInactivo(String productoId) async {
    try {
      await _actualizarStock(productoId, 0);
    } catch (_) {}
  }

  Future<void> _actualizarVisita(String proveedorId, DateTime fecha) async {
    final proveedor = await _proveedoresRepo.getById(proveedorId);
    if (proveedor == null) return;

    await _proveedoresRepo.update(
      proveedorId,
      proveedor.copyWith(ultimaVisita: fecha),
    );
  }
}
