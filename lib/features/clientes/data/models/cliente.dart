import 'package:InkTrack/core/base_crud_viewmodel.dart';

class Cliente implements HasId {
  @override
  final String id;
  final String nombre;
  final String telefono;
  final String? email;
  final String? localId;
  final bool esFiado;
  final double saldoPendiente;
  final bool isActivo;
  final DateTime? updatedAt;
  final String? syncStatus;
  final double? limiteCredito;
  final DateTime? promesaPago;

  Cliente({
    required this.id,
    required this.nombre,
    required this.telefono,
    this.email,
    this.localId,
    this.esFiado = false,
    this.saldoPendiente = 0.0,
    this.isActivo = true,
    this.updatedAt,
    this.syncStatus,
    this.limiteCredito,
    this.promesaPago,
  });

  Cliente copyWith({
    String? id,
    String? nombre,
    String? telefono,
    String? email,
    String? localId,
    bool? esFiado,
    double? saldoPendiente,
    bool? isActivo,
    DateTime? updatedAt,
    String? syncStatus,
    double? limiteCredito,
    DateTime? promesaPago,
  }) {
    return Cliente(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      localId: localId ?? this.localId,
      esFiado: esFiado ?? this.esFiado,
      saldoPendiente: saldoPendiente ?? this.saldoPendiente,
      isActivo: isActivo ?? this.isActivo,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      limiteCredito: limiteCredito ?? this.limiteCredito,
      promesaPago: promesaPago ?? this.promesaPago,
    );
  }
}


