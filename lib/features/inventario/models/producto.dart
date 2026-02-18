import '../../../core/base_crud_viewmodel.dart';

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
}
