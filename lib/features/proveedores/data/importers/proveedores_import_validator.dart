import 'package:drift/drift.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/excel_import_service.dart';
import 'package:InkTrack/features/proveedores/data/models/proveedor.dart';
import 'package:uuid/uuid.dart';

class ProveedoresImportValidator {
  static const List<String> requiredColumns = [
    'nombre',
    'telefono',
  ];

  static const List<String> optionalColumns = [
    'id',
    'diasvisita',
    'periodovisita',
    'localid',
  ];

  static const List<String> allColumns = [
    ...requiredColumns,
    ...optionalColumns,
  ];

  static ValidatedImportResult<Proveedor> validate(ImportResult result) {
    final errors = <RowValidationError>[];
    final validRows = <Proveedor>[];
    final _uuid = const Uuid();

    for (final row in result.rows) {
      final rowErrors = <String>[];
      final data = row.data;

      final nombre = data['nombre'] ?? '';
      if (nombre.trim().isEmpty) {
        rowErrors.add('El campo "nombre" es requerido');
      }

      final telefono = data['telefono'] ?? '';
      if (telefono.trim().isEmpty) {
        rowErrors.add('El campo "telefono" es requerido');
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
      final localId = data['localid']?.trim();
      final periodoVisita = _parseInt(data['periodovisita']);

      List<String> diasVisita = [];
      final diasVisitaRaw = data['diasvisita'];
      if (diasVisitaRaw != null && diasVisitaRaw.trim().isNotEmpty) {
        diasVisita = diasVisitaRaw
            .split(',')
            .map((d) => d.trim())
            .where((d) => d.isNotEmpty)
            .toList();
      }

      validRows.add(Proveedor(
        id: id,
        nombre: nombre.trim(),
        telefono: telefono.trim(),
        diasVisita: diasVisita,
        periodoVisita: periodoVisita,
        localId: localId?.isNotEmpty == true ? localId : null,
        isActivo: true,
      ));
    }

    return ValidatedImportResult(validRows: validRows, errors: errors);
  }

  static Future<void> batchImport(
    AppDatabase db,
    List<Proveedor> proveedores,
  ) async {
    await db.transaction(() async {
      for (final proveedor in proveedores) {
        await db.into(db.proveedores).insert(
          ProveedoresCompanion.insert(
            id: proveedor.id,
            nombre: proveedor.nombre,
            telefono: Value<String?>(proveedor.telefono),
            diasVisita: proveedor.diasVisita,
            periodoVisita: Value(proveedor.periodoVisita),
            ultimaVisita: const Value<DateTime?>(null),
            proximaVisita: const Value<DateTime?>(null),
            localId: proveedor.localId != null
                ? Value(proveedor.localId)
                : const Value.absent(),
            isActivo: Value(proveedor.isActivo),
            syncStatus: const Value('pending_upload'),
          ),
        );
      }
    });
  }

  static int? _parseInt(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return int.tryParse(value.trim());
  }
}
