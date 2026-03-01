import 'package:InkTrack/core/base_crud_viewmodel.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/ventas/data/models/venta.dart';
import 'package:InkTrack/features/ventas/data/repositories/ventas_repository.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';

class VentasViewModel extends BaseCrudViewModel<Venta> {
  final VentasRepository _repository;

  VentasViewModel(this._repository) {
    _loadVentas();
  }

  List<Venta> get ventas => items;

  Future<void> _loadVentas() async {
    final loaded = await _repository.getAll();
    for (var venta in loaded) {
      add(venta);
    }
  }

  double get totalVentasDia {
    final now = DateTime.now();
    return items
        .where(
          (venta) =>
              venta.fecha.year == now.year &&
              venta.fecha.month == now.month &&
              venta.fecha.day == now.day,
        )
        .fold(0.0, (sum, item) => sum + item.monto);
  }

  Future<void> guardar(Venta venta, {MovimientosViewModel? movimientosVM}) async {
    if (venta.monto <= 0) return;
    
    final bool isNew = venta.id.isEmpty;
    final id = isNew 
        ? IdUtils.generateTimestampId()
        : venta.id;

    final ventaAGuardar = venta.copyWith(id: id);

    if (isNew) {
      await _repository.save(ventaAGuardar);
      add(ventaAGuardar);
      
      // Record movement
      if (movimientosVM != null) {
        final movimiento = Movimiento(
          id: IdUtils.generateId(),
          monto: venta.monto,
          fecha: venta.fecha,
          tipo: MovimientoType.ingreso,
          concepto: 'Venta: ${venta.concepto ?? "Venta general"}',
          categoria: 'Ventas',
        );
        await movimientosVM.guardar(movimiento);
      }
    } else {
      await _repository.update(id, ventaAGuardar);
      update(id, ventaAGuardar);
    }
  }

  Future<void> eliminar(String id) async {
    await _repository.delete(id);
    delete(id);
  }

  List<Venta> getVentasPorCliente(String clienteId) =>
      items.where((venta) => venta.clienteId == clienteId).toList();
}
