import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/excel_import_service.dart';
import 'package:InkTrack/features/clientes/data/importers/clientes_import_validator.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';

void main() {
  group('ClientesImportValidator — validation', () {
    test('rejects rows with missing required fields', () {
      final csv = 'nombre,telefono\n'
          'ClienteA,123\n'
          ',456\n'
          'ClienteC,\n';

      final parsed = ExcelImportService.parseCsv(csv);
      final validated = ClientesImportValidator.validate(parsed);

      // First row is valid, next 2 have missing fields
      expect(validated.validCount, 1);
      expect(validated.errors.length, 2);
      expect(validated.errors[0].rowIndex, 2); // row 2 (0-indexed row 1)
      expect(validated.errors[1].rowIndex, 3);
    });

    test('generates UUID for rows without id', () {
      final csv = 'nombre,telefono\n'
          'Test,555';

      final parsed = ExcelImportService.parseCsv(csv);
      final validated = ClientesImportValidator.validate(parsed);

      expect(validated.validCount, 1);
      expect(validated.validRows.first.id, isNotEmpty);
      expect(validated.validRows.first.nombre, 'Test');
    });

    test('uses provided id from CSV', () {
      final csv = 'id,nombre,telefono\n'
          'cli-custom-001,Test,555';

      final parsed = ExcelImportService.parseCsv(csv);
      final validated = ClientesImportValidator.validate(parsed);

      expect(validated.validCount, 1);
      expect(validated.validRows.first.id, 'cli-custom-001');
    });

    test('parses optional fields correctly', () {
      final csv = 'nombre,telefono,email,esFiado,saldoPendiente\n'
          'Test,555,test@test.com,true,150.5';

      final parsed = ExcelImportService.parseCsv(csv);
      final validated = ClientesImportValidator.validate(parsed);

      expect(validated.validCount, 1);
      final cliente = validated.validRows.first;
      expect(cliente.email, 'test@test.com');
      expect(cliente.esFiado, isTrue);
      expect(cliente.saldoPendiente, 150.5);
    });
  });

  group('ClientesImportValidator — batch import with rollback', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase.withExecutor(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test('inserts valid clientes in transaction', () async {
      final clientes = [
        Cliente(id: 'test-1', nombre: 'Test 1', telefono: '111'),
        Cliente(id: 'test-2', nombre: 'Test 2', telefono: '222'),
        Cliente(id: 'test-3', nombre: 'Test 3', telefono: '333'),
      ];

      await ClientesImportValidator.batchImport(db, clientes);

      // Verify all were inserted
      final results = await db.select(db.clientes).get();
      expect(results.length, 3);
      expect(results.any((r) => r.nombre == 'Test 1'), isTrue);
      expect(results.any((r) => r.nombre == 'Test 2'), isTrue);
      expect(results.any((r) => r.nombre == 'Test 3'), isTrue);
    });

    test('rolls back entire transaction on failure', () async {
      // Insert a cliente with a known id
      await db.into(db.clientes).insert(
        ClientesCompanion.insert(
          id: 'dup-1',
          nombre: 'Existing',
          telefono: const Value('000'),
          esFiado: const Value(false),
          saldoPendiente: const Value(0.0),
          isActivo: const Value(true),
          syncStatus: const Value('pending_upload'),
        ),
      );

      final clientes = [
        Cliente(id: 'dup-1', nombre: 'Dup 1', telefono: '111'),
        Cliente(id: 'valid-2', nombre: 'Valid 2', telefono: '222'),
        Cliente(id: 'valid-3', nombre: 'Valid 3', telefono: '333'),
      ];

      // The first insert will fail (duplicate id), entire transaction rolls back
      try {
        await ClientesImportValidator.batchImport(db, clientes);
        fail('Expected exception was not thrown');
      } catch (_) {
        // Expected: transaction should fail
      }

      // Verify NO rows from the batch were inserted (rollback)
      final results = await db.select(db.clientes).get();
      expect(results.length, 1, reason: 'Only the original row should exist');
      expect(results.first.nombre, 'Existing');
    });
  });
}
