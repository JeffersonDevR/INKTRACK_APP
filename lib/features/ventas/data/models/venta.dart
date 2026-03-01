import 'package:InkTrack/core/base_crud_viewmodel.dart';

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

  Venta copyWith({
    String? id,
    double? monto,
    DateTime? fecha,
    String? clienteId,
    String? clienteNombre,
    String? concepto,
  }) {
    return Venta(
      id: id ?? this.id,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      clienteId: clienteId ?? this.clienteId,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      concepto: concepto ?? this.concepto,
    );
  }
}
