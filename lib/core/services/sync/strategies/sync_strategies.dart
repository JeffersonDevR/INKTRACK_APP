import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/log_service.dart';
import 'package:InkTrack/core/services/sync/sync_strategy.dart';
import 'package:InkTrack/core/services/sync/conflict_resolver.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';

/// Ensures query catches both 'pending' (DB default) and
/// 'pending_upload' (set by repositories).
const String syncedStatus = 'synced';

/// Returns only rows whose [local_id] is non-null and non-empty.
///
/// Rows with a missing [local_id] cannot satisfy RLS/FK policies on the
/// server, so they are skipped and logged.
List<Map<String, dynamic>> _withValidLocalId(
  String tableName,
  List<Map<String, dynamic>> rows,
) {
  final valid = <Map<String, dynamic>>[];
  final skipped = <String>[];
  for (final row in rows) {
    final id = row['local_id'] as String?;
    if (id != null && id.isNotEmpty) {
      valid.add(row);
    } else {
      skipped.add(row['id'] as String? ?? '?');
    }
  }
  if (skipped.isNotEmpty) {
    LogService.instance.warning(
      'Sync',
      'Skipping ${skipped.length} $tableName rows with null/empty local_id: $skipped',
    );
  }
  return valid;
}

/// ---------------------------------------------------------------------------
/// LocalesSyncStrategy
/// ---------------------------------------------------------------------------
class LocalesSyncStrategy implements SyncStrategy {
  @override
  String get tableName => 'locales';

  @override
  Future<List<Map<String, dynamic>>> getPendingRows(AppDatabase db) async {
    final rows = await (db.select(db.locales)
      ..where((t) => t.syncStatus.equals(syncedStatus).not())
    ).get();
    return rows.map(_localToJson).toList();
  }

  Map<String, dynamic> _localToJson(LocalData r) => {
    'id': r.id,
    'nombre': r.nombre,
    'direccion': r.direccion,
    'telefono': r.telefono,
    'tipo': r.tipo,
    'user_id': r.userId,
    'is_activo': r.isActivo,
  };

  @override
  Future<void> markAsSynced(AppDatabase db, List<String> ids) async {
    final now = DateTime.now();
    for (final id in ids) {
      await (db.update(db.locales)..where((t) => t.id.equals(id))).write(
        LocalesCompanion(
          syncStatus: const Value(syncedStatus),
          lastSyncedAt: Value(now),
        ),
      );
    }
  }

  @override
  Future<bool> uploadBatch(
    SupabaseClient client,
    List<Map<String, dynamic>> rows,
  ) async {
    final currentUserId = client.auth.currentUser?.id;
    final sanitized = rows.map((r) => {
      ...r,
      'user_id': r['user_id'] ?? currentUserId,
    }).toList();
    await client.from(tableName).upsert(sanitized);
    return true;
  }

  @override
  Future<int> downloadAndMerge(
    AppDatabase db,
    SupabaseClient client,
  ) async {
    final response = await client.from(tableName).select('*');
    final rows = response as List<dynamic>;
    int applied = 0;

    for (final raw in rows) {
      final json = raw as Map<String, dynamic>;
      final id = json['id'] as String?;
      if (id == null) continue;

      final existing = await (db.select(db.locales)
        ..where((t) => t.id.equals(id))
      ).getSingleOrNull();

      if (_shouldSkipDownload(existing, json)) continue;

      await db.into(db.locales).insertOnConflictUpdate(
        LocalesCompanion(
          id: Value(id),
          nombre: Value(json['nombre'] as String? ?? ''),
          direccion: Value(json['direccion'] as String?),
          telefono: Value(json['telefono'] as String?),
          tipo: Value(json['tipo'] as String? ?? 'tienda'),
          userId: Value(json['user_id'] as String?),
          isActivo: Value(json['is_activo'] as bool? ?? true),
          syncStatus: const Value(syncedStatus),
          lastSyncedAt: Value(DateTime.now()),
        ),
      );
      applied++;
    }
    return applied;
  }
}

