import 'package:drift/drift.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/excel_import_service.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:uuid/uuid.dart';

class MovimientosImportValidator {
  static const List<String> requiredColumns = [
    'monto',
    'fecha',
    'tipo',
    'concepto',
  ];

  static const List<String> optionalColumns = [
    'id',
    'categoria',
    'productoid',
    'clienteid',
    'proveedorid',
    'localid',
    'cantidad',
    'esfiado',
  ];

  static const List<String> allColumns = [
    ...requiredColumns,
    ...optionalColumns,
  ];

  static ValidatedImportResult<Movimiento> validate(ImportResult result) {
    final errors = <RowValidationError>[];
    final validRows = <Movimiento>[];
    final _uuid = const Uuid();

    for (final row in result.rows) {
      final rowErrors = <String>[];
      final data = row.data;

      final monto = _parseDouble(data['monto']);
      if (monto == null || monto <= 0) {
        rowErrors.add('El campo "monto" debe ser un número positivo');
      }

      final fecha = _parseDate(data['fecha']);
      if (fecha == null) {
        rowErrors.add(
          'El campo "fecha" debe ser una fecha válida (yyyy-mm-dd o dd/mm/yyyy)',
        );
      }

      final tipo = _parseTipo(data['tipo']);
      if (tipo == null) {
        rowErrors.add(
          'El campo "tipo" debe ser "ingreso", "egreso" o "actividad"',
        );
      }

      final concepto = data['concepto'] ?? '';
      if (concepto.trim().isEmpty) {
        rowErrors.add('El campo "concepto" es requerido');
      }

      final categoria = data['categoria'];
      final cantidad = _parseInt(data['cantidad']);
      final esFiado = _parseBool(data['esfiado']);

      if (rowErrors.isNotEmpty) {
        errors.add(RowValidationError(
          rowIndex: row.index,
          message: rowErrors.join('; '),
        ));
        continue;
      }

      validRows.add(Movimiento(
        id: data['id']?.trim().isNotEmpty == true
            ? data['id']!
            : _uuid.v4(),
        monto: monto!,
        fecha: fecha!,
        tipo: tipo!,
        concepto: concepto.trim(),
        categoria: _optionalString(categoria),
        productoId: _optionalString(data['productoid']),
        clienteId: _optionalString(data['clienteid']),
        proveedorId: _optionalString(data['proveedorid']),
        localId: _optionalString(data['localid']),
        cantidad: cantidad,
        esFiado: esFiado,
      ));
    }

    return ValidatedImportResult(validRows: validRows, errors: errors);
  }

  static Future<void> batchImport(
    AppDatabase db,
    List<Movimiento> movimientos,
  ) async {
    await db.transaction(() async {
      for (final m in movimientos) {
        await db.into(db.movimientos).insert(
          MovimientosCompanion.insert(
            id: m.id,
            monto: m.monto,
            fecha: m.fecha,
            tipo: m.tipo,
            concepto: m.concepto,
            categoria: m.categoria != null
                ? Value(m.categoria)
                : const Value.absent(),
            productoId: m.productoId != null
                ? Value(m.productoId)
                : const Value.absent(),
            clienteId: m.clienteId != null
                ? Value(m.clienteId)
                : const Value.absent(),
            proveedorId: m.proveedorId != null
                ? Value(m.proveedorId)
                : const Value.absent(),
            localId: m.localId != null
                ? Value(m.localId)
                : const Value.absent(),
            cantidad: m.cantidad != null
                ? Value(m.cantidad)
                : const Value.absent(),
            esFiado: Value(m.esFiado),
            syncStatus: const Value('pending_upload'),
          ),
        );
      }
    });
  }

  static double? _parseDouble(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return double.tryParse(
      value.trim().replaceAll(',', '.'),
    );
  }

  static int? _parseInt(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return int.tryParse(value.trim());
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final trimmed = value.trim();
    try {
      return DateTime.parse(trimmed);
    } catch (_) {
      try {
        final parts = trimmed.split('/');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (_) {}
    }
    return null;
  }

  static MovimientoType? _parseTipo(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final lower = value.trim().toLowerCase();
    if (lower == 'ingreso' || lower == 'ingresos') return MovimientoType.ingreso;
    if (lower == 'egreso' || lower == 'egresos') return MovimientoType.egreso;
    if (lower == 'actividad') return MovimientoType.actividad;
    return null;
  }

  static bool _parseBool(String? value) {
    if (value == null || value.trim().isEmpty) return false;
    final lower = value.trim().toLowerCase();
    return lower == 'true' || lower == '1' || lower == 'si' || lower == 'sí';
  }

  static String? _optionalString(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return value.trim();
  }
}
