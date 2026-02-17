import '../../core/base_crud_viewmodel.dart';

class Venta implements HasId {
  @override
  final String id;
  final double monto;
  final DateTime fecha;
  final String? clienteId;

  /// Name when client is not registered (walk-in).
  final String? clienteNombre;
  final String? concepto;

  Venta({
    required this.id,
    required this.monto,
    required this.fecha,
    this.clienteId,
    this.clienteNombre,
    this.concepto,
  });
}
