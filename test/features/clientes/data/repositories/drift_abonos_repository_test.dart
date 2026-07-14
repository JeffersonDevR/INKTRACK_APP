import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/clientes/data/models/abono.dart';
import 'package:InkTrack/features/clientes/data/repositories/drift_abonos_repository.dart';

void main() {
  late AppDatabase db;
  late DriftAbonosRepository repository;

  setUp(() {
    db = AppDatabase.fromConnection(NativeDatabase.memory());
    repository = DriftAbonosRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('DriftAbonosRepository Tests', () {
    test('register abono recomputes client balance and stores abono row correctly', () async {
      // 1. Insert a test client
      await db.customStatement(
        "INSERT INTO clientes (id, nombre, telefono, saldo_pendiente, es_fiado, sync_status) "
        "VALUES ('cli-1', 'Juan', '12345678', 500.0, 1, 'synced')"
      );

      // 2. Insert credit venta totaling 500.0 so getSaldoPendiente has the correct base total_credito
      await db.customStatement(
        "INSERT INTO ventas (id, monto, fecha, cliente_id, es_fiado, sync_status) "
        "VALUES ('v-1', 500.0, '2025-06-01T10:00:00Z', 'cli-1', 1, 'synced')"
      );

      // 3. Register abono of 100.0
      final abono = Abono(
        id: 'ab-1',
        clienteId: 'cli-1',
        monto: 100.0,
        fecha: DateTime(2025, 6, 2),
        saldoRestante: 400.0,
        updatedAt: DateTime(2025, 6, 2),
      );

      await repository.save(abono);

      // 4. Assert abono is stored with correct metadata
      final storedAbonos = await repository.getByCliente('cli-1');
      expect(storedAbonos.length, equals(1));
      
      final stored = storedAbonos.first;
      expect(stored.id, equals('ab-1'));
      expect(stored.monto, equals(100.0));
      expect(stored.saldoRestante, equals(400.0));
      expect(stored.syncStatus, equals('pending_upload'));
      expect(stored.updatedAt, isNotNull);

      // 5. Assert client's saldoPendiente is recomputed to 400.0 and sync_status is pending_upload
      final clientRow = await db.customSelect(
        "SELECT saldo_pendiente, es_fiado, sync_status, updated_at FROM clientes WHERE id = 'cli-1'"
      ).getSingle();

      expect(clientRow.read<double>('saldo_pendiente'), equals(400.0));
      expect(clientRow.read<bool>('es_fiado'), isTrue);
      expect(clientRow.read<String>('sync_status'), equals('pending_upload'));
      expect(clientRow.read<DateTime?>('updated_at'), isNotNull);
    });
  });
}
