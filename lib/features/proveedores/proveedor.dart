import '../../core/base_crud_viewmodel.dart';

class Proveedor implements HasId {
  @override
  final String id;
  final String nombre;
  final String telefono;
  final int diasParaLlegar;
  final String diaDeLlegada;

  Proveedor({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.diasParaLlegar,
    required this.diaDeLlegada,
  });
}
