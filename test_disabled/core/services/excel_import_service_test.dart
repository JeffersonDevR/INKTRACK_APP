import 'package:flutter_test/flutter_test.dart';
//import 'package:InkTrack/core/services/excel_import_service.dart';

void main() {
  group('ExcelImportService — CSV parsing', () {
    test('parses 100-row CSV correctly', () async {
      // Build a 100-row CSV with 5 columns
      final header = 'nombre,telefono,email,localId,saldoPendiente';
      final rows = <String>[];
      for (var i = 1; i <= 100; i++) {
        rows.add('Cliente $i,$i$i$i$i$i$i$i,cliente$i@test.com,local-1,${i * 10}.0');
      }
      final csv = '$header\n${rows.join('\n')}';

      final result = ExcelImportService.parseCsv(csv);

      // Assert row count
      expect(result.hasErrors, isFalse, reason: 'No errors expected');
      expect(result.rows.length, 100, reason: 'Must parse exactly 100 rows');

      // Assert columns
      expect(result.columns.length, 5, reason: 'Must have 5 columns');
      expect(result.columns[0], 'nombre');
      expect(result.columns[1], 'telefono');
      expect(result.columns[4], 'saldoPendiente');

      // Assert data integrity
      expect(result.rows[0]['nombre'], 'Cliente 1');
      expect(result.rows[0]['saldopendiente'], '10.0');
      expect(result.rows[99]['nombre'], 'Cliente 100');
      expect(result.rows[99]['saldopendiente'], '1000.0');

      // Verify all rows have the expected keys
      for (final row in result.rows) {
        expect(row.data.containsKey('nombre'), isTrue);
        expect(row.data.containsKey('telefono'), isTrue);
      }
    });

    test('handles quoted fields with commas', () async {
      final csv = 'nombre,descripcion,precio\n'
          '"Producto A, Grande","Descripción con , coma",150.0\n'
          '"Producto B",Descripción simple,200.0';

      final result = ExcelImportService.parseCsv(csv);

      expect(result.rows.length, 2);
      expect(result.rows[0]['nombre'], 'Producto A, Grande');
      expect(result.rows[0]['descripcion'], 'Descripción con , coma');
      expect(result.rows[0]['precio'], '150.0');
      expect(result.rows[1]['nombre'], 'Producto B');
    });

    test('handles empty rows gracefully', () async {
      final csv = 'nombre,telefono\n'
          'Cliente A,123\n'
          '\n'
          'Cliente B,456\n'
          '   \n'
          'Cliente C,789';

      final result = ExcelImportService.parseCsv(csv);

      // Empty/whitespace-only rows should be skipped
      expect(result.rows.length, 3);
      expect(result.rows[0]['nombre'], 'Cliente A');
      expect(result.rows[1]['nombre'], 'Cliente B');
      expect(result.rows[2]['nombre'], 'Cliente C');
    });

    test('rejects file with missing required columns', () {
      // Deliberately missing 'telefono' column which is required for clientes
      final csv = 'nombre,email\n'
          'Cliente A,cliente@test.com\n'
          'Cliente B,otro@test.com';

      final result = ExcelImportService.parseCsv(csv);

      expect(result.rows.length, 2);
      expect(result.columns, contains('nombre'));
      expect(result.columns, isNot(contains('telefono')));

      // Check using checkRequiredColumns
      final missing = ExcelImportService.checkRequiredColumns(
        result,
        ['nombre', 'telefono'],
      );
      expect(missing, contains('telefono'));
      expect(missing.length, 1);
    });

    test('rejects empty file', () {
      final result = ExcelImportService.parseCsv('');

      expect(result.isEmpty, isTrue);
      expect(result.errors, isNotEmpty);
      expect(result.errors.first, contains('vacío'));
    });

    test('rejects file with only header', () {
      final result = ExcelImportService.parseCsv('nombre,telefono,email');

      expect(result.isEmpty, isTrue);
      expect(result.columns.length, 3);
    });

    test('handles BOM in CSV', () {
      // CSV with BOM character at the start
      final csv = '\uFEFFnombre,telefono\n'
          'Test,123456';

      final result = ExcelImportService.parseCsv(csv);

      expect(result.rows.length, 1);
      // BOM should be handled as part of the first header cell
      expect(result.rows[0]['nombre'], 'Test');
    });

    test('column names are case-insensitive in data access', () {
      final csv = 'NOMBRE,TELEFONO,EMAIL\n'
          'Test Cliente,999999,test@test.com';

      final result = ExcelImportService.parseCsv(csv);

      // Data is stored with lowercase keys
      expect(result.rows[0]['nombre'], 'Test Cliente');
      expect(result.rows[0]['telefono'], '999999');
    });

    test('column count matches across all rows', () {
      final csv = 'a,b,c\n'
          '1,2,3\n'
          '4,5,6\n'
          '7,8,9';

      final result = ExcelImportService.parseCsv(csv);

      expect(result.columns.length, 3);
      for (final row in result.rows) {
        expect(row.data.keys.length, 3);
      }
    });

    test('handles escaped quotes in quoted fields', () {
      final csv = 'nombre,notas\n'
          '"Cliente ""El Grande""","Nota con ""comillas"" aquí"';

      final result = ExcelImportService.parseCsv(csv);

      expect(result.rows.length, 1);
      expect(result.rows[0]['nombre'], 'Cliente "El Grande"');
      expect(result.rows[0]['notas'], 'Nota con "comillas" aquí');
    });

    test('findEmptyRows returns correct indices', () {
      final csv = 'nombre,telefono\n'
          'A,1\n'
          ', \n'
          'B,2\n'
          ',  \n'
          'C,3';

      final result = ExcelImportService.parseCsv(csv);

      // Empty rows are already filtered out during parsing
      // But let's verify the logic works
      final emptyIndices = ExcelImportService.findEmptyRows(result);
      expect(emptyIndices, isEmpty);
    });
  });
}
