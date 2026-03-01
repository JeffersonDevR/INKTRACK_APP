import '../../../core/base_crud_viewmodel.dart';

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
}
