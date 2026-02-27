import '../../../core/base_crud_viewmodel.dart';

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
}
