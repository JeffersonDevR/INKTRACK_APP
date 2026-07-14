import 'package:InkTrack/core/base_crud_viewmodel.dart';

class Abono implements HasId {
  @override
  final String id;
  final String clienteId;
  final String? ventaId;
  final double monto;
  final DateTime fecha;
  final double saldoRestante;
  final String? concepto;
  final String syncStatus;
  final DateTime? lastSyncedAt;
  final DateTime updatedAt;

  Abono({
    required this.id,
    required this.clienteId,
    this.ventaId,
    required this.monto,
    required this.fecha,
    required this.saldoRestante,
    this.concepto,
    this.syncStatus = 'pending',
    this.lastSyncedAt,
    required this.updatedAt,
  });

  Abono copyWith({
    String? id,
    String? clienteId,
    String? ventaId,
    double? monto,
    DateTime? fecha,
    double? saldoRestante,
    String? concepto,
    String? syncStatus,
    DateTime? lastSyncedAt,
    DateTime? updatedAt,
  }) {
    return Abono(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      ventaId: ventaId ?? this.ventaId,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      saldoRestante: saldoRestante ?? this.saldoRestante,
      concepto: concepto ?? this.concepto,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
