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
  final double cantidad;
  final bool esFiado;

  /// Name when client is not registered (walk-in).
  final String? clienteNombre;
  final String? concepto;

  /// Multiple products support (JSON string)
  final String? productosJson;

  final DateTime? updatedAt;
  final String? syncStatus;

  Venta({
    required this.id,
    required this.monto,
    required this.fecha,
    this.clienteId,
    this.productoId,
    this.localId,
    this.cantidad = 0.0,
    this.esFiado = false,
    this.clienteNombre,
    this.concepto,
    this.productosJson,
    this.updatedAt,
    this.syncStatus,
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
    double? cantidad,
    bool? esFiado,
    String? clienteNombre,
    String? concepto,
    String? productosJson,
    DateTime? updatedAt,
    String? syncStatus,
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
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}


class VentaItem {
  final String productoId;
  final String nombre;
  final double cantidad;
  final double precioUnitario;
  final bool isUnidad;

  VentaItem({
    required this.productoId,
    required this.nombre,
    required this.cantidad,
    required this.precioUnitario,
    this.isUnidad = false,
  });

  double get subtotal => cantidad * precioUnitario;

  Map<String, dynamic> toJson() => {
    'productoId': productoId,
    'nombre': nombre,
    'cantidad': cantidad,
    'precioUnitario': precioUnitario,
    'isUnidad': isUnidad,
  };

  factory VentaItem.fromJson(Map<String, dynamic> json) => VentaItem(
    productoId: json['productoId'] as String,
    nombre: json['nombre'] as String,
    cantidad: (json['cantidad'] as num).toDouble(),
    precioUnitario: (json['precioUnitario'] as num).toDouble(),
    isUnidad: json['isUnidad'] as bool? ?? false,
  );
}
