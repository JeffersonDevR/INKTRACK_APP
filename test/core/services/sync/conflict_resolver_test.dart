import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/core/services/sync/conflict_resolver.dart';
import 'package:InkTrack/features/clientes/data/models/abono.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/locales/data/models/local.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/ventas/data/models/venta.dart';

void main() {
  group('ConflictResolver.shouldSkipDownload', () {
    test('returns false when record does not exist locally (null syncStatus)',
        () {
      expect(
        ConflictResolver.shouldSkipDownload(
          localSyncStatus: null,
          localLastSyncedAt: null,
          serverUpdatedAt: DateTime(2025, 6, 1),
        ),
        isFalse,
      );
    });

    test('returns true when local record has pending_upload status', () {
      expect(
        ConflictResolver.shouldSkipDownload(
          localSyncStatus: 'pending_upload',
          localLastSyncedAt: DateTime(2025, 1, 1),
          serverUpdatedAt: DateTime(2025, 6, 1),
        ),
        isTrue,
      );
    });

    test('returns true when local record has pending (default) status', () {
      expect(
        ConflictResolver.shouldSkipDownload(
          localSyncStatus: 'pending',
          localLastSyncedAt: DateTime(2025, 1, 1),
          serverUpdatedAt: DateTime(2025, 6, 1),
        ),
        isTrue,
      );
    });

    test(
        'returns false when server updated_at is newer and local is synced', () {
      expect(
        ConflictResolver.shouldSkipDownload(
          localSyncStatus: 'synced',
          localLastSyncedAt: DateTime(2025, 1, 1, 10, 0, 0),
          serverUpdatedAt: DateTime(2025, 6, 1, 10, 0, 0),
        ),
        isFalse,
      );
    });

    test(
        'returns true when local lastSyncedAt is newer than server updated_at',
        () {
      expect(
        ConflictResolver.shouldSkipDownload(
          localSyncStatus: 'synced',
          localLastSyncedAt: DateTime(2025, 6, 15, 10, 0, 0),
          serverUpdatedAt: DateTime(2025, 1, 1, 10, 0, 0),
        ),
        isTrue,
      );
    });

    test('returns false when server updated_at is null (accept server)', () {
      expect(
        ConflictResolver.shouldSkipDownload(
          localSyncStatus: 'synced',
          localLastSyncedAt: DateTime(2025, 6, 1),
          serverUpdatedAt: null,
        ),
        isFalse,
      );
    });

    test(
        'returns false when local lastSyncedAt is null and server has update',
        () {
      expect(
        ConflictResolver.shouldSkipDownload(
          localSyncStatus: 'synced',
          localLastSyncedAt: null,
          serverUpdatedAt: DateTime(2025, 6, 1),
        ),
        isFalse,
      );
    });
  });

  group('ConflictResolver.parseDateTime', () {
    test('parses ISO 8601 string', () {
      final result = ConflictResolver.parseDateTime('2025-06-01T10:00:00Z');
      expect(result, isNotNull);
      expect(result!.year, equals(2025));
      expect(result.month, equals(6));
      expect(result.day, equals(1));
    });

    test('passes through DateTime', () {
      final dt = DateTime(2025, 6, 1);
      expect(ConflictResolver.parseDateTime(dt), equals(dt));
    });

    test('returns null for null', () {
      expect(ConflictResolver.parseDateTime(null), isNull);
    });

    test('returns null for invalid string', () {
      expect(ConflictResolver.parseDateTime('not-a-date'), isNull);
    });
  });

  group('ConflictResolver.resolveProductos (LWW adversarial)', () {
    final baseProducto = Producto(
      id: 'prod-1',
      nombre: 'Arroz 1kg',
      cantidad: 50,
      precioVenta: 3200,
      categoria: 'Víveres',
      proveedorId: 'prov-1',
    );

    test('server wins when server updated_at is newer', () {
      final local = baseProducto.copyWith(
        cantidad: 40,
        updatedAt: DateTime(2025, 6, 1, 10, 0, 0),
      );
      final server = baseProducto.copyWith(
        cantidad: 50,
        updatedAt: DateTime(2025, 6, 1, 12, 0, 0),
      );

      final result = ConflictResolver.resolveProductos(local, server);

      expect(result.cantidad, 50,
          reason: 'Server has newer updated_at → server wins (LWW)');
      expect(result.updatedAt, DateTime(2025, 6, 1, 12, 0, 0));
    });

    test('local wins when local updated_at is newer', () {
      final local = baseProducto.copyWith(
        cantidad: 35,
        updatedAt: DateTime(2025, 6, 1, 14, 0, 0),
      );
      final server = baseProducto.copyWith(
        cantidad: 50,
        updatedAt: DateTime(2025, 6, 1, 10, 0, 0),
      );

      final result = ConflictResolver.resolveProductos(local, server);

      expect(result.cantidad, 35,
          reason: 'Local has newer updated_at → local wins (LWW)');
      expect(result.updatedAt, DateTime(2025, 6, 1, 14, 0, 0));
    });

    test('server wins on equal timestamps (tiebreak)', () {
      final ts = DateTime(2025, 6, 1, 10, 0, 0);
      final local = baseProducto.copyWith(
        cantidad: 40,
        updatedAt: ts,
      );
      final server = baseProducto.copyWith(
        cantidad: 50,
        updatedAt: ts,
      );

      final result = ConflictResolver.resolveProductos(local, server);

      expect(result.cantidad, 50,
          reason: 'Equal updated_at → server wins (tiebreak)');
    });

    test('server wins when local updated_at is null', () {
      final local = baseProducto.copyWith(updatedAt: null);
      final server = baseProducto.copyWith(
        cantidad: 60,
        updatedAt: DateTime(2025, 6, 1),
      );

      final result = ConflictResolver.resolveProductos(local, server);

      expect(result.cantidad, 60,
          reason: 'Local has no updated_at → server wins');
    });

    test('local wins when server updated_at is null', () {
      final local = baseProducto.copyWith(
        cantidad: 30,
        updatedAt: DateTime(2025, 6, 1),
      );
      final server = baseProducto.copyWith(updatedAt: null);

      final result = ConflictResolver.resolveProductos(local, server);

      expect(result.cantidad, 30,
          reason: 'Server has no updated_at → local wins');
    });

    test('server wins when both updated_at are null', () {
      final local = baseProducto.copyWith(cantidad: 30, updatedAt: null);
      final server = baseProducto.copyWith(cantidad: 60, updatedAt: null);

      final result = ConflictResolver.resolveProductos(local, server);

      expect(result.cantidad, 60,
          reason: 'Both null → server wins (default)');
    });
  });

  group('ConflictResolver.resolveCuentasPorCobrar (merge-sum)', () {
    final baseCliente = Cliente(
      id: 'cli-1',
      nombre: 'Carlos',
      telefono: '12345678',
      saldoPendiente: 500.0,
      esFiado: true,
      updatedAt: DateTime(2025, 6, 1),
    );

    final baseVenta = Venta(
      id: 'v-1',
      monto: 500.0,
      fecha: DateTime(2025, 6, 1),
      esFiado: true,
      clienteId: 'cli-1',
    );

    test('offline abonos merge correctly without money loss', () {
      final local = baseCliente.copyWith(
        saldoPendiente: 400.0,
        updatedAt: DateTime(2025, 6, 2),
      );
      final server = baseCliente.copyWith(
        saldoPendiente: 300.0,
        updatedAt: DateTime(2025, 6, 3),
      );

      final localAbonos = [
        Abono(
          id: 'abono-l1',
          clienteId: 'cli-1',
          monto: 100.0,
          fecha: DateTime(2025, 6, 2),
          saldoRestante: 400.0,
          updatedAt: DateTime(2025, 6, 2),
        ),
      ];

      final serverAbonos = [
        Abono(
          id: 'abono-s1',
          clienteId: 'cli-1',
          monto: 200.0,
          fecha: DateTime(2025, 6, 3),
          saldoRestante: 300.0,
          updatedAt: DateTime(2025, 6, 3),
        ),
      ];

      final result = ConflictResolver.resolveCuentasPorCobrar(
        local: local,
        server: server,
        localAbonos: localAbonos,
        serverAbonos: serverAbonos,
        creditoVentas: [baseVenta],
      );

      // Total credit = 500. Total abonos = 100 + 200 = 300. Merged balance = 200.
      expect(result.saldoPendiente, 200.0);
      expect(result.esFiado, isTrue);
      expect(result.syncStatus, isNot('conflict'));
    });

    test('duplicate abonos are deduped by ID', () {
      final localAbonos = [
        Abono(
          id: 'abono-dup',
          clienteId: 'cli-1',
          monto: 100.0,
          fecha: DateTime(2025, 6, 2),
          saldoRestante: 400.0,
          updatedAt: DateTime(2025, 6, 2),
        ),
      ];

      final serverAbonos = [
        Abono(
          id: 'abono-dup',
          clienteId: 'cli-1',
          monto: 100.0,
          fecha: DateTime(2025, 6, 2),
          saldoRestante: 400.0,
          updatedAt: DateTime(2025, 6, 2),
        ),
      ];

      final result = ConflictResolver.resolveCuentasPorCobrar(
        local: baseCliente,
        server: baseCliente,
        localAbonos: localAbonos,
        serverAbonos: serverAbonos,
        creditoVentas: [baseVenta],
      );

      // Total credit = 500. Total abono = 100 (since it's a duplicate ID). Merged balance = 400.
      expect(result.saldoPendiente, 400.0);
    });

    test('unresolvable corrupt abonos trigger conflict sync status', () {
      final localAbonos = [
        Abono(
          id: 'abono-1',
          clienteId: 'cli-1',
          monto: 400.0,
          fecha: DateTime(2025, 6, 2),
          saldoRestante: 100.0,
          updatedAt: DateTime(2025, 6, 2),
        ),
      ];

      final serverAbonos = [
        Abono(
          id: 'abono-2',
          clienteId: 'cli-1',
          monto: 200.0,
          fecha: DateTime(2025, 6, 3),
          saldoRestante: 300.0,
          updatedAt: DateTime(2025, 6, 3),
        ),
      ];

      final result = ConflictResolver.resolveCuentasPorCobrar(
        local: baseCliente.copyWith(syncStatus: 'synced'),
        server: baseCliente,
        localAbonos: localAbonos,
        serverAbonos: serverAbonos,
        creditoVentas: [baseVenta],
      );

      // Total credit = 500. Total abonos = 400 + 200 = 600. Merged balance = -100 (corrupt).
      expect(result.saldoPendiente, -100.0);
      expect(result.syncStatus, 'conflict');
    });
  });

  group('ConflictResolver.resolveVentas (LWW)', () {
    final baseVenta = Venta(
      id: 'v-1',
      monto: 100.0,
      fecha: DateTime(2025, 6, 1),
    );

    test('newer updated_at wins', () {
      final local = baseVenta.copyWith(monto: 120.0, updatedAt: DateTime(2025, 6, 2));
      final server = baseVenta.copyWith(monto: 150.0, updatedAt: DateTime(2025, 6, 3));

      final result = ConflictResolver.resolveVentas(local, server);
      expect(result.monto, 150.0);
    });
  });

  group('ConflictResolver.resolveMovimientos (append-only union)', () {
    final m1 = Movimiento(
      id: 'm-1',
      monto: 50.0,
      fecha: DateTime(2025, 6, 1),
      tipo: MovimientoType.ingreso,
      concepto: 'Venta',
    );
    final m2 = Movimiento(
      id: 'm-2',
      monto: 30.0,
      fecha: DateTime(2025, 6, 2),
      tipo: MovimientoType.egreso,
      concepto: 'Luz',
    );

    test('unions disjoint sets', () {
      final result = ConflictResolver.resolveMovimientos([m1], [m2]);
      expect(result.length, 2);
      expect(result.any((m) => m.id == 'm-1'), isTrue);
      expect(result.any((m) => m.id == 'm-2'), isTrue);
    });

    test('deduplicates overlapping IDs', () {
      final result = ConflictResolver.resolveMovimientos([m1], [m1]);
      expect(result.length, 1);
    });
  });

  group('ConflictResolver.resolveLocales (server-wins)', () {
    final localLocal = Local(id: 'l-1', nombre: 'Local Tienda');
    final serverLocal = Local(id: 'l-1', nombre: 'Local Bodega');

    test('server local always wins', () {
      final result = ConflictResolver.resolveLocales(localLocal, serverLocal);
      expect(result.nombre, 'Local Bodega');
    });
  });
}