/// ---------------------------------------------------------------------------
/// ClientesSyncStrategy
/// ---------------------------------------------------------------------------
class ClientesSyncStrategy implements SyncStrategy {
  @override
  String get tableName => 'clientes';

  @override
  Future<List<Map<String, dynamic>>> getPendingRows(AppDatabase db) async {
    final rows = await (db.select(db.clientes)
      ..where((t) => t.syncStatus.equals(syncedStatus).not())
    ).get();
    return _withValidLocalId(tableName, rows.map(_localToJson).toList());
  }

  Map<String, dynamic> _localToJson(ClienteData r) => {
    'id': r.id,
    'nombre': r.nombre,
    'telefono': r.telefono,
    'email': r.email,
    'es_fiado': r.esFiado,
    'saldo_pendiente': r.saldoPendiente,
    'local_id': r.localId,
    'is_activo': r.isActivo,
  };

  @override
  Future<void> markAsSynced(AppDatabase db, List<String> ids) async {
    final now = DateTime.now();
    for (final id in ids) {
      await (db.update(db.clientes)..where((t) => t.id.equals(id))).write(
        ClientesCompanion(
          syncStatus: const Value(syncedStatus),
          lastSyncedAt: Value(now),
        ),
      );
    }
  }

  @override
  Future<bool> uploadBatch(
    SupabaseClient client,
    List<Map<String, dynamic>> rows,
  ) async {
    await client.from(tableName).upsert(rows);
    return true;
  }

  @override
  Future<int> downloadAndMerge(
    AppDatabase db,
    SupabaseClient client,
  ) async {
    final response = await client.from(tableName).select('*');
    final rows = response as List<dynamic>;
    int applied = 0;

    for (final raw in rows) {
      final json = raw as Map<String, dynamic>;
      final id = json['id'] as String?;
      if (id == null) continue;

      final existing = await (db.select(db.clientes)
        ..where((t) => t.id.equals(id))
      ).getSingleOrNull();

      if (_shouldSkipDownload(existing, json)) continue;

      await db.into(db.clientes).insertOnConflictUpdate(
        ClientesCompanion(
          id: Value(id),
          nombre: Value(json['nombre'] as String? ?? ''),
          telefono: Value(json['telefono'] as String?),
          email: Value(json['email'] as String?),
          esFiado: Value(json['es_fiado'] as bool? ?? false),
          saldoPendiente: Value(
            (json['saldo_pendiente'] as num?)?.toDouble() ?? 0.0,
          ),
          localId: Value(json['local_id'] as String?),
          isActivo: Value(json['is_activo'] as bool? ?? true),
          syncStatus: const Value(syncedStatus),
          lastSyncedAt: Value(DateTime.now()),
        ),
      );
      applied++;
    }
    return applied;
  }
}

/// ---------------------------------------------------------------------------
/// ProveedoresSyncStrategy
/// ---------------------------------------------------------------------------
class ProveedoresSyncStrategy implements SyncStrategy {
  @override
  String get tableName => 'proveedores';

  @override
  Future<List<Map<String, dynamic>>> getPendingRows(AppDatabase db) async {
    final rows = await (db.select(db.proveedores)
      ..where((t) => t.syncStatus.equals(syncedStatus).not())
    ).get();
    return _withValidLocalId(tableName, rows.map(_localToJson).toList());
  }

  Map<String, dynamic> _localToJson(ProveedorData r) => {
    'id': r.id,
    'nombre': r.nombre,
    'telefono': r.telefono,
    'dias_visita': r.diasVisita.join(','),
    'periodo_visita': r.periodoVisita,
    'ultima_visita': r.ultimaVisita?.toIso8601String(),
    'proxima_visita': r.proximaVisita?.toIso8601String(),
    'local_id': r.localId,
    'is_activo': r.isActivo,
  };

  @override
  Future<void> markAsSynced(AppDatabase db, List<String> ids) async {
    final now = DateTime.now();
    for (final id in ids) {
      await (db.update(db.proveedores)..where((t) => t.id.equals(id))).write(
        ProveedoresCompanion(
          syncStatus: const Value(syncedStatus),
          lastSyncedAt: Value(now),
        ),
      );
    }
  }

