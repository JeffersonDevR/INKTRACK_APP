import 'dart:convert';
import 'package:InkTrack/core/base_crud_viewmodel.dart';

class Venta implements HasId {
  @override
  final String id;
  final double monto;
  final DateTime fecha;
  final String? clienteId;
  final String? productoId;
  final String? localId;
  final int cantidad;
  final bool esFiado;

  /// Name when client is not registered (walk-in).
  final String? clienteNombre;
  final String? concepto;

  /// Multiple products support (JSON string)
  final String? productosJson;

  Venta({
    required this.id,
    required this.monto,
    required this.fecha,
    this.clienteId,
    this.productoId,
    this.localId,
    this.cantidad = 0,
    this.esFiado = false,
    this.clienteNombre,
    this.concepto,
    this.productosJson,
  });

  List<VentaItem> get productos {
    if (productosJson == null || productosJson!.isEmpty) {
      return [];
    }
    try {
      final list = jsonDecode(productosJson!) as List;
      return list.map((p) => VentaItem.fromJson(p)).toList();
    } catch (_) {
      return [];
    }
  }

  bool get isMultiProducto => productos.isNotEmpty;

  Venta copyWith({
    String? id,
    double? monto,
    DateTime? fecha,
    String? clienteId,
    String? productoId,
    String? localId,
    int? cantidad,
    bool? esFiado,
    String? clienteNombre,
    String? concepto,
    String? productosJson,
  }) {
    return Venta(
      id: id ?? this.id,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      clienteId: clienteId ?? this.clienteId,
      productoId: productoId ?? this.productoId,
      localId: localId ?? this.localId,
      cantidad: cantidad ?? this.cantidad,
      esFiado: esFiado ?? this.esFiado,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      concepto: concepto ?? this.concepto,
      productosJson: productosJson ?? this.productosJson,
    );
  }
}

class VentaItem {
  final String productoId;
  final String nombre;
  final int cantidad;
  final double precioUnitario;

  VentaItem({
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

  factory VentaItem.fromJson(Map<String, dynamic> json) => VentaItem(
    productoId: json['productoId'] as String,
    nombre: json['nombre'] as String,
    cantidad: json['cantidad'] as int,
    precioUnitario: (json['precioUnitario'] as num).toDouble(),
  );
}
