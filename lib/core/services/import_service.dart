import 'dart:io';

import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:excel/excel.dart';
import 'package:uuid/uuid.dart';

import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/data/import/module_validator.dart';
import 'package:InkTrack/features/inventario/data/import/producto_validator.dart';
import 'package:InkTrack/features/clientes/data/import/cliente_validator.dart';
import 'package:InkTrack/features/proveedores/data/import/proveedor_validator.dart';
import 'package:InkTrack/features/locales/data/import/local_validator.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/proveedores/data/models/proveedor.dart';
import 'package:InkTrack/features/locales/data/models/local.dart';

// ---------------------------------------------------------------------------
// Result types
// ---------------------------------------------------------------------------

/// The result of a bulk import operation.
class ImportResult {
  final bool success;
  final int? importedCount;
  final List<ImportError>? errors;

  const ImportResult._({
    required this.success,
    this.importedCount,
    this.errors,
  });

  /// Creates a success result with the number of imported rows.
  factory ImportResult.success(int count) =>
      ImportResult._(success: true, importedCount: count);

  /// Creates a failure result with a list of errors.
  factory ImportResult.failure(List<ImportError> errors) =>
      ImportResult._(success: false, errors: errors);
}

/// Describes a single validation or processing error during import.
class ImportError {
  final int rowNumber;
  final String field;
  final String message;

  const ImportError(this.rowNumber, this.field, this.message);

  @override
  String toString() => 'Row $rowNumber, $field: $message';
}

// ---------------------------------------------------------------------------
// ImportService — file parsing, validation orchestration, and upsert
// ---------------------------------------------------------------------------

/// Orchestrates bulk data import from Excel (.xlsx) or CSV (.csv) files.
///
/// Flow:
/// 1. Detect file extension and parse rows into `List<Map<String, dynamic>>`
/// 2. Ensure every row has an ID (auto-generate UUID v4 if missing)
/// 3. Run module-specific validation via [ModuleValidator]
/// 4. Upsert all rows inside a single Drift transaction
class ImportService {
  final AppDatabase _db;
  static const _uuid = Uuid();

  ImportService(this._db);

  /// Imports data from [filePath] into the given [moduleType].
  ///
  /// Supported [moduleType] values: `'productos'`, `'clientes'`,
  /// `'proveedores'`, `'locales'`.
  ///
  /// Returns an [ImportResult] indicating success or listing all errors.
  Future<ImportResult> importFile(String filePath, String moduleType) async {
    final file = File(filePath);
    final extension = filePath.split('.').last.toLowerCase();

    // ── 1. Parse ────────────────────────────────────────────────────────
    List<Map<String, dynamic>> rows;
    try {
      rows = await _parseFile(file, extension);
    } catch (e) {
      return ImportResult.failure([
        ImportError(0, 'file', e.toString()),
      ]);
    }

    if (rows.isEmpty) {
      return ImportResult.failure([
        ImportError(0, 'file', 'No data found in file'),
      ]);
    }

    // ── 2. Ensure IDs ──────────────────────────────────────────────────
    for (final row in rows) {
      final id = row['id'];
      if (id == null || (id is String && id.trim().isEmpty)) {
        row['id'] = _uuid.v4();
      }
    }

    // ── 3. Validate ────────────────────────────────────────────────────
    final validator = _getValidator(moduleType);
    final errors = validator.validate(rows);
    if (errors.isNotEmpty) {
      return ImportResult.failure(errors);
    }

    // ── 4. Upsert in transaction ────────────────────────────────────────
    try {
      await _db.transaction(() async {
        for (final row in rows) {
          await _upsertRow(_db, moduleType, row, validator);
        }
      });
      return ImportResult.success(rows.length);
    } catch (e) {
      return ImportResult.failure([
        ImportError(0, 'database', 'Database error: $e'),
      ]);
    }
  }

