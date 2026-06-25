import 'package:drift/drift.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/excel_import_service.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:uuid/uuid.dart';

class InventarioImportValidator {
  static const List<String> requiredColumns = [
    'nombre',
    'cantidad',
    'precio',
    'categoria',
    'proveedorid',
  ];

  static const List<String> optionalColumns = [
    'id',
    'preciocompra',
    'unidadesporpaquete',
    'espaquete',
    'stockminimo',
    'codigobarras',
    'codigopersonalizado',
    'proveedornombre',
    'localid',
  ];

  static const List<String> allColumns = [
    ...requiredColumns,
    ...optionalColumns,
  ];

  static ValidatedImportResult<Producto> validate(ImportResult result) {
    final errors = <RowValidationError>[];
    final validRows = <Producto>[];
    final _uuid = const Uuid();

    for (final row in result.rows) {
      final rowErrors = <String>[];
      final data = row.data;

      final nombre = data['nombre'] ?? '';
      if (nombre.trim().isEmpty) {
        rowErrors.add('El campo "nombre" es requerido');
      }

      final cantidad = _parseInt(data['cantidad']);
      if (cantidad == null) {
        rowErrors.add('El campo "cantidad" debe ser un número entero');
      }

      final precio = _parseDouble(data['precio']);
      if (precio == null) {
        rowErrors.add('El campo "precio" debe ser un número');
      }

      final categoria = data['categoria'] ?? '';
      if (categoria.trim().isEmpty) {
        rowErrors.add('El campo "categoria" es requerido');
      }

      final proveedorId = data['proveedorid'] ?? '';
      if (proveedorId.trim().isEmpty) {
        rowErrors.add('El campo "proveedorid" es requerido');
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
      final precioCompra = _parseDouble(data['preciocompra']);
      final unidadesPorPaquete = _parseInt(data['unidadesporpaquete']) ?? 1;
      final esPaquete = _parseBool(data['espaquete']);
      final stockMinimo = _parseInt(data['stockminimo']) ?? 5;
      final codigoBarras = data['codigobarras']?.trim();
      final codigoPersonalizado = data['codigopersonalizado']?.trim();
      final proveedorNombre = data['proveedornombre']?.trim();

      validRows.add(Producto(
        id: id,
        nombre: nombre.trim(),
        cantidad: cantidad!,
        precioVenta: precio!,
        precioCompra: precioCompra,
        unidadesPorPaquete: unidadesPorPaquete,
        esPaquete: esPaquete,
        categoria: categoria.trim(),
        proveedorId: proveedorId.trim(),
        stockMinimo: stockMinimo,
        localId: localId?.isNotEmpty == true ? localId : null,
        codigoBarras: codigoBarras?.isNotEmpty == true ? codigoBarras : null,
        codigoPersonalizado:
            codigoPersonalizado?.isNotEmpty == true ? codigoPersonalizado : null,
        proveedorNombre:
            proveedorNombre?.isNotEmpty == true ? proveedorNombre : null,
        isActivo: true,
      ));
    }

    return ValidatedImportResult(validRows: validRows, errors: errors);
  }

  static Future<void> batchImport(
    AppDatabase db,
    List<Producto> productos,
  ) async {
    await db.transaction(() async {
      for (final producto in productos) {
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
            stockMinimo: Value(producto.stockMinimo),
            localId: producto.localId != null
                ? Value(producto.localId)
                : const Value.absent(),
            codigoBarras: Value(producto.codigoBarras),
            codigoPersonalizado: Value(producto.codigoPersonalizado),
            proveedorNombre: Value(producto.proveedorNombre),
            isActivo: Value(producto.isActivo),
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

  static int? _parseInt(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return int.tryParse(value.trim());
  }
}
