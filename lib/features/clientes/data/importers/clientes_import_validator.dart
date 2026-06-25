import 'package:drift/drift.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/excel_import_service.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:uuid/uuid.dart';

class ClientesImportValidator {
  static const List<String> requiredColumns = [
    'nombre',
    'telefono',
  ];

  static const List<String> optionalColumns = [
    'id',
    'email',
    'localid',
    'esfiado',
    'saldopendiente',
  ];

  static const List<String> allColumns = [
    ...requiredColumns,
    ...optionalColumns,
  ];

  /// Validate parsed rows and convert to Cliente models.
  static ValidatedImportResult<Cliente> validate(ImportResult result) {
    final errors = <RowValidationError>[];
    final validRows = <Cliente>[];
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
      final email = data['email']?.trim();
      final localId = data['localid']?.trim();
      final esFiado = _parseBool(data['esfiado']);
      final saldoPendiente = _parseDouble(data['saldopendiente']) ?? 0.0;

      validRows.add(Cliente(
        id: id,
        nombre: nombre.trim(),
        telefono: telefono.trim(),
        email: email?.isNotEmpty == true ? email : null,
        localId: localId?.isNotEmpty == true ? localId : null,
        esFiado: esFiado,
        saldoPendiente: saldoPendiente,
        isActivo: true,
      ));
    }

    return ValidatedImportResult(validRows: validRows, errors: errors);
  }

  /// Batch insert validated clientes in a single transaction.
  static Future<void> batchImport(
    AppDatabase db,
    List<Cliente> clientes,
  ) async {
    await db.transaction(() async {
      for (final cliente in clientes) {
        await db.into(db.clientes).insert(
          ClientesCompanion.insert(
            id: cliente.id,
            nombre: cliente.nombre,
            telefono: Value<String?>(cliente.telefono),
            email: cliente.email != null
                ? Value(cliente.email)
                : const Value.absent(),
            localId: cliente.localId != null
                ? Value(cliente.localId)
                : const Value.absent(),
            esFiado: Value(cliente.esFiado),
            saldoPendiente: Value(cliente.saldoPendiente),
            isActivo: Value(cliente.isActivo),
            syncStatus: const Value('pending_upload'),
          ),
        );
      }
    });
  }

  static bool _parseBool(String? value) {
    if (value == null) return false;
    final v = value.trim().toLowerCase();
    return v == 'true' ||
        v == '1' ||
        v == 'sí' ||
        v == 'si' ||
        v == 'yes';
  }

  static double? _parseDouble(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return double.tryParse(value.trim().replaceAll(',', ''));
  }
}
