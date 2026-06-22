import 'package:InkTrack/core/data/import/module_validator.dart';
import 'package:InkTrack/core/services/import_service.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';

/// Validator and mapper for Producto imports.
///
/// Required fields: nombre, cantidad, precio, categoria, proveedorId
class ProductoValidator implements ModuleValidator<Producto> {
  static const requiredFields = [
    'nombre',
    'cantidad',
    'precio',
    'categoria',
    'proveedorId',
  ];

  @override
  Producto mapFromRow(Map<String, dynamic> row) {
    return Producto(
      id: _toString(row['id']),
      nombre: _toString(row['nombre']),
      cantidad: _toInt(row['cantidad']),
      precioVenta: _toDouble(row['precio']),
      precioCompra: _toDoubleOrNull(row['precio_compra']),
      unidadesPorPaquete: _toInt(row['unidades_por_paquete'], fallback: 1),
      esPaquete: _toBool(row['es_paquete']),
      categoria: _toString(row['categoria']),
      proveedorId: _toString(row['proveedorId']),
      stockMinimo: _toInt(row['stock_minimo'], fallback: 5),
      localId: _toStringOrNull(row['local_id']),
      codigoBarras: _toStringOrNull(row['codigo_barras']),
      codigoPersonalizado: _toStringOrNull(row['codigo_personalizado']),
      proveedorNombre: _toStringOrNull(row['proveedor_nombre']),
      isActivo: row['is_activo'] != null ? _toBool(row['is_activo']) : true,
    );
  }

  @override
  List<ImportError> validate(List<Map<String, dynamic>> rows) {
    final errors = <ImportError>[];
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      final rowNum = i + 1; // 1-based row number for user feedback

      for (final field in requiredFields) {
        final value = row[field];
        if (value == null || (value is String && value.trim().isEmpty)) {
          errors.add(ImportError(rowNum, field, '$field es requerido'));
        }
      }

      // Validate numeric fields are actually numbers
      _validateNumeric(row, rowNum, 'cantidad', errors);
      _validateNumeric(row, rowNum, 'precio', errors);
    }
    return errors;
  }

  // -----------------------------------------------------------------------
  // Helpers
  // -----------------------------------------------------------------------

  void _validateNumeric(
    Map<String, dynamic> row,
    int rowNum,
    String field,
    List<ImportError> errors,
  ) {
    final value = row[field];
    if (value == null) return; // handled by required check
    if (value is num) return; // already numeric
    if (value is String && value.trim().isEmpty) return; // handled by required
    if (value is String && num.tryParse(value.trim()) != null) return;

    errors.add(ImportError(rowNum, field, '$field debe ser un número'));
  }

  static String _toString(dynamic value) => value?.toString() ?? '';
  static String? _toStringOrNull(dynamic value) => value?.toString();
  static int _toInt(dynamic value, {int fallback = 0}) {
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value.trim()) ?? fallback;
    return fallback;
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value.trim()) ?? 0.0;
    return 0.0;
  }

  static double? _toDoubleOrNull(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value.trim());
      return parsed;
    }
    return null;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.trim() == 'true' ||
          value.trim() == '1' ||
          value.trim() == 'yes' ||
          value.trim() == 'TRUE';
    }
    return false;
  }
}