  @override
  Future<bool> uploadBatch(
    SupabaseClient client,
    List<Map<String, dynamic>> rows,
  ) async {
    await client.from(tableName).upsert(rows);
    return true;
  }

  @override
  Future<int> downloadAndMerge(
    AppDatabase db,
    SupabaseClient client,
  ) async {
    final response = await client.from(tableName).select('*');
    final rows = response as List<dynamic>;
    int applied = 0;

    for (final raw in rows) {
      final json = raw as Map<String, dynamic>;
      final id = json['id'] as String?;
      if (id == null) continue;

      final existing = await (db.select(db.proveedores)
        ..where((t) => t.id.equals(id))
      ).getSingleOrNull();

      if (_shouldSkipDownload(existing, json)) continue;

      final diasStr = json['dias_visita'] as String? ?? '';
      final diasVisita = diasStr.isEmpty ? <String>[] : diasStr.split(',');

      final ultimaVisita = ConflictResolver.parseDateTime(json['ultima_visita']);
      final proximaVisita = ConflictResolver.parseDateTime(json['proxima_visita']);

      await db.into(db.proveedores).insertOnConflictUpdate(
        ProveedoresCompanion(
          id: Value(id),
          nombre: Value(json['nombre'] as String? ?? ''),
          telefono: Value(json['telefono'] as String?),
          diasVisita: Value(diasVisita),
          periodoVisita: Value(json['periodo_visita'] as int?),
          ultimaVisita: Value(ultimaVisita),
          proximaVisita: Value(proximaVisita),
          localId: Value(json['local_id'] as String?),
          isActivo: Value(json['is_activo'] as bool? ?? true),
          syncStatus: const Value(syncedStatus),
          lastSyncedAt: Value(DateTime.now()),
        ),
      );
      applied++;
    }
    return applied;
  }
}

/// ---------------------------------------------------------------------------
/// ProductosSyncStrategy
/// ---------------------------------------------------------------------------
class ProductosSyncStrategy implements SyncStrategy {
  @override
  String get tableName => 'productos';

  @override
  Future<List<Map<String, dynamic>>> getPendingRows(AppDatabase db) async {
    final rows = await (db.select(db.productos)
      ..where((t) => t.syncStatus.equals(syncedStatus).not())
    ).get();
    return _withValidLocalId(tableName, rows.map(_localToJson).toList());
  }

  Map<String, dynamic> _localToJson(ProductoData r) => {
    'id': r.id,
    'nombre': r.nombre,
    'cantidad': r.cantidad,
    'precio': r.precio,
    'precio_compra': r.precioCompra,
    'unidades_por_paquete': r.unidadesPorPaquete,
    'es_paquete': r.esPaquete,
    'categoria': r.categoria,
    'proveedor_id': r.proveedorId,
    'stock_minimo': r.stockMinimo,
    'codigo_barras': r.codigoBarras,
    'codigo_personalizado': r.codigoPersonalizado,
    'proveedor_nombre': r.proveedorNombre,
    'local_id': r.localId,
    'is_activo': r.isActivo,
  };

  @override
  Future<void> markAsSynced(AppDatabase db, List<String> ids) async {
    final now = DateTime.now();
    for (final id in ids) {
      await (db.update(db.productos)..where((t) => t.id.equals(id))).write(
        ProductosCompanion(
          syncStatus: const Value(syncedStatus),
          lastSyncedAt: Value(now),
        ),
      );
    }
  }

  @override
  Future<bool> uploadBatch(
    SupabaseClient client,
    List<Map<String, dynamic>> rows,
  ) async {
    await client.from(tableName).upsert(rows);
    return true;
  }

