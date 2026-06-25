import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/clientes/domain/use_cases/auto_crear_cliente_use_case.dart';
import 'package:InkTrack/features/clientes/data/repositories/clientes_repository.dart';
import 'package:InkTrack/features/inventario/domain/use_cases/actualizar_stock_use_case.dart';
import 'package:InkTrack/features/inventario/data/repositories/productos_repository.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/movimientos/domain/use_cases/crear_movimiento_use_case.dart';
import 'package:InkTrack/features/ventas/data/models/venta.dart';
import 'package:InkTrack/features/ventas/data/repositories/ventas_repository.dart';

class RegistrarVentaResult {
  final Venta venta;
  final String? clienteId;
  final bool clienteCreado;

  RegistrarVentaResult({
    required this.venta,
    this.clienteId,
    this.clienteCreado = false,
  });
}

class RegistrarVentaUseCase {
  final VentasRepository _ventasRepo;
  final ProductosRepository _productosRepo;
  final ClientesRepository _clientesRepo;
  final CrearMovimientoUseCase _crearMovimiento;
  final ActualizarStockUseCase _actualizarStock;
  final AutoCrearClienteUseCase _autoCrearCliente;

  RegistrarVentaUseCase({
    required VentasRepository ventasRepo,
    required ProductosRepository productosRepo,
    required ClientesRepository clientesRepo,
    required CrearMovimientoUseCase crearMovimiento,
    required ActualizarStockUseCase actualizarStock,
    required AutoCrearClienteUseCase autoCrearCliente,
  })  : _ventasRepo = ventasRepo,
        _productosRepo = productosRepo,
        _clientesRepo = clientesRepo,
        _crearMovimiento = crearMovimiento,
        _actualizarStock = actualizarStock,
        _autoCrearCliente = autoCrearCliente;

  Future<RegistrarVentaResult> call(Venta venta) async {
    final id = IdUtils.generateTimestampId();
    String? finalClienteId = venta.clienteId;

    if (venta.clienteId == null &&
        venta.clienteNombre != null &&
        venta.clienteNombre!.isNotEmpty) {
      final result = await _autoCrearCliente(
        nombre: venta.clienteNombre!,
        telefono: '',
        email: '',
        localId: venta.localId,
      );
      finalClienteId = result.cliente.id;
    }

    if (venta.isMultiProducto) {
      for (final item in venta.productos) {
        await _validateStock(item.productoId, item.cantidad);
      }
    } else if (venta.productoId != null && venta.cantidad > 0) {
      await _validateStock(venta.productoId!, venta.cantidad);
    }

    final ventaAGuardar = venta.copyWith(id: id, clienteId: finalClienteId);
    await _ventasRepo.save(ventaAGuardar);

    final rawConcepto = venta.concepto ?? 'Venta general';
    final finalConcepto = rawConcepto.toLowerCase().startsWith('venta:')
        ? rawConcepto
        : 'Venta: $rawConcepto';

    await _crearMovimiento(
      Movimiento(
        id: '',
        monto: venta.monto,
        fecha: venta.fecha,
        tipo: MovimientoType.ingreso,
        concepto: finalConcepto,
        categoria: 'Ventas',
        localId: venta.localId,
        productosJson: venta.productosJson,
      ),
    );

    if (venta.isMultiProducto) {
      for (final item in venta.productos) {
        double decrement = item.cantidad;
        final producto = await _productosRepo.getById(item.productoId);
        if (producto != null &&
            item.isUnidad &&
            producto.esPaquete &&
            producto.unidadesPorPaquete > 0) {
          decrement = item.cantidad / producto.unidadesPorPaquete;
        }
        await _actualizarStock(item.productoId, -decrement);
      }
    } else if (venta.productoId != null && venta.cantidad > 0) {
      await _actualizarStock(venta.productoId!, -venta.cantidad);
    }

    if (finalClienteId != null && venta.esFiado) {
      final cliente = await _clientesRepo.getById(finalClienteId);
      if (cliente != null) {
        final newSaldo = cliente.saldoPendiente + venta.monto;
        await _clientesRepo.update(
          finalClienteId,
          cliente.copyWith(
            saldoPendiente: newSaldo,
            esFiado: newSaldo > 0 || cliente.esFiado,
          ),
        );
      }
    }

    return RegistrarVentaResult(
      venta: ventaAGuardar,
      clienteId: finalClienteId,
      clienteCreado: finalClienteId != venta.clienteId,
    );
  }

  Future<void> _validateStock(String productoId, double cantidadNeeded) async {
    final producto = await _productosRepo.getById(productoId);
    if (producto == null) return;

    if (!producto.isActivo) {
      throw Exception('Producto inactivo: ${producto.nombre}');
    }

    final needed = cantidadNeeded.toInt();
    if (producto.cantidad < needed) {
      throw Exception(
        'Stock insuficiente para ${producto.nombre}: '
        'necesario $needed, disponible ${producto.cantidad}',
      );
    }
  }

}
