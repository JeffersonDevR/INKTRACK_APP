import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/clientes/data/models/abono.dart';
import 'package:InkTrack/features/clientes/data/repositories/drift_abonos_repository.dart';
import 'package:InkTrack/features/movimientos/data/repositories/drift_movimientos_repository.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';

void main() {
  late AppDatabase db;
  late DriftAbonosRepository abonosRepo;
  late DriftMovimientosRepository movimientosRepo;
  late MovimientosViewModel viewModel;

  setUp(() {
    db = AppDatabase.fromConnection(NativeDatabase.memory());
    abonosRepo = DriftAbonosRepository(db);
    movimientosRepo = DriftMovimientosRepository(db);
    viewModel = MovimientosViewModel(movimientosRepo);
  });

  tearDown(() async {
    await db.close();
  });

  group('Abonos and Movimientos double-accounting tests', () {
    test('abono registration recomputes balance and represents exactly once in MovimientosViewModel', () async {
      // 1. Insert test client
      await db.customStatement(
        "INSERT INTO clientes (id, nombre, telefono, saldo_pendiente, es_fiado, sync_status) "
        "VALUES ('cli-1', 'Juan', '12345678', 500.0, 1, 'synced')"
      );

      // 2. Insert credit venta of 500
      await db.customStatement(
        "INSERT INTO ventas (id, monto, fecha, cliente_id, es_fiado, sync_status) "
        "VALUES ('v-1', 500.0, '2025-06-01T10:00:00Z', 'cli-1', 1, 'synced')"
      );

      // 3. Register abono of 100
      final abono = Abono(
        id: 'ab-1',
        clienteId: 'cli-1',
        monto: 100.0,
        fecha: DateTime(2025, 6, 2),
        saldoRestante: 400.0,
        updatedAt: DateTime(2025, 6, 2),
      );

      await abonosRepo.save(abono);

      // 4. Refresh viewmodel and assert totalIngresos is 100
      await viewModel.refresh();
      expect(viewModel.totalIngresos, equals(100.0));

      // 5. Assert that there is NO row in the movements table (prevent double accounting)
      final movCount = await db.customSelect(
        "SELECT COUNT(*) as cnt FROM movimientos"
      ).getSingle();
      expect(movCount.read<int>('cnt'), equals(0));

      // 6. Add a manual movement and assert it is also included in totalIngresos
      final manualMov = Movimiento(
        id: 'm-manual',
        monto: 50.0,
        fecha: DateTime(2025, 6, 3),
        tipo: MovimientoType.ingreso,
        concepto: 'Manual Sale',
        categoria: 'Ventas',
      );
      await viewModel.guardar(manualMov);
      await viewModel.refresh();

      // Total ingresos = 100 (abono) + 50 (manual) = 150
      expect(viewModel.totalIngresos, equals(150.0));

      // Movements table now contains exactly 1 row (the manual one)
      final finalMovCount = await db.customSelect(
        "SELECT COUNT(*) as cnt FROM movimientos"
      ).getSingle();
      expect(finalMovCount.read<int>('cnt'), equals(1));
    });
  });
}
