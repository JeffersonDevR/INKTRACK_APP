import '../../../../core/base_crud_viewmodel.dart';

class Proveedor implements HasId {
  @override
  final String id;
  final String nombre;
  final String telefono;
  final List<String> _diasVisita;
  List<String> get diasVisita => List.unmodifiable(_diasVisita);

  String get diasVisitaShort {
    const dayMap = {
      'Lunes': 'Lun',
      'Martes': 'Mar',
      'Miércoles': 'Mié',
      'Jueves': 'Jue',
      'Viernes': 'Vie',
      'Sábado': 'Sáb',
      'Domingo': 'Dom',
    };
    return _diasVisita.map((d) => dayMap[d] ?? d).join(', ');
  }

  final String? localId;
  final bool isActivo;

  Proveedor({
    required this.id,
    required this.nombre,
    required this.telefono,
    required List<String> diasVisita,
    this.localId,
    this.isActivo = true,
  }) : _diasVisita = diasVisita;

  Proveedor copyWith({
    String? id,
    String? nombre,
    String? telefono,
    List<String>? diasVisita,
    String? localId,
    bool? isActivo,
  }) {
    return Proveedor(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      diasVisita: diasVisita ?? _diasVisita,
      localId: localId ?? this.localId,
      isActivo: isActivo ?? this.isActivo,
    );
  }
}