  // -----------------------------------------------------------------------
  // File parsing
  // -----------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> _parseFile(File file, String extension) async {
    switch (extension) {
      case 'xlsx':
        return _parseXlsx(file);
      case 'csv':
        return _parseCsv(file);
      default:
        throw FormatException(
          'Unsupported file format: .$extension. '
          'Please use .xlsx or .csv files.',
        );
    }
  }

  Future<List<Map<String, dynamic>>> _parseXlsx(File file) async {
    final bytes = await file.readAsBytes();
    final excel = Excel.decodeBytes(bytes);
    if (excel.sheets.isEmpty) {
      return [];
    }

    final sheet = excel.sheets.values.first;
    final allRows = sheet.rows;
    if (allRows.isEmpty) return [];

    // First row is the header
    final headers = allRows.first
        .map((cell) => cell?.value?.toString().trim() ?? '')
        .toList();

    // Subsequent rows are data
    return allRows.skip(1).where((row) {
      // Skip completely empty rows
      return row.any((cell) => cell?.value != null);
    }).map((row) {
      final map = <String, dynamic>{};
      for (var i = 0; i < headers.length; i++) {
        final key = headers[i];
        if (key.isEmpty) continue;
        final cellValue = i < row.length ? row[i]?.value : null;
        if (cellValue is TextCellValue) {
          map[key] = cellValue.value;
        } else if (cellValue is IntCellValue) {
          map[key] = cellValue.value;
        } else if (cellValue is DoubleCellValue) {
          map[key] = cellValue.value;
        } else if (cellValue is BoolCellValue) {
          map[key] = cellValue.value;
        } else {
          map[key] = cellValue?.toString();
        }
      }
      return map;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _parseCsv(File file) async {
    final content = await file.readAsString();
    final rawRows = Csv().decode(content);
    if (rawRows.isEmpty) return [];

    // First row is the header
    final headers = rawRows.first
        .map((cell) => cell?.toString().trim() ?? '')
        .toList();

    // Subsequent rows are data
    return rawRows.skip(1).where((row) {
      return row.any((cell) => cell != null && cell.toString().trim().isNotEmpty);
    }).map((row) {
      final map = <String, dynamic>{};
      for (var i = 0; i < headers.length; i++) {
        final key = headers[i];
        if (key.isEmpty) continue;
        map[key] = i < row.length ? row[i] : null;
      }
      return map;
    }).toList();
  }

  // -----------------------------------------------------------------------
  // Module routing
  // -----------------------------------------------------------------------

  ModuleValidator _getValidator(String moduleType) {
    switch (moduleType) {
      case 'productos':
        return ProductoValidator();
      case 'clientes':
        return ClienteValidator();
      case 'proveedores':
        return ProveedorValidator();
      case 'locales':
        return LocalValidator();
      default:
        throw ArgumentError('Unknown module type: $moduleType');
    }
  }

  // -----------------------------------------------------------------------
  // Upsert per module type
  // -----------------------------------------------------------------------

  Future<void> _upsertRow(
    AppDatabase txn,
    String moduleType,
    Map<String, dynamic> row,
    ModuleValidator validator,
  ) async {
    switch (moduleType) {
      case 'productos':
        await _upsertProducto(txn, row, validator as ModuleValidator<Producto>);
        break;
      case 'clientes':
        await _upsertCliente(txn, row, validator as ModuleValidator<Cliente>);
        break;
      case 'proveedores':
        await _upsertProveedor(txn, row, validator as ModuleValidator<Proveedor>);
        break;
      case 'locales':
        await _upsertLocal(txn, row, validator as ModuleValidator<Local>);
        break;
    }
  }

  Future<void> _upsertProducto(
    AppDatabase db,
    Map<String, dynamic> row,
    ModuleValidator<Producto> validator,
  ) async {
    final producto = validator.mapFromRow(row);
    final id = producto.id;

    final existing = await (db.select(db.productos)
      ..where((t) => t.id.equals(id))).get();

    if (existing.isNotEmpty) {
      await (db.update(db.productos)..where((t) => t.id.equals(id))).write(
        ProductosCompanion(
          nombre: Value(producto.nombre),
          cantidad: Value(producto.cantidad),
          precio: Value(producto.precioVenta),
          precioCompra: Value(producto.precioCompra),
          unidadesPorPaquete: Value(producto.unidadesPorPaquete),
          esPaquete: Value(producto.esPaquete),
          categoria: Value(producto.categoria),
          proveedorId: Value(producto.proveedorId),
          localId: producto.localId != null
              ? Value(producto.localId!)
              : const Value.absent(),
          stockMinimo: Value(producto.stockMinimo),
          codigoBarras: Value(producto.codigoBarras),
          codigoPersonalizado: Value(producto.codigoPersonalizado),
          proveedorNombre: Value(producto.proveedorNombre),
          isActivo: Value(producto.isActivo),
          syncStatus: const Value('pending_upload'),
        ),
      );
    } else {
      await db.into(db.productos).insert(
        ProductosCompanion.insert(
          id: producto.id,
          nombre: producto.nombre,
          cantidad: producto.cantidad,
          precio: producto.precioVenta,
          precioCompra: Value(producto.precioCompra),
          unidadesPorPaquete: Value(producto.unidadesPorPaquete),
          esPaquete: Value(producto.esPaquete),
          categoria: producto.categoria,
          proveedorId: producto.proveedorId,
          localId: producto.localId != null
              ? Value(producto.localId!)
              : const Value.absent(),
          stockMinimo: Value(producto.stockMinimo),
          codigoBarras: Value(producto.codigoBarras),
          codigoPersonalizado: Value(producto.codigoPersonalizado),
          proveedorNombre: Value(producto.proveedorNombre),
          isActivo: Value(producto.isActivo),
          syncStatus: const Value('pending_upload'),
        ),
      );
    }
  }

  Future<void> _upsertCliente(
    AppDatabase db,
    Map<String, dynamic> row,
    ModuleValidator<Cliente> validator,
  ) async {
    final cliente = validator.mapFromRow(row);
    final id = cliente.id;

    final existing = await (db.select(db.clientes)
      ..where((t) => t.id.equals(id))).get();

    if (existing.isNotEmpty) {
      await (db.update(db.clientes)..where((t) => t.id.equals(id))).write(
        ClientesCompanion(
          nombre: Value(cliente.nombre),
          telefono: Value(cliente.telefono),
          email: Value(cliente.email),
          localId: cliente.localId != null
              ? Value(cliente.localId!)
              : const Value.absent(),
          esFiado: Value(cliente.esFiado),
          saldoPendiente: Value(cliente.saldoPendiente),
          isActivo: Value(cliente.isActivo),
          syncStatus: const Value('pending_upload'),
        ),
      );
    } else {
      await db.into(db.clientes).insert(
        ClientesCompanion.insert(
          id: cliente.id,
          nombre: cliente.nombre,
          telefono: cliente.telefono,
          email: Value(cliente.email),
          localId: cliente.localId != null
              ? Value(cliente.localId!)
              : const Value.absent(),
          esFiado: Value(cliente.esFiado),
          saldoPendiente: Value(cliente.saldoPendiente),
          isActivo: Value(cliente.isActivo),
          syncStatus: const Value('pending_upload'),
        ),
      );
    }
  }

  Future<void> _upsertProveedor(
    AppDatabase db,
    Map<String, dynamic> row,
    ModuleValidator<Proveedor> validator,
  ) async {
    final proveedor = validator.mapFromRow(row);
    final id = proveedor.id;

    final existing = await (db.select(db.proveedores)
      ..where((t) => t.id.equals(id))).get();

    if (existing.isNotEmpty) {
      await (db.update(db.proveedores)..where((t) => t.id.equals(id))).write(
        ProveedoresCompanion(
          nombre: Value(proveedor.nombre),
          telefono: Value(proveedor.telefono),
          diasVisita: Value(proveedor.diasVisita),
          periodoVisita: Value(proveedor.periodoVisita),
          ultimaVisita: Value(proveedor.ultimaVisita),
          proximaVisita: Value(proveedor.proximaVisita),
          localId: proveedor.localId != null
              ? Value(proveedor.localId!)
              : const Value.absent(),
          isActivo: Value(proveedor.isActivo),
          syncStatus: const Value('pending_upload'),
        ),
      );
    } else {
      await db.into(db.proveedores).insert(
        ProveedoresCompanion.insert(
          id: proveedor.id,
          nombre: proveedor.nombre,
          telefono: proveedor.telefono,
          diasVisita: proveedor.diasVisita,
          periodoVisita: Value(proveedor.periodoVisita),
          ultimaVisita: Value(proveedor.ultimaVisita),
          proximaVisita: Value(proveedor.proximaVisita),
          localId: proveedor.localId != null
              ? Value(proveedor.localId!)
              : const Value.absent(),
          isActivo: Value(proveedor.isActivo),
          syncStatus: const Value('pending_upload'),
        ),
      );
    }
  }

  Future<void> _upsertLocal(
    AppDatabase db,
    Map<String, dynamic> row,
    ModuleValidator<Local> validator,
  ) async {
    final local = validator.mapFromRow(row);
    final id = local.id;

    final existing = await (db.select(db.locales)
      ..where((t) => t.id.equals(id))).get();

    if (existing.isNotEmpty) {
      await (db.update(db.locales)..where((t) => t.id.equals(id))).write(
        LocalesCompanion(
          nombre: Value(local.nombre),
          direccion: Value(local.direccion),
          telefono: Value(local.telefono),
          tipo: Value(local.tipo),
          userId: Value(local.userId),
          isActivo: Value(local.isActivo),
          syncStatus: const Value('pending_upload'),
        ),
      );
    } else {
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
  }
}
