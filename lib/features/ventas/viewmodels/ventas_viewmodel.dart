import '../../../core/base_crud_viewmodel.dart';
import '../models/venta.dart';

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

  void guardar(Venta venta) {
    if (venta.monto <= 0) return;
    
    // Auto-generate ID if needed, similar to Products (though sales usually don't have barcodes as IDs)
    final id = venta.id.isEmpty 
        ? DateTime.now().millisecondsSinceEpoch.toString() 
        : venta.id;

    final ventaAGuardar = Venta(
        id: id,
        monto: venta.monto,
        fecha: venta.fecha,
        clienteId: venta.clienteId,
        clienteNombre: venta.clienteNombre,
        concepto: venta.concepto,
    );

    final existingIndex = items.indexWhere((v) => v.id == id);
    if (existingIndex != -1) {
      update(id, ventaAGuardar);
    } else {
      add(ventaAGuardar);
    }
  }

  void eliminar(String id) => delete(id);

  List<Venta> getVentasPorCliente(String clienteId) =>
      items.where((venta) => venta.clienteId == clienteId).toList();
}
