import '../../../../core/base_crud_viewmodel.dart';

class Proveedor implements HasId {
  @override
  final String id;
  final String nombre;
  final String telefono;
  final List<String> _diasVisita;
  List<String> get diasVisita => List.unmodifiable(_diasVisita);

  Proveedor({
    required this.id,
    required this.nombre,
    required this.telefono,
    required List<String> diasVisita,
  }) : _diasVisita = diasVisita;

  Proveedor copyWith({
    String? id,
    String? nombre,
    String? telefono,
    List<String>? diasVisita,
  }) {
    return Proveedor(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      diasVisita: diasVisita ?? _diasVisita,
    );
  }
}
