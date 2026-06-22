import 'package:InkTrack/core/data/import/module_validator.dart';
import 'package:InkTrack/core/services/import_service.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';

/// Validator and mapper for Cliente imports.
///
/// Required fields: nombre, telefono
class ClienteValidator implements ModuleValidator<Cliente> {
  static const requiredFields = ['nombre', 'telefono'];

  @override
  Cliente mapFromRow(Map<String, dynamic> row) {
    return Cliente(
      id: _toString(row['id']),
      nombre: _toString(row['nombre']),
      telefono: _toString(row['telefono']),
      email: _toStringOrNull(row['email']),
      localId: _toStringOrNull(row['local_id']),
      esFiado: row['es_fiado'] != null ? _toBool(row['es_fiado']) : false,
      saldoPendiente: _toDouble(row['saldo_pendiente']),
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
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value.trim()) ?? 0.0;
    return 0.0;
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
