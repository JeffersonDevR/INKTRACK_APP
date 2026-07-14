import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/clientes/data/models/abono.dart';
import 'package:InkTrack/features/ventas/data/models/venta.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/locales/data/models/local.dart';
import 'package:InkTrack/features/proveedores/data/models/pedido_proveedor.dart';

class ConflictResolver {
  static bool shouldSkipDownload({
    required String? localSyncStatus,
    required DateTime? localLastSyncedAt,
    required DateTime? serverUpdatedAt,
  }) {
    if (localSyncStatus == null) return false;
    if (localSyncStatus == 'pending_upload' || localSyncStatus == 'pending') {
      return true;
    }
    if (localSyncStatus == 'synced') {
      if (serverUpdatedAt == null) return false;
      if (localLastSyncedAt == null) return false;
      return localLastSyncedAt.isAfter(serverUpdatedAt);
    }
    return false;
  }

  static DateTime? parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static Producto resolveProductos(Producto local, Producto server) {
    final localUpdated = local.updatedAt;
    final serverUpdated = server.updatedAt;

    if (localUpdated == null && serverUpdated == null) return server;
    if (localUpdated == null) return server;
    if (serverUpdated == null) return local;

    if (serverUpdated.isAfter(localUpdated)) return server;
    if (localUpdated.isAfter(serverUpdated)) return local;
    return server;
  }

  static Cliente resolveCuentasPorCobrar({
    required Cliente local,
    required Cliente server,
    required Iterable<Abono> localAbonos,
    required Iterable<Abono> serverAbonos,
    required Iterable<Venta> creditoVentas,
  }) {
    final allAbonos = <String, Abono>{};
    for (final abono in localAbonos) {
      allAbonos[abono.id] = abono;
    }
    for (final abono in serverAbonos) {
      final existing = allAbonos[abono.id];
      if (existing == null) {
        allAbonos[abono.id] = abono;
      } else {
        if (abono.updatedAt.isAfter(existing.updatedAt)) {
          allAbonos[abono.id] = abono;
        }
      }
    }

    final totalAbonado = allAbonos.values.fold<double>(0.0, (sum, a) => sum + a.monto);
    final totalCredito = creditoVentas.fold<double>(0.0, (sum, v) => sum + v.monto);
    final newSaldo = totalCredito - totalAbonado;

    String? status = local.syncStatus;
    if (newSaldo < 0) {
      status = 'conflict';
    }

    Cliente baseClient = local;
    final localUpdated = local.updatedAt;
    final serverUpdated = server.updatedAt;

    if (localUpdated == null && serverUpdated == null) {
      baseClient = server;
    } else if (localUpdated == null) {
      baseClient = server;
    } else if (serverUpdated == null) {
      baseClient = local;
    } else if (serverUpdated.isAfter(localUpdated)) {
      baseClient = server;
    }

    return baseClient.copyWith(
      saldoPendiente: newSaldo,
      esFiado: newSaldo > 0,
      syncStatus: status,
    );
  }

  static Venta resolveVentas(Venta local, Venta server) {
    final localUpdated = local.updatedAt;
    final serverUpdated = server.updatedAt;

    if (localUpdated == null && serverUpdated == null) return server;
    if (localUpdated == null) return server;
    if (serverUpdated == null) return local;

    if (serverUpdated.isAfter(localUpdated)) return server;
    if (localUpdated.isAfter(serverUpdated)) return local;
    return server;
  }

  static List<Movimiento> resolveMovimientos(List<Movimiento> localAll, List<Movimiento> serverIncoming) {
    final allMap = { for (var m in localAll) m.id : m };
    for (final m in serverIncoming) {
      if (!allMap.containsKey(m.id)) {
        allMap[m.id] = m;
      }
    }
    return allMap.values.toList();
  }

  static Local resolveLocales(Local local, Local server) {
    return server;
  }

  // -----------------------------------------------------------------------
  // Chain 5 — pedidos reception LWW (task 5.13)
  // -----------------------------------------------------------------------

  /// Resolves a conflict between [local] and [server] versions of a
  /// `PedidoProveedor`.
  ///
  /// Strategy (per spec):
  /// - **Header** (notas, isEntregado, fechaEntrega, etc.) — LWW on `updatedAt`;
  ///   ties → server wins.
  /// - **Per-line `recibido`** — take the max(local.recibido, server.recibido)
  ///   for each matching `productoId`.  This preserves local reception progress
  ///   even against a stale server header (ADR spec: "local reception progress
  ///   preserved across devices").
  static PedidoProveedor resolvePedidos(
    PedidoProveedor local,
    PedidoProveedor server,
  ) {
    final localUpdated = local.updatedAt;
    final serverUpdated = server.updatedAt;

    // Determine the base (header-winning) pedido
    PedidoProveedor base;
    if (localUpdated == null && serverUpdated == null) {
      base = server; // ties → server
    } else if (localUpdated == null) {
      base = server;
    } else if (serverUpdated == null) {
      base = local;
    } else if (serverUpdated.isAfter(localUpdated)) {
      base = server;
    } else if (localUpdated.isAfter(serverUpdated)) {
      base = local;
    } else {
      base = server; // equal → server wins
    }

    // Build a lookup from the OTHER (non-base) pedido for LWW recibido merge.
    // We take max(local.recibido, server.recibido) per line to never lose
    // reception progress from either device.
    final otherProductos = (base == server ? local : server).productos;
    final otherMap = {for (final p in otherProductos) p.productoId: p};

    final mergedProductos = base.productos.map((p) {
      final other = otherMap[p.productoId];
      if (other == null) return p;
      // Take the higher recibido value from either device
      final maxRecibido = p.recibido > other.recibido ? p.recibido : other.recibido;
      return p.copyWith(recibido: maxRecibido);
    }).toList();

    return base.copyWith(productos: mergedProductos);
  }
}
