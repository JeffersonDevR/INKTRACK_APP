import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/excel_import_service.dart';
import 'package:InkTrack/features/inventario/data/importers/inventario_import_validator.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';

void main() {
  group('InventarioImportValidator — validation', () {
    test('validates complete row successfully', () {
      final csv = 'nombre,cantidad,precio,categoria,proveedorid\n'
          'Producto A,10,150.0,Papeleria,prov-1';

      final parsed = ExcelImportService.parseCsv(csv);
      final validated = InventarioImportValidator.validate(parsed);

      expect(validated.validCount, 1);
      expect(validated.errors, isEmpty);
      final p = validated.validRows.first;
      expect(p.nombre, 'Producto A');
      expect(p.cantidad, 10);
      expect(p.precioVenta, 150.0);
      expect(p.categoria, 'Papeleria');
      expect(p.proveedorId, 'prov-1');
    });

    test('rejects rows with missing required columns', () {
      // Missing cantidad, precio, proveedorid
      final csv = 'nombre,categoria\n'
          'Producto A,Papeleria\n';

      final parsed = ExcelImportService.parseCsv(csv);
      final validated = InventarioImportValidator.validate(parsed);

      expect(validated.validCount, 0);
      expect(validated.errors.length, 1);
      expect(
        validated.errors.first.message,
        contains('cantidad'),
      );
    });

    test('rejects rows with invalid number fields', () {
      final csv = 'nombre,cantidad,precio,categoria,proveedorid\n'
          'Producto A,abc,xyz,Papeleria,prov-1\n';

      final parsed = ExcelImportService.parseCsv(csv);
      final validated = InventarioImportValidator.validate(parsed);

      expect(validated.validCount, 0);
      expect(validated.errors.length, 1);
      expect(
        validated.errors.first.message,
        contains('cantidad'),
      );
      expect(
        validated.errors.first.message,
        contains('precio'),
      );
    });

    test('checkRequiredColumns detects missing columns', () {
      final csv = 'nombre,cantidad,precio\n'
          'Producto A,10,150.0';

      final parsed = ExcelImportService.parseCsv(csv);
      final missing = ExcelImportService.checkRequiredColumns(
        parsed,
        InventarioImportValidator.requiredColumns,
      );

      expect(missing, contains('categoria'));
      expect(missing, contains('proveedorid'));
      expect(missing.length, 2);
    });
  });

  group('InventarioImportValidator — batch import', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase.withExecutor(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test('inserts valid productos in transaction', () async {
      final productos = [
        Producto(
          id: 'prod-1',
          nombre: 'Prod 1',
          cantidad: 10,
          precioVenta: 100.0,
          categoria: 'General',
          proveedorId: 'prov-1',
        ),
        Producto(
          id: 'prod-2',
          nombre: 'Prod 2',
          cantidad: 20,
          precioVenta: 200.0,
          categoria: 'General',
          proveedorId: 'prov-2',
        ),
      ];

      await InventarioImportValidator.batchImport(db, productos);

      final results = await db.select(db.productos).get();
      expect(results.length, 2);
    });

    test('rolls back on duplicate id', () async {
      // Pre-insert a product
      await db.into(db.productos).insert(
        ProductosCompanion.insert(
          id: 'dup-prod',
          nombre: 'Existing',
          cantidad: 5,
          precio: 50.0,
          categoria: 'Test',
          proveedorId: 'p-1',
          isActivo: const Value(true),
          syncStatus: const Value('pending_upload'),
        ),
      );

      final productos = [
        Producto(
          id: 'dup-prod',
          nombre: 'Duplicate',
          cantidad: 10,
          precioVenta: 100.0,
          categoria: 'General',
          proveedorId: 'prov-1',
        ),
        Producto(
          id: 'new-prod',
          nombre: 'New Product',
          cantidad: 10,
          precioVenta: 100.0,
          categoria: 'General',
          proveedorId: 'prov-1',
        ),
      ];

      try {
        await InventarioImportValidator.batchImport(db, productos);
        fail('Expected exception was not thrown');
      } catch (_) {
        // Expected: transaction should fail
      }

      // Verify only the original row exists (rollback)
      final results = await db.select(db.productos).get();
      expect(results.length, 1);
      expect(results.first.nombre, 'Existing');
    });
  });
}
