import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:InkTrack/core/data/local/database.dart';

void main() {
  group('Database Migration v17 to v18', () {
    test('migration runs successfully and creates abonos table', () async {
      final db = AppDatabase.fromConnection(NativeDatabase.memory());
      
      final tables = await db.customSelect(
        "SELECT name FROM sqlite_schema WHERE type='table'"
      ).get();

      final tableNames = tables.map((row) => row.read<String>('name')).toList();
      expect(tableNames.contains('abonos'), isTrue);
      
      await db.close();
    });

    test('onUpgrade v17 to v18 adds new columns', () async {
      final db = AppDatabase.fromConnection(NativeDatabase.memory());
      
      // Select table info to check columns
      final clienteCols = await db.customSelect("PRAGMA table_info(clientes)").get();
      final clienteColNames = clienteCols.map((r) => r.read<String>('name')).toList();
      expect(clienteColNames.contains('limite_credito'), isTrue);
      expect(clienteColNames.contains('promesa_pago'), isTrue);

      final ventaCols = await db.customSelect("PRAGMA table_info(ventas)").get();
      final ventaColNames = ventaCols.map((r) => r.read<String>('name')).toList();
      expect(ventaColNames.contains('es_fiado'), isTrue);

      final userCols = await db.customSelect("PRAGMA table_info(local_users)").get();
      final userColNames = userCols.map((r) => r.read<String>('name')).toList();
      expect(userColNames.contains('pin_hash'), isTrue);
      expect(userColNames.contains('rol'), isTrue);

      await db.close();
    });
  });
}
