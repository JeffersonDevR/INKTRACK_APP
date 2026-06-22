import 'package:InkTrack/core/base_crud_viewmodel.dart';

class Local implements HasId {
  @override
  final String id;
  final String nombre;
  final String? direccion;
  final String? telefono;
  final String tipo;
  final String? userId;
  final bool isActivo;

  Local({
    required this.id,
    required this.nombre,
    this.direccion,
    this.telefono,
    this.tipo = 'tienda',
    this.userId,
    this.isActivo = true,
  });

  Local copyWith({
    String? id,
    String? nombre,
    String? direccion,
    String? telefono,
    String? tipo,
    String? userId,
    bool? isActivo,
  }) {
    return Local(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      tipo: tipo ?? this.tipo,
      userId: userId ?? this.userId,
      isActivo: isActivo ?? this.isActivo,
    );
  }
}
