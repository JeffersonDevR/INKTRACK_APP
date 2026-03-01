import '../../../core/base_crud_viewmodel.dart';

enum MovimientoType { ingreso, egreso, actividad }

class Movimiento implements HasId {
  @override
  final String id;
  final double monto;
  final DateTime fecha;
  final MovimientoType tipo;
  final String concepto;
  final String? categoria;
  final String? productoId;
  final String? clienteId;
  final int? cantidad;
  final bool esFiado;

  Movimiento({
    required this.id,
    required this.monto,
    required this.fecha,
    required this.tipo,
    required this.concepto,
    this.categoria,
    this.productoId,
    this.clienteId,
    this.cantidad,
    this.esFiado = false,
  });
}
