import 'package:drift/drift.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/excel_import_service.dart';
import 'package:InkTrack/features/locales/data/models/local.dart';
import 'package:uuid/uuid.dart';

class LocalesImportValidator {
  static const List<String> requiredColumns = [
    'nombre',
  ];

  static const List<String> optionalColumns = [
    'id',
    'direccion',
    'telefono',
    'tipo',
    'userid',
  ];

  static const List<String> allColumns = [
    ...requiredColumns,
    ...optionalColumns,
  ];

  static ValidatedImportResult<Local> validate(ImportResult result) {
    final errors = <RowValidationError>[];
    final validRows = <Local>[];
    final _uuid = const Uuid();

    for (final row in result.rows) {
      final rowErrors = <String>[];
      final data = row.data;

      final nombre = data['nombre'] ?? '';
      if (nombre.trim().isEmpty) {
        rowErrors.add('El campo "nombre" es requerido');
      }

      if (rowErrors.isNotEmpty) {
        errors.add(RowValidationError(
          rowIndex: row.index + 1,
          message: rowErrors.join('; '),
        ));
        continue;
      }

      final id = data['id']?.trim().isNotEmpty == true
          ? data['id']!
          : _uuid.v4();
      final direccion = data['direccion']?.trim();
      final telefono = data['telefono']?.trim();
      final tipo = data['tipo']?.trim().isNotEmpty == true
          ? data['tipo']!.trim()
          : 'tienda';
      final userId = data['userid']?.trim();

      validRows.add(Local(
        id: id,
        nombre: nombre.trim(),
        direccion: direccion?.isNotEmpty == true ? direccion : null,
        telefono: telefono?.isNotEmpty == true ? telefono : null,
        tipo: tipo,
        userId: userId?.isNotEmpty == true ? userId : null,
        isActivo: true,
      ));
    }

    return ValidatedImportResult(validRows: validRows, errors: errors);
  }

  static Future<void> batchImport(
    AppDatabase db,
    List<Local> locales,
  ) async {
    await db.transaction(() async {
      for (final local in locales) {
        await db.into(db.locales).insert(
          LocalesCompanion.insert(
            id: local.id,
            nombre: local.nombre,
            direccion: Value(local.direccion),
            telefono: Value(local.telefono),
            tipo: Value(local.tipo),
            userId: Value(local.userId),
            isActivo: Value(local.isActivo),
            syncStatus: const Value('pending_upload'),
          ),
        );
      }
    });
  }
}
