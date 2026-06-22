import 'package:InkTrack/core/services/import_service.dart';

/// Abstract validator for module-specific import validation and mapping.
///
/// Each module (productos, clientes, proveedores, locales) implements this
/// interface to define:
/// - [mapFromRow]: convert a parsed row (header → value map) into the
///   domain model [T].
/// - [validate]: validate all parsed rows and return a list of [ImportError]s.
abstract class ModuleValidator<T> {
  /// Maps a single parsed row (column name → value) into a domain model [T].
  T mapFromRow(Map<String, dynamic> row);

  /// Validates all [rows] and returns a list of [ImportError]s.
  ///
  /// Returns an empty list if all rows are valid.
  List<ImportError> validate(List<Map<String, dynamic>> rows);
}
