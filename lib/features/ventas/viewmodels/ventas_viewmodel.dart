import '../../../core/base_crud_viewmodel.dart';
import '../models/venta.dart';
import '../../movimientos/viewmodels/movimientos_viewmodel.dart';
import '../../movimientos/models/movimiento.dart';
import 'package:uuid/uuid.dart';

class VentasViewModel extends BaseCrudViewModel<Venta> {
  List<Venta> get ventas => items;

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

  void guardar(Venta venta, {MovimientosViewModel? movimientosVM}) {
    if (venta.monto <= 0) return;
    
    final bool isNew = venta.id.isEmpty;
    final id = isNew 
        ? DateTime.now().microsecondsSinceEpoch.toString() 
        : venta.id;

    final ventaAGuardar = Venta(
        id: id,
        monto: venta.monto,
        fecha: venta.fecha,
        clienteId: venta.clienteId,
        clienteNombre: venta.clienteNombre,
        concepto: venta.concepto,
    );

    if (isNew) {
      add(ventaAGuardar);
      
      // Record movement
      if (movimientosVM != null) {
        movimientosVM.add(Movimiento(
          id: const Uuid().v4(),
          monto: venta.monto,
          fecha: venta.fecha,
          tipo: MovimientoType.ingreso,
          concepto: 'Venta: ${venta.concepto ?? "Venta general"}',
          categoria: 'Ventas',
        ));
      }
    } else {
      final existingIndex = items.indexWhere((v) => v.id == id);
      if (existingIndex != -1) {
        update(id, ventaAGuardar);
      } else {
        add(ventaAGuardar);
      }
    }
  }

  void eliminar(String id) => delete(id);

  List<Venta> getVentasPorCliente(String clienteId) =>
      items.where((venta) => venta.clienteId == clienteId).toList();
}
