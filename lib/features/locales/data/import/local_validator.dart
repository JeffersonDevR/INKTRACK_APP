import 'package:InkTrack/core/data/import/module_validator.dart';
import 'package:InkTrack/core/services/import_service.dart';
import 'package:InkTrack/features/locales/data/models/local.dart';

/// Validator and mapper for Local imports.
///
/// Required fields: nombre
class LocalValidator implements ModuleValidator<Local> {
  static const requiredFields = ['nombre'];

  @override
  Local mapFromRow(Map<String, dynamic> row) {
    return Local(
      id: _toString(row['id']),
      nombre: _toString(row['nombre']),
      direccion: _toStringOrNull(row['direccion']),
      telefono: _toStringOrNull(row['telefono']),
      tipo: _toString(row['tipo'], fallback: 'tienda'),
      userId: _toStringOrNull(row['user_id']),
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

  static String _toString(dynamic value, {String fallback = ''}) =>
      value?.toString() ?? fallback;

  static String? _toStringOrNull(dynamic value) => value?.toString();

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
