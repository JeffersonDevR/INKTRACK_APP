import 'dart:convert';
import '../../../../core/base_crud_viewmodel.dart';

class PedidoProveedor implements HasId {
  @override
  final String id;
  final String proveedorId;
  final String? proveedorNombre;
  final DateTime fechaPedido;
  final DateTime fechaEntrega;
  final List<PedidoProducto> productos;
  final double montoTotal;
  final bool isEntregado;
  final String? notas;

  PedidoProveedor({
    required this.id,
    required this.proveedorId,
    this.proveedorNombre,
    required this.fechaPedido,
    required this.fechaEntrega,
    required this.productos,
    required this.montoTotal,
    this.isEntregado = false,
    this.notas,
  });

  String get productosJson =>
      jsonEncode(productos.map((p) => p.toJson()).toList());

  static List<PedidoProducto> productosFromJson(String json) {
    final list = jsonDecode(json) as List;
    return list.map((p) => PedidoProducto.fromJson(p)).toList();
  }

  PedidoProveedor copyWith({
    String? id,
    String? proveedorId,
    String? proveedorNombre,
    DateTime? fechaPedido,
    DateTime? fechaEntrega,
    List<PedidoProducto>? productos,
    double? montoTotal,
    bool? isEntregado,
    String? notas,
  }) {
    return PedidoProveedor(
      id: id ?? this.id,
      proveedorId: proveedorId ?? this.proveedorId,
      proveedorNombre: proveedorNombre ?? this.proveedorNombre,
      fechaPedido: fechaPedido ?? this.fechaPedido,
      fechaEntrega: fechaEntrega ?? this.fechaEntrega,
      productos: productos ?? this.productos,
      montoTotal: montoTotal ?? this.montoTotal,
      isEntregado: isEntregado ?? this.isEntregado,
      notas: notas ?? this.notas,
    );
  }
}

class PedidoProducto {
  final String productoId;
  final String nombre;
  final int cantidad;
  final double precioUnitario;

  PedidoProducto({
    required this.productoId,
    required this.nombre,
    required this.cantidad,
    required this.precioUnitario,
  });

  double get subtotal => cantidad * precioUnitario;

  Map<String, dynamic> toJson() => {
    'productoId': productoId,
    'nombre': nombre,
    'cantidad': cantidad,
    'precioUnitario': precioUnitario,
  };

  factory PedidoProducto.fromJson(Map<String, dynamic> json) => PedidoProducto(
    productoId: json['productoId'] as String,
    nombre: json['nombre'] as String,
    cantidad: json['cantidad'] as int,
    precioUnitario: (json['precioUnitario'] as num).toDouble(),
  );

  PedidoProducto copyWith({
    String? productoId,
    String? nombre,
    int? cantidad,
    double? precioUnitario,
  }) {
    return PedidoProducto(
      productoId: productoId ?? this.productoId,
      nombre: nombre ?? this.nombre,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
    );
  }
}
