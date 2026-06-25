import 'package:drift/drift.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/excel_import_service.dart';
import 'package:InkTrack/features/ventas/data/models/venta.dart';
import 'package:uuid/uuid.dart';

class VentasImportValidator {
  static const List<String> requiredColumns = [
    'monto',
    'fecha',
  ];

  static const List<String> optionalColumns = [
    'id',
    'clienteid',
    'clientenombre',
    'localid',
    'concepto',
    'productosjson',
  ];

  static const List<String> allColumns = [
    ...requiredColumns,
    ...optionalColumns,
  ];

  static ValidatedImportResult<Venta> validate(ImportResult result) {
    final errors = <RowValidationError>[];
    final validRows = <Venta>[];
    final _uuid = const Uuid();

    for (final row in result.rows) {
      final rowErrors = <String>[];
      final data = row.data;

      final monto = _parseDouble(data['monto']);
      if (monto == null) {
        rowErrors.add('El campo "monto" debe ser un número');
      }

      final fechaStr = data['fecha'] ?? '';
      DateTime? fecha;
      if (fechaStr.trim().isNotEmpty) {
        fecha = _parseDate(fechaStr);
        if (fecha == null) {
          rowErrors.add(
            'El campo "fecha" no tiene un formato válido (use dd/MM/yyyy o yyyy-MM-dd)',
          );
        }
      } else {
        rowErrors.add('El campo "fecha" es requerido');
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
      final clienteId = data['clienteid']?.trim();
      final clienteNombre = data['clientenombre']?.trim();
      final localId = data['localid']?.trim();
      final concepto = data['concepto']?.trim();

      validRows.add(Venta(
        id: id,
        monto: monto!,
        fecha: fecha!,
        clienteId: clienteId?.isNotEmpty == true ? clienteId : null,
        clienteNombre: clienteNombre?.isNotEmpty == true ? clienteNombre : null,
        localId: localId?.isNotEmpty == true ? localId : null,
        concepto: concepto?.isNotEmpty == true ? concepto : null,
      ));
    }

    return ValidatedImportResult(validRows: validRows, errors: errors);
  }

  static Future<void> batchImport(
    AppDatabase db,
    List<Venta> ventas,
  ) async {
    await db.transaction(() async {
      for (final venta in ventas) {
        await db.into(db.ventas).insert(
          VentasCompanion.insert(
            id: venta.id,
            monto: venta.monto,
            fecha: venta.fecha,
            clienteId: Value(venta.clienteId),
            clienteNombre: Value(venta.clienteNombre),
            localId: venta.localId != null
                ? Value(venta.localId)
                : const Value.absent(),
            concepto: Value(venta.concepto),
            productosJson: const Value.absent(),
            syncStatus: const Value('pending_upload'),
          ),
        );
      }
    });
  }

  static DateTime? _parseDate(String value) {
    final trimmed = value.trim();
    // Try dd/MM/yyyy
    try {
      final parts = trimmed.split('/');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);
        if (day != null && month != null && year != null) {
          return DateTime(year, month, day);
        }
      }
    } catch (_) {}

    // Try yyyy-MM-dd
    try {
      return DateTime.parse(trimmed);
    } catch (_) {}

    // Try dd-MM-yyyy
    try {
      final parts = trimmed.split('-');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);
        if (day != null && month != null && year != null) {
          return DateTime(year, month, day);
        }
      }
    } catch (_) {}

    return null;
  }

  static double? _parseDouble(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return double.tryParse(value.trim().replaceAll(',', ''));
  }
}
