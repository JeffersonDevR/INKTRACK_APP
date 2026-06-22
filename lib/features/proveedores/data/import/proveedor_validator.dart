import 'package:InkTrack/core/data/import/module_validator.dart';
import 'package:InkTrack/core/services/import_service.dart';
import 'package:InkTrack/features/proveedores/data/models/proveedor.dart';

/// Validator and mapper for Proveedor imports.
///
/// Required fields: nombre, telefono
class ProveedorValidator implements ModuleValidator<Proveedor> {
  static const requiredFields = ['nombre', 'telefono'];

  @override
  Proveedor mapFromRow(Map<String, dynamic> row) {
    // Parse comma-separated days
    List<String> diasVisita = [];
    final rawDias = row['dias_visita'];
    if (rawDias is String && rawDias.trim().isNotEmpty) {
      diasVisita = rawDias.split(',').map((d) => d.trim()).toList();
    }

    return Proveedor(
      id: _toString(row['id']),
      nombre: _toString(row['nombre']),
      telefono: _toString(row['telefono']),
      diasVisita: diasVisita,
      periodoVisita: _toIntOrNull(row['periodo_visita']),
      ultimaVisita: _parseDate(row['ultima_visita']),
      proximaVisita: _parseDate(row['proxima_visita']),
      localId: _toStringOrNull(row['local_id']),
      isActivo: row['is_activo'] != null ? _toBool(row['is_activo']) : true,
    );
  }

  @override
  List<ImportError> validate(List<Map<String, dynamic>> rows) {
    final errors = <ImportError>[];
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      final rowNum = i + 1;

      for (final field in requiredFields) {
        final value = row[field];
        if (value == null || (value is String && value.trim().isEmpty)) {
          errors.add(ImportError(rowNum, field, '$field es requerido'));
        }
      }
    }
    return errors;
  }

  // -----------------------------------------------------------------------
  // Helpers
  // -----------------------------------------------------------------------

  static String _toString(dynamic value) => value?.toString() ?? '';
  static String? _toStringOrNull(dynamic value) => value?.toString();

  static int? _toIntOrNull(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value.trim());
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