  @override
  Future<int> downloadAndMerge(
    AppDatabase db,
    SupabaseClient client,
  ) async {
    final response = await client.from(tableName).select('*');
    final rows = response as List<dynamic>;
    int applied = 0;

    for (final raw in rows) {
      final json = raw as Map<String, dynamic>;
      final id = json['id'] as String?;
      if (id == null) continue;

      final existing = await (db.select(db.productos)
        ..where((t) => t.id.equals(id))
      ).getSingleOrNull();

      if (_shouldSkipDownload(existing, json)) continue;

      await db.into(db.productos).insertOnConflictUpdate(
        ProductosCompanion(
          id: Value(id),
          nombre: Value(json['nombre'] as String? ?? ''),
          cantidad: Value(json['cantidad'] as int? ?? 0),
          precio: Value((json['precio'] as num?)?.toDouble() ?? 0.0),
          precioCompra: Value(
            (json['precio_compra'] as num?)?.toDouble(),
          ),
          unidadesPorPaquete: Value(json['unidades_por_paquete'] as int? ?? 1),
          esPaquete: Value(json['es_paquete'] as bool? ?? false),
          categoria: Value(json['categoria'] as String? ?? ''),
          proveedorId: Value(json['proveedor_id'] as String? ?? ''),
          stockMinimo: Value(json['stock_minimo'] as int? ?? 5),
          codigoBarras: Value(json['codigo_barras'] as String?),
          codigoPersonalizado: Value(json['codigo_personalizado'] as String?),
          proveedorNombre: Value(json['proveedor_nombre'] as String?),
          localId: Value(json['local_id'] as String?),
          isActivo: Value(json['is_activo'] as bool? ?? true),
          syncStatus: const Value(syncedStatus),
          lastSyncedAt: Value(DateTime.now()),
        ),
      );
      applied++;
    }
    return applied;
  }
}

/// ---------------------------------------------------------------------------
/// MovimientosSyncStrategy
/// ---------------------------------------------------------------------------
class MovimientosSyncStrategy implements SyncStrategy {
  @override
  String get tableName => 'movimientos';

  @override
  Future<List<Map<String, dynamic>>> getPendingRows(AppDatabase db) async {
    final rows = await (db.select(db.movimientos)
      ..where((t) => t.syncStatus.equals(syncedStatus).not())
    ).get();
    return _withValidLocalId(tableName, rows.map(_localToJson).toList());
  }

  Map<String, dynamic> _localToJson(MovimientoData r) => {
    'id': r.id,
    'monto': r.monto,
    'fecha': r.fecha.toIso8601String(),
    'tipo': r.tipo.index,
    'concepto': r.concepto,
    'categoria': r.categoria,
    'producto_id': r.productoId,
    'cliente_id': r.clienteId,
    'proveedor_id': r.proveedorId,
    'local_id': r.localId,
    'cantidad': r.cantidad,
    'es_fiado': r.esFiado,
    'productos_json': r.productosJson,
  };

  @override
  Future<void> markAsSynced(AppDatabase db, List<String> ids) async {
    final now = DateTime.now();
    for (final id in ids) {
      await (db.update(db.movimientos)..where((t) => t.id.equals(id))).write(
        MovimientosCompanion(
          syncStatus: const Value(syncedStatus),
          lastSyncedAt: Value(now),
        ),
      );
    }
  }

  @override
  Future<bool> uploadBatch(
    SupabaseClient client,
    List<Map<String, dynamic>> rows,
  ) async {
    await client.from(tableName).upsert(rows);
    return true;
  }

