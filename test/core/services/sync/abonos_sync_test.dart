// test/core/services/sync/abonos_sync_test.dart
// Chain 4 — feat/m1-abonos-sync
// TDD anchors:
//   "adversarial two-device abono merge — no money loss" (end-to-end, 4.1)
//   "duplicate abono id is deduped" (4.1)
//   "unresolvable conflict sets conflict status" (4.1)
//   "flag disabled reverts to local-only abonos" (4.2)

import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/sync/conflict_resolver.dart';
import 'package:InkTrack/core/services/supabase_sync_service.dart';
import 'package:InkTrack/features/clientes/data/models/abono.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/ventas/data/models/venta.dart';

void main() {
  // -------------------------------------------------------------------------
  // Task 4.1 – Adversarial end-to-end resolver tests (pure logic, no HTTP)
  // -------------------------------------------------------------------------
  group('ConflictResolver — adversarial two-device abono merge (end-to-end, 4.1)', () {
    final t0 = DateTime(2025, 1, 1, 10, 0, 0);
    final t1 = DateTime(2025, 1, 2, 10, 0, 0);
    final t2 = DateTime(2025, 1, 3, 10, 0, 0);

    // Baseline helpers
    Venta creditVenta({double monto = 500.0}) => Venta(
          id: 'venta-1',
          monto: monto,
          fecha: t0,
          clienteId: 'cli-1',
          cantidad: 1,
          concepto: 'Crédito',
          esFiado: true,
        );

    Cliente baseCliente({
      double saldo = 500.0,
      DateTime? updatedAt,
      String? syncStatus,
    }) =>
        Cliente(
          id: 'cli-1',
          nombre: 'Juan',
          telefono: '123',
          saldoPendiente: saldo,
          esFiado: saldo > 0,
          updatedAt: updatedAt ?? t0,
          syncStatus: syncStatus,
        );

    test(
        'no money loss: two devices with disjoint offline abonos merge correctly'
        ' — saldoPendiente = credito − Σabonos', () {
      // Device1 offline abono: pays 100
      final abonoA = Abono(
        id: 'abono-A',
        clienteId: 'cli-1',
        monto: 100.0,
        fecha: t1,
        saldoRestante: 400.0,
        concepto: 'Pago device1',
        syncStatus: 'pending_upload',
        updatedAt: t1,
      );

      // Device2 offline abono: pays 200
      final abonoB = Abono(
        id: 'abono-B',
        clienteId: 'cli-1',
        monto: 200.0,
        fecha: t2,
        saldoRestante: 300.0,
        concepto: 'Pago device2',
        syncStatus: 'pending_upload',
        updatedAt: t2,
      );

      // Local state (device1): only has abonoA, saldo not yet updated from device2
      final localCliente = baseCliente(saldo: 400.0, updatedAt: t1, syncStatus: 'pending_upload');
      // Server state: device2's abono was synced first
      final serverCliente = baseCliente(saldo: 300.0, updatedAt: t2, syncStatus: 'synced');

      final resolved = ConflictResolver.resolveCuentasPorCobrar(
        local: localCliente,
        server: serverCliente,
        localAbonos: [abonoA],
        serverAbonos: [abonoB],
        creditoVentas: [creditVenta()],
      );

      // Both abonos merged: total abonado = 300 → saldo = 500 − 300 = 200
      expect(resolved.saldoPendiente, equals(200.0));
      // No money loss → should NOT be in conflict
      expect(resolved.syncStatus, isNot(equals('conflict')));
    });

    test('duplicate abono id is deduped — counted exactly once', () {
      final duplicateAbono = Abono(
        id: 'abono-SAME',
        clienteId: 'cli-1',
        monto: 100.0,
        fecha: t1,
        saldoRestante: 400.0,
        updatedAt: t1,
      );

      final local = baseCliente(saldo: 400.0, updatedAt: t1);
      final server = baseCliente(saldo: 400.0, updatedAt: t1);

      // Same id present in both local and server lists
      final resolved = ConflictResolver.resolveCuentasPorCobrar(
        local: local,
        server: server,
        localAbonos: [duplicateAbono],
        serverAbonos: [duplicateAbono], // duplicate
        creditoVentas: [creditVenta()],
      );

      // Deduped → only one abono of 100 → saldo = 500 − 100 = 400
      expect(resolved.saldoPendiente, equals(400.0));
    });

    test('unresolvable corrupt set (abono exceeds credito) sets conflict status', () {
      // Abono that exceeds the total credito — data corruption scenario
      final corruptAbono = Abono(
        id: 'abono-corrupt',
        clienteId: 'cli-1',
        monto: 999.0, // 999 > 500 total credit
        fecha: t1,
        saldoRestante: -499.0,
        updatedAt: t1,
      );

      final local = baseCliente(updatedAt: t1);
      final server = baseCliente(updatedAt: t1);

      final resolved = ConflictResolver.resolveCuentasPorCobrar(
        local: local,
        server: server,
        localAbonos: [corruptAbono],
        serverAbonos: [],
        creditoVentas: [creditVenta()],
      );

      // Negative saldo → no silent overwrite → conflict
      expect(resolved.syncStatus, equals('conflict'));
    });

    test('abono_sync_enabled=true — two devices, each pays partially, full merge preserves total', () {
      // Client has total debt of 1000 from two credit ventas (500 each)
      final venta1 = Venta(
        id: 'v-1',
        monto: 500.0,
        fecha: t0,
        clienteId: 'cli-1',
        cantidad: 1,
        concepto: 'Crédito 1',
        esFiado: true,
      );
      final venta2 = Venta(
        id: 'v-2',
        monto: 500.0,
        fecha: t0,
        clienteId: 'cli-1',
        cantidad: 1,
        concepto: 'Crédito 2',
        esFiado: true,
      );

      final abonoDevice1 = Abono(
        id: 'ab-d1',
        clienteId: 'cli-1',
        monto: 250.0,
        fecha: t1,
        saldoRestante: 750.0,
        updatedAt: t1,
      );
      final abonoDevice2 = Abono(
        id: 'ab-d2',
        clienteId: 'cli-1',
        monto: 350.0,
        fecha: t2,
        saldoRestante: 650.0,
        updatedAt: t2,
      );

      final local = baseCliente(saldo: 750.0, updatedAt: t1);
      final server = baseCliente(saldo: 650.0, updatedAt: t2);

      final resolved = ConflictResolver.resolveCuentasPorCobrar(
        local: local,
        server: server,
        localAbonos: [abonoDevice1],
        serverAbonos: [abonoDevice2],
        creditoVentas: [venta1, venta2],
      );

      // Total credito = 1000, total abonado = 600 → saldo = 400
      expect(resolved.saldoPendiente, equals(400.0));
      expect(resolved.syncStatus, isNot(equals('conflict')));
    });
  });

  // -------------------------------------------------------------------------
  // Task 4.2 – Feature flag rollback tests (in-memory Drift DB)
  // -------------------------------------------------------------------------
  group('Abonos sync — feature flag (abonos_sync_enabled, 4.2)', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase.fromConnection(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test(
        'abonos_sync_enabled=false → abonos remain local-only; '
        'table intact; sync_status NOT changed', () async {
      // Seed DB with a pending abono
      await db.customStatement(
        "INSERT INTO clientes (id, nombre, telefono, saldo_pendiente, es_fiado, sync_status) "
        "VALUES ('cli-1', 'Juan', '12345678', 500.0, 1, 'synced')",
      );
      await db.customStatement(
        "INSERT INTO ventas (id, monto, fecha, cliente_id, es_fiado, sync_status) "
        "VALUES ('v-1', 500.0, '2025-01-01T10:00:00Z', 'cli-1', 1, 'synced')",
      );
      await db.customStatement(
        "INSERT INTO abonos (id, cliente_id, monto, fecha, saldo_restante, sync_status, updated_at) "
        "VALUES ('ab-1', 'cli-1', 100.0, '2025-01-02T10:00:00Z', 400.0, "
        "        'pending_upload', '2025-01-02T10:00:00Z')",
      );

      // Create service with flag disabled and no remote (empty URL → !isEnabled)
      final syncService = SupabaseSyncService(
        db,
        '', // empty URL — isEnabled=false
        '',
        abonosSyncEnabled: false,
      );

      expect(syncService.abonosSyncEnabled, isFalse);

      // Abonos table must still be intact
      final cnt = await db.customSelect('SELECT COUNT(*) as cnt FROM abonos').getSingle();
      expect(cnt.read<int>('cnt'), equals(1));

      // sync_status must NOT have changed (still 'pending_upload', not 'synced')
      final row =
          await db.customSelect("SELECT sync_status FROM abonos WHERE id = 'ab-1'").getSingle();
      expect(row.read<String>('sync_status'), equals('pending_upload'));
    });

    test('abonos_sync_enabled=false → syncAll() reports 0 uploads/downloads (short-circuits)', () async {
      final syncService = SupabaseSyncService(
        db,
        '', // !isEnabled
        '',
        abonosSyncEnabled: false,
      );

      final result = await syncService.syncAll();
      expect(result.uploaded, equals(0));
      expect(result.downloaded, equals(0));
    });

    test('abonos_sync_enabled=true → getter returns true', () {
      final syncService = SupabaseSyncService(
        db,
        '',
        '',
        abonosSyncEnabled: true,
      );
      expect(syncService.abonosSyncEnabled, isTrue);
    });

    test('setAbonosSyncEnabled() toggles flag at runtime without restart', () {
      final syncService = SupabaseSyncService(
        db,
        '',
        '',
        abonosSyncEnabled: true,
      );

      expect(syncService.abonosSyncEnabled, isTrue);
      syncService.setAbonosSyncEnabled(false);
      expect(syncService.abonosSyncEnabled, isFalse);
      syncService.setAbonosSyncEnabled(true);
      expect(syncService.abonosSyncEnabled, isTrue);
    });
  });
}
