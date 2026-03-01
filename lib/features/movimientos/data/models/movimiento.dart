import '../../../../core/base_crud_viewmodel.dart';

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
  final String? proveedorId;
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
    this.proveedorId,
    this.cantidad,
    this.esFiado = false,
  });

  Movimiento copyWith({
    String? id,
    double? monto,
    DateTime? fecha,
    MovimientoType? tipo,
    String? concepto,
    String? categoria,
    String? productoId,
    String? clienteId,
    String? proveedorId,
    int? cantidad,
    bool? esFiado,
  }) {
    return Movimiento(
      id: id ?? this.id,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      tipo: tipo ?? this.tipo,
      concepto: concepto ?? this.concepto,
      categoria: categoria ?? this.categoria,
      productoId: productoId ?? this.productoId,
      clienteId: clienteId ?? this.clienteId,
      proveedorId: proveedorId ?? this.proveedorId,
      cantidad: cantidad ?? this.cantidad,
      esFiado: esFiado ?? this.esFiado,
    );
  }
}