  @override
  Future<int> downloadAndMerge(
    AppDatabase db,
    SupabaseClient client,
  ) async {
    final response = await client.from(tableName).select('*');
    final rows = response as List<dynamic>;
    int applied = 0;

    for (final raw in rows) {
      final json = raw as Map<String, dynamic>;
      final id = json['id'] as String?;
      if (id == null) continue;

      final existing = await (db.select(db.movimientos)
        ..where((t) => t.id.equals(id))
      ).getSingleOrNull();

      if (_shouldSkipDownload(existing, json)) continue;

      final fecha = ConflictResolver.parseDateTime(json['fecha']) ?? DateTime(2024);
      final tipoIdx = json['tipo'] as int? ?? 0;
      final tipo = tipoIdx < MovimientoType.values.length
          ? MovimientoType.values[tipoIdx]
          : MovimientoType.ingreso;

      await db.into(db.movimientos).insertOnConflictUpdate(
        MovimientosCompanion(
          id: Value(id),
          monto: Value((json['monto'] as num?)?.toDouble() ?? 0.0),
          fecha: Value(fecha),
          tipo: Value(tipo),
          concepto: Value(json['concepto'] as String? ?? ''),
          categoria: Value(json['categoria'] as String?),
          productoId: Value(json['producto_id'] as String?),
          clienteId: Value(json['cliente_id'] as String?),
          proveedorId: Value(json['proveedor_id'] as String?),
          localId: Value(json['local_id'] as String?),
          cantidad: Value(json['cantidad'] as int? ?? 0),
          esFiado: Value(json['es_fiado'] as bool? ?? false),
          productosJson: Value(json['productos_json'] as String?),
          syncStatus: const Value(syncedStatus),
          lastSyncedAt: Value(DateTime.now()),
        ),
      );
      applied++;
    }
    return applied;
  }
}

/// ---------------------------------------------------------------------------
/// VentasSyncStrategy
/// ---------------------------------------------------------------------------
class VentasSyncStrategy implements SyncStrategy {
  @override
  String get tableName => 'ventas';

  @override
  Future<List<Map<String, dynamic>>> getPendingRows(AppDatabase db) async {
    final rows = await (db.select(db.ventas)
      ..where((t) => t.syncStatus.equals(syncedStatus).not())
    ).get();
    return _withValidLocalId(tableName, rows.map(_localToJson).toList());
  }

  Map<String, dynamic> _localToJson(VentaData r) => {
    'id': r.id,
    'monto': r.monto,
    'fecha': r.fecha.toIso8601String(),
    'cliente_id': r.clienteId,
    'cliente_nombre': r.clienteNombre,
    'local_id': r.localId,
    'concepto': r.concepto,
    'productos_json': r.productosJson,
  };

  @override
  Future<void> markAsSynced(AppDatabase db, List<String> ids) async {
    final now = DateTime.now();
    for (final id in ids) {
      await (db.update(db.ventas)..where((t) => t.id.equals(id))).write(
        VentasCompanion(
          syncStatus: const Value(syncedStatus),
          lastSyncedAt: Value(now),
        ),
      );
    }
  }

  @override
  Future<bool> uploadBatch(
    SupabaseClient client,
    List<Map<String, dynamic>> rows,
  ) async {
    await client.from(tableName).upsert(rows);
    return true;
  }

  @override
  Future<int> downloadAndMerge(
    AppDatabase db,
    SupabaseClient client,
  ) async {
    final response = await client.from(tableName).select('*');
    final rows = response as List<dynamic>;
    int applied = 0;

    for (final raw in rows) {
      final json = raw as Map<String, dynamic>;
      final id = json['id'] as String?;
      if (id == null) continue;

      final existing = await (db.select(db.ventas)
        ..where((t) => t.id.equals(id))
      ).getSingleOrNull();

      if (_shouldSkipDownload(existing, json)) continue;

      final fecha = ConflictResolver.parseDateTime(json['fecha']) ?? DateTime(2024);

      await db.into(db.ventas).insertOnConflictUpdate(
        VentasCompanion(
          id: Value(id),
          monto: Value((json['monto'] as num?)?.toDouble() ?? 0.0),
          fecha: Value(fecha),
          clienteId: Value(json['cliente_id'] as String?),
          clienteNombre: Value(json['cliente_nombre'] as String?),
          localId: Value(json['local_id'] as String?),
          concepto: Value(json['concepto'] as String?),
          productosJson: Value(json['productos_json'] as String?),
          syncStatus: const Value(syncedStatus),
          lastSyncedAt: Value(DateTime.now()),
        ),
      );
      applied++;
    }
    return applied;
  }
}

