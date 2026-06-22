import '../../../../core/base_crud_viewmodel.dart';

class Proveedor implements HasId {
  @override
  final String id;
  final String nombre;
  final String telefono;
  final List<String> _diasVisita;
  List<String> get diasVisita => List.unmodifiable(_diasVisita);

  final int? periodoVisita;
  final DateTime? ultimaVisita;
  final DateTime? proximaVisita;

  String get diasVisitaShort {
    if (periodoVisita != null) {
      return periodoVisita == 1
          ? 'Cada mes'
          : 'Cada $periodoVisita meses';
    }
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
    this.periodoVisita,
    this.ultimaVisita,
    this.proximaVisita,
    this.localId,
    this.isActivo = true,
  }) : _diasVisita = diasVisita;

  Proveedor copyWith({
    String? id,
    String? nombre,
    String? telefono,
    List<String>? diasVisita,
    int? periodoVisita,
    DateTime? ultimaVisita,
    DateTime? proximaVisita,
    String? localId,
    bool? isActivo,
  }) {
    return Proveedor(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      diasVisita: diasVisita ?? _diasVisita,
      periodoVisita: periodoVisita ?? this.periodoVisita,
      ultimaVisita: ultimaVisita ?? this.ultimaVisita,
      proximaVisita: proximaVisita ?? this.proximaVisita,
      localId: localId ?? this.localId,
      isActivo: isActivo ?? this.isActivo,
    );
  }
}
