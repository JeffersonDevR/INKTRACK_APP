import '../../core/base_crud_viewmodel.dart';
import 'venta.dart';

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

  void registrar({
    required double monto,
    String? clienteId,
    String? clienteNombre,
    String? concepto,
  }) {
    if (monto <= 0) return;
    add(
      Venta(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        monto: monto,
        fecha: DateTime.now(),
        clienteId: clienteId,
        clienteNombre: clienteNombre,
        concepto: concepto,
      ),
    );
  }

  void eliminar(String id) => delete(id);

  List<Venta> getVentasPorCliente(String clienteId) =>
      items.where((venta) => venta.clienteId == clienteId).toList();
}
