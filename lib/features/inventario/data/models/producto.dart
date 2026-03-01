import 'package:InkTrack/core/base_crud_viewmodel.dart';

class Producto implements HasId {
  @override
  final String id;
  final String nombre;
  final int cantidad;
  final double precio;
  final String categoria;
  final String proveedorId;
  final int stockMinimo;

  /// Optional barcode/QR code.
  final String? codigoBarras;

  /// When no provider is selected, optional name.
  final String? proveedorNombre;

  bool get stockBajo {
    return cantidad <= stockMinimo;
  }

  Producto({
    required this.id,
    required this.nombre,
    required this.cantidad,
    required this.precio,
    required this.categoria,
    required this.proveedorId,
    this.stockMinimo = 5,
    this.codigoBarras,
    this.proveedorNombre,
  });

  Producto copyWith({
    String? id,
    String? nombre,
    int? cantidad,
    double? precio,
    String? categoria,
    String? proveedorId,
    int? stockMinimo,
    String? codigoBarras,
    String? proveedorNombre,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      cantidad: cantidad ?? this.cantidad,
      precio: precio ?? this.precio,
      categoria: categoria ?? this.categoria,
      proveedorId: proveedorId ?? this.proveedorId,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      proveedorNombre: proveedorNombre ?? this.proveedorNombre,
    );
  }
}
