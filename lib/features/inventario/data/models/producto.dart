import 'package:InkTrack/core/base_crud_viewmodel.dart';

class Producto implements HasId {
  @override
  final String id;
  final String nombre;
  final int cantidad;
  final double precioVenta;
  final double? precioCompra;
  final int unidadesPorPaquete;
  final bool esPaquete;
  final String categoria;
  final String proveedorId;
  final int stockMinimo;
  final String? localId;

  final String? codigoBarras;
  final String? codigoPersonalizado;

  final String? proveedorNombre;
  final bool isActivo;
  final String unidad;
  final DateTime? updatedAt;

  double get ganancia => precioVenta - (precioCompra ?? 0.0);

  bool get stockBajo {
    return cantidad <= stockMinimo;
  }

  Producto({
    required this.id,
    required this.nombre,
    required this.cantidad,
    required this.precioVenta,
    this.precioCompra,
    this.unidadesPorPaquete = 1,
    this.esPaquete = false,
    required this.categoria,
    required this.proveedorId,
    this.stockMinimo = 5,
    this.localId,
    this.codigoBarras,
    this.codigoPersonalizado,
    this.proveedorNombre,
    this.isActivo = true,
    this.unidad = 'unidad',
    this.updatedAt,
  });

  Producto copyWith({
    String? id,
    String? nombre,
    int? cantidad,
    double? precioVenta,
    double? precioCompra,
    int? unidadesPorPaquete,
    bool? esPaquete,
    String? categoria,
    String? proveedorId,
    int? stockMinimo,
    String? localId,
    String? codigoBarras,
    String? codigoPersonalizado,
    String? proveedorNombre,
    bool? isActivo,
    String? unidad,
    DateTime? updatedAt,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      cantidad: cantidad ?? this.cantidad,
      precioVenta: precioVenta ?? this.precioVenta,
      precioCompra: precioCompra ?? this.precioCompra,
      unidadesPorPaquete: unidadesPorPaquete ?? this.unidadesPorPaquete,
      esPaquete: esPaquete ?? this.esPaquete,
      categoria: categoria ?? this.categoria,
      proveedorId: proveedorId ?? this.proveedorId,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      localId: localId ?? this.localId,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      codigoPersonalizado: codigoPersonalizado ?? this.codigoPersonalizado,
      proveedorNombre: proveedorNombre ?? this.proveedorNombre,
      isActivo: isActivo ?? this.isActivo,
      unidad: unidad ?? this.unidad,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
