import 'package:InkTrack/core/base_crud_viewmodel.dart';

class Cliente implements HasId {
  @override
  final String id;
  final String nombre;
  final String telefono;
  final String email;
  final bool esFiado;
  final double saldoPendiente;

  Cliente({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.email,
    this.esFiado = false,
    this.saldoPendiente = 0.0,
  });

  Cliente copyWith({
    String? id,
    String? nombre,
    String? telefono,
    String? email,
    bool? esFiado,
    double? saldoPendiente,
  }) {
    return Cliente(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      esFiado: esFiado ?? this.esFiado,
      saldoPendiente: saldoPendiente ?? this.saldoPendiente,
    );
  }
}
