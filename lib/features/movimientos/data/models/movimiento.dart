import 'dart:convert';
import '../../../../core/base_crud_viewmodel.dart';

enum MovimientoType { ingreso, egreso, actividad }

class Movimiento implements HasId {
  @override
  final String id;
  final double monto;
  final DateTime fecha;
  final MovimientoType tipo;
  final String concepto;
  final String? categoria;
  final String? productoId;
  final String? clienteId;
  final String? proveedorId;
  final String? localId;
  final int? cantidad;
  final bool esFiado;
  final String? productosJson;

  Movimiento({
    required this.id,
    required this.monto,
    required this.fecha,
    required this.tipo,
    required this.concepto,
    this.categoria,
    this.productoId,
    this.clienteId,
    this.proveedorId,
    this.localId,
    this.cantidad,
    this.esFiado = false,
    this.productosJson,
  });

  List<MovimientoProducto> get productos {
    if (productosJson == null || productosJson!.isEmpty) {
      return [];
    }
    try {
      final list = jsonDecode(productosJson!) as List;
      return list.map((p) => MovimientoProducto.fromJson(p)).toList();
    } catch (_) {
      return [];
    }
  }

  bool get isMultiProducto => productos.isNotEmpty;

  Movimiento copyWith({
    String? id,
    double? monto,
    DateTime? fecha,
    MovimientoType? tipo,
    String? concepto,
    String? categoria,
    String? productoId,
    String? clienteId,
    String? proveedorId,
    String? localId,
    int? cantidad,
    bool? esFiado,
    String? productosJson,
  }) {
    return Movimiento(
      id: id ?? this.id,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      tipo: tipo ?? this.tipo,
      concepto: concepto ?? this.concepto,
      categoria: categoria ?? this.categoria,
      productoId: productoId ?? this.productoId,
      clienteId: clienteId ?? this.clienteId,
      proveedorId: proveedorId ?? this.proveedorId,
      localId: localId ?? this.localId,
      cantidad: cantidad ?? this.cantidad,
      esFiado: esFiado ?? this.esFiado,
      productosJson: productosJson ?? this.productosJson,
    );
  }
}

class MovimientoProducto {
  final String productoId;
  final String nombre;
  final int cantidad;
  final double precioUnitario;

  MovimientoProducto({
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

  factory MovimientoProducto.fromJson(Map<String, dynamic> json) =>
      MovimientoProducto(
        productoId: json['productoId'] as String,
        nombre: json['nombre'] as String,
        cantidad: json['cantidad'] as int,
        precioUnitario: (json['precioUnitario'] as num).toDouble(),
      );
}