/// ---------------------------------------------------------------------------
/// PedidosProveedorSyncStrategy
/// ---------------------------------------------------------------------------
class PedidosProveedorSyncStrategy implements SyncStrategy {
  @override
  String get tableName => 'pedidos_proveedor';

  @override
  Future<List<Map<String, dynamic>>> getPendingRows(AppDatabase db) async {
    final rows = await (db.select(db.pedidosProveedor)
      ..where((t) => t.syncStatus.equals(syncedStatus).not())
    ).get();
    return _withValidLocalId(tableName, rows.map(_localToJson).toList());
  }

  Map<String, dynamic> _localToJson(PedidoProveedorData r) => {
    'id': r.id,
    'proveedor_id': r.proveedorId,
    'proveedor_nombre': r.proveedorNombre,
    'local_id': r.localId,
    'fecha_pedido': r.fechaPedido.toIso8601String(),
    'fecha_entrega': r.fechaEntrega?.toIso8601String(),
    'productos': r.productos,
    'monto_total': r.montoTotal,
    'is_entregado': r.isEntregado,
    'notas': r.notas,
  };

  @override
  Future<void> markAsSynced(AppDatabase db, List<String> ids) async {
    final now = DateTime.now();
    for (final id in ids) {
      await (db.update(db.pedidosProveedor)
        ..where((t) => t.id.equals(id))
      ).write(
        PedidosProveedorCompanion(
          syncStatus: const Value(syncedStatus),
          lastSyncedAt: Value(now),
        ),
      );
    }
  }

  @override
  Future<bool> uploadBatch(
    SupabaseClient client,
    List<Map<String, dynamic>> rows,
  ) async {
    await client.from(tableName).upsert(rows);
    return true;
  }

  @override
  Future<int> downloadAndMerge(
    AppDatabase db,
    SupabaseClient client,
  ) async {
    final response = await client.from(tableName).select('*');
    final rows = response as List<dynamic>;
    int applied = 0;

    for (final raw in rows) {
      final json = raw as Map<String, dynamic>;
      final id = json['id'] as String?;
      if (id == null) continue;

      final existing = await (db.select(db.pedidosProveedor)
        ..where((t) => t.id.equals(id))
      ).getSingleOrNull();

      if (_shouldSkipDownload(existing, json)) continue;

      final fechaPedido = ConflictResolver.parseDateTime(json['fecha_pedido']) ?? DateTime(2024);
      final fechaEntrega = ConflictResolver.parseDateTime(json['fecha_entrega']);

      await db.into(db.pedidosProveedor).insertOnConflictUpdate(
        PedidosProveedorCompanion(
          id: Value(id),
          proveedorId: Value(json['proveedor_id'] as String? ?? ''),
          proveedorNombre: Value(json['proveedor_nombre'] as String?),
          localId: Value(json['local_id'] as String?),
          fechaPedido: Value(fechaPedido),
          fechaEntrega: Value(fechaEntrega),
          productos: Value(json['productos'] as String? ?? '[]'),
          montoTotal: Value(
            (json['monto_total'] as num?)?.toDouble() ?? 0.0,
          ),
          isEntregado: Value(json['is_entregado'] as bool? ?? false),
          notas: Value(json['notas'] as String?),
          syncStatus: const Value(syncedStatus),
          lastSyncedAt: Value(DateTime.now()),
        ),
      );
      applied++;
    }
    return applied;
  }
}

/// ---------------------------------------------------------------------------
/// Shared helpers
/// ---------------------------------------------------------------------------

/// Returns `true` if the download should be skipped because local changes
/// take precedence (pending upload) or because the local record is newer.
bool _shouldSkipDownload(
  dynamic existing,
  Map<String, dynamic> serverJson,
) {
  if (existing == null) return false;

  return ConflictResolver.shouldSkipDownload(
    localSyncStatus: existing.syncStatus as String?,
    localLastSyncedAt: existing.lastSyncedAt as DateTime?,
    serverUpdatedAt: ConflictResolver.parseDateTime(serverJson['updated_at']),
  );
}
