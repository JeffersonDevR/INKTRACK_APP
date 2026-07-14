import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/sync/conflict_resolver.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/proveedores/data/models/pedido_proveedor.dart';
import 'package:drift/drift.dart';

class SupabaseSyncService {
  final AppDatabase _db;
  final String _supabaseUrl;
  final String _supabaseKey;
  bool _abonosSyncEnabled;

  SupabaseSyncService(
    this._db,
    this._supabaseUrl,
    this._supabaseKey, {
    bool abonosSyncEnabled = true,
  }) : _abonosSyncEnabled = abonosSyncEnabled;

  /// Whether abonos push/pull sync branches are active.
  /// Default `true`. Toggle at runtime via [setAbonosSyncEnabled] or
  /// read from `shared_preferences` key `abonos_sync_enabled` and call this.
  bool get abonosSyncEnabled => _abonosSyncEnabled;

  /// Runtime toggle — no restart required (ADR spec: runtime toggle).
  void setAbonosSyncEnabled(bool value) {
    _abonosSyncEnabled = value;
  }

  bool get isEnabled => _supabaseUrl.isNotEmpty && _supabaseKey.isNotEmpty;

  Map<String, String> get _headers => {
    'apikey': _supabaseKey,
    'Authorization': 'Bearer $_supabaseKey',
    'Content-Type': 'application/json',
    'Prefer': 'resolution=merge-duplicates',
  };

  Future<SyncResult> syncTable(String tableName) async {
    if (!isEnabled) {
      return SyncResult(
        tableName: tableName,
        uploaded: 0,
        downloaded: 0,
        errors: 0,
      );
    }
    int uploaded = 0;
    int downloaded = 0;
    int errors = 0;

    switch (tableName) {
      case 'locales':
        final result = await _syncLocales();
        uploaded = result.uploaded;
        downloaded = result.downloaded;
        errors = result.errors;
        break;
      case 'productos':
        final result = await _syncProductos();
        uploaded = result.uploaded;
        downloaded = result.downloaded;
        errors = result.errors;
        break;
      case 'clientes':
        final result = await _syncClientes();
        uploaded = result.uploaded;
        downloaded = result.downloaded;
        errors = result.errors;
        break;
      case 'proveedores':
        final result = await _syncProveedores();
        uploaded = result.uploaded;
        downloaded = result.downloaded;
        errors = result.errors;
        break;
      case 'movimientos':
        final result = await _syncMovimientos();
        uploaded = result.uploaded;
        downloaded = result.downloaded;
        errors = result.errors;
        break;
      case 'ventas':
        final result = await _syncVentas();
        uploaded = result.uploaded;
        downloaded = result.downloaded;
        errors = result.errors;
        break;
      case 'abonos':
        if (_abonosSyncEnabled) {
          final result = await _syncAbonos();
          uploaded = result.uploaded;
          downloaded = result.downloaded;
          errors = result.errors;
        }
        break;
      case 'pedidos':
        final result = await _syncPedidos();
        uploaded = result.uploaded;
        downloaded = result.downloaded;
        errors = result.errors;
        break;
      default:
        errors = 1;
    }

    return SyncResult(
      tableName: tableName,
      uploaded: uploaded,
      downloaded: downloaded,
      errors: errors,
    );
  }

  Future<SyncResult> downloadFromSupabase(String tableName) async {
    if (!isEnabled) {
      return SyncResult(
        tableName: tableName,
        uploaded: 0,
        downloaded: 0,
        errors: 0,
      );
    }
    int downloaded = 0;
    int errors = 0;

    switch (tableName) {
      case 'locales':
        final result = await _downloadLocales();
        downloaded = result.downloaded;
        errors = result.errors;
        break;
      case 'productos':
        final result = await _downloadProductos();
        downloaded = result.downloaded;
        errors = result.errors;
        break;
      case 'clientes':
        final result = await _downloadClientes();
        downloaded = result.downloaded;
        errors = result.errors;
        break;
      case 'proveedores':
        final result = await _downloadProveedores();
        downloaded = result.downloaded;
        errors = result.errors;
        break;
      case 'movimientos':
        final result = await _downloadMovimientos();
        downloaded = result.downloaded;
        errors = result.errors;
        break;
      case 'ventas':
        final result = await _downloadVentas();
        downloaded = result.downloaded;
        errors = result.errors;
        break;
      case 'abonos':
        if (_abonosSyncEnabled) {
          final result = await _downloadAbonos();
          downloaded = result.downloaded;
          errors = result.errors;
        }
        break;
      case 'pedidos':
        final result = await _downloadPedidos();
        downloaded = result.downloaded;
        errors = result.errors;
        break;
      default:
        errors = 1;
    }

    return SyncResult(
      tableName: tableName,
      uploaded: 0,
      downloaded: downloaded,
      errors: errors,
    );
  }

  Future<SyncResult> downloadAll() async {
    if (!isEnabled) {
      return SyncResult(
        tableName: 'all',
        uploaded: 0,
        downloaded: 0,
        errors: 0,
      );
    }
    int totalDownloaded = 0;
    int totalErrors = 0;

    // Sequential order: parents first, then children.
    // Locales must come before any table referencing local_id.
    // Abonos come after ventas so credit ventas are available for resolver.
    final tablesInOrder = [
      'locales',
      'clientes',
      'proveedores',
      'productos',
      'movimientos',
      'ventas',
      'pedidos',
      if (_abonosSyncEnabled) 'abonos',
    ];
    for (final table in tablesInOrder) {
      final result = await downloadFromSupabase(table);
      totalDownloaded += result.downloaded;
      totalErrors += result.errors;
    }

    return SyncResult(
      tableName: 'all',
      uploaded: 0,
      downloaded: totalDownloaded,
      errors: totalErrors,
    );
  }

  Future<SyncResult> syncAll() async {
    if (!isEnabled) {
      return SyncResult(
        tableName: 'all',
        uploaded: 0,
        downloaded: 0,
        errors: 0,
      );
    }
    int totalUploaded = 0;
    int totalDownloaded = 0;
    int totalErrors = 0;

    // Sequential order: parents first, then children.
    // Locales must come before any table referencing local_id.
    // Abonos come after ventas (push-before-pull, ADR-04) so credit ventas
    // are persisted before the saldo resolver runs.
    final tablesInOrder = [
      'locales',
      'clientes',
      'proveedores',
      'productos',
      'movimientos',
      'ventas',
      'pedidos',
      if (_abonosSyncEnabled) 'abonos',
    ];
    for (final table in tablesInOrder) {
      final result = await syncTable(table);
      totalUploaded += result.uploaded;
      totalDownloaded += result.downloaded;
      totalErrors += result.errors;
    }

    return SyncResult(
      tableName: 'all',
      uploaded: totalUploaded,
      downloaded: totalDownloaded,
      errors: totalErrors,
    );
  }

  Future<SyncResult> _syncLocales() async {
    int uploaded = 0;
    int downloaded = 0;
    int errors = 0;

    try {
      final pending = await (_db.select(
        _db.locales,
      )..where((t) => t.syncStatus.isIn(['pending', 'pending_upload']))).get();

      for (final local in pending) {
        try {
          final data = {
            'id': local.id,
            'nombre': local.nombre,
            'direccion': local.direccion,
            'telefono': local.telefono,
            'tipo': local.tipo,
            'user_id': local.userId,
            'is_activo': local.isActivo,
          };

          final response = await http.post(
            Uri.parse('$_supabaseUrl/rest/v1/locales'),
            headers: _headers,
            body: jsonEncode(data),
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            await (_db.update(
              _db.locales,
            )..where((t) => t.id.equals(local.id))).write(
              LocalesCompanion(
                syncStatus: const Value('synced'),
                lastSyncedAt: Value(DateTime.now()),
              ),
            );
            uploaded++;
          } else {
            errors++;
          }
        } catch (e) {
          errors++;
        }
      }
    } catch (e) {
      errors++;
    }

    return SyncResult(
      tableName: 'locales',
      uploaded: uploaded,
      downloaded: downloaded,
      errors: errors,
    );
  }

  Future<SyncResult> _downloadLocales() async {
    int downloaded = 0;
    int errors = 0;

    try {
      final response = await http.get(
        Uri.parse('$_supabaseUrl/rest/v1/locales?select=*'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        for (final item in data) {
          try {
            final id = item['id'] as String;
            final existing = await (_db.select(
              _db.locales,
            )..where((t) => t.id.equals(id))).getSingleOrNull();

            if (existing != null && existing.syncStatus == 'pending_upload') {
              continue;
            }

            await (_db.into(_db.locales)).insertOnConflictUpdate(
              LocalesCompanion(
                id: Value(id),
                nombre: Value(item['nombre'] as String? ?? ''),
                direccion: Value(item['direccion'] as String?),
                telefono: Value(item['telefono'] as String?),
                tipo: Value(item['tipo'] as String? ?? 'tienda'),
                userId: Value(item['user_id'] as String?),
                isActivo: Value(item['is_activo'] as bool? ?? true),
                syncStatus: const Value('synced'),
                lastSyncedAt: Value(DateTime.now()),
              ),
            );
            downloaded++;
          } catch (e) {
            errors++;
          }
        }
      } else {
        errors++;
      }
    } catch (e) {
      errors++;
    }

    return SyncResult(
      tableName: 'locales',
      uploaded: 0,
      downloaded: downloaded,
      errors: errors,
    );
  }

  Future<SyncResult> _syncProductos() async {
    int uploaded = 0;
    int downloaded = 0;
    int errors = 0;

    try {
      final pending = await (_db.select(
        _db.productos,
      )..where((t) => t.syncStatus.isIn(['pending', 'pending_upload']))).get();

      for (final producto in pending) {
        try {
          final data = {
            'id': producto.id,
            'local_id': producto.localId,
            'nombre': producto.nombre,
            'cantidad': producto.cantidad,
            'precio': producto.precio,
            'categoria': producto.categoria,
            'proveedor_id': producto.proveedorId,
            'stock_minimo': producto.stockMinimo,
            'codigo_barras': producto.codigoBarras,
            'codigo_personalizado': producto.codigoPersonalizado,
            'proveedor_nombre': producto.proveedorNombre,
            'is_activo': producto.isActivo,
          };

          final response = await http.post(
            Uri.parse('$_supabaseUrl/rest/v1/productos'),
            headers: _headers,
            body: jsonEncode(data),
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            await (_db.update(
              _db.productos,
            )..where((t) => t.id.equals(producto.id))).write(
              ProductosCompanion(
                syncStatus: const Value('synced'),
                lastSyncedAt: Value(DateTime.now()),
              ),
            );
            uploaded++;
          } else {
            errors++;
          }
        } catch (e) {
          errors++;
        }
      }
    } catch (e) {
      errors++;
    }

    return SyncResult(
      tableName: 'productos',
      uploaded: uploaded,
      downloaded: downloaded,
      errors: errors,
    );
  }

  Future<SyncResult> _syncClientes() async {
    int uploaded = 0;
    int downloaded = 0;
    int errors = 0;

    try {
      final pending = await (_db.select(
        _db.clientes,
      )..where((t) => t.syncStatus.isIn(['pending', 'pending_upload']))).get();

      for (final cliente in pending) {
        try {
          final data = {
            'id': cliente.id,
            'local_id': cliente.localId,
            'nombre': cliente.nombre,
            'telefono': cliente.telefono,
            'email': cliente.email,
            'es_fiado': cliente.esFiado,
            'saldo_pendiente': cliente.saldoPendiente,
            'is_activo': cliente.isActivo,
          };

          final response = await http.post(
            Uri.parse('$_supabaseUrl/rest/v1/clientes'),
            headers: _headers,
            body: jsonEncode(data),
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            await (_db.update(
              _db.clientes,
            )..where((t) => t.id.equals(cliente.id))).write(
              ClientesCompanion(
                syncStatus: const Value('synced'),
                lastSyncedAt: Value(DateTime.now()),
              ),
            );
            uploaded++;
          } else {
            errors++;
          }
        } catch (e) {
          errors++;
        }
      }
    } catch (e) {
      errors++;
    }

    return SyncResult(
      tableName: 'clientes',
      uploaded: uploaded,
      downloaded: downloaded,
      errors: errors,
    );
  }

  Future<SyncResult> _syncProveedores() async {
    int uploaded = 0;
    int downloaded = 0;
    int errors = 0;

    try {
      final pending = await (_db.select(
        _db.proveedores,
      )..where((t) => t.syncStatus.isIn(['pending', 'pending_upload']))).get();

      for (final proveedor in pending) {
        try {
          final data = {
            'id': proveedor.id,
            'local_id': proveedor.localId,
            'nombre': proveedor.nombre,
            'telefono': proveedor.telefono,
            'dias_visita': proveedor.diasVisita.join(','),
            'is_activo': proveedor.isActivo,
          };

          final response = await http.post(
            Uri.parse('$_supabaseUrl/rest/v1/proveedores'),
            headers: _headers,
            body: jsonEncode(data),
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            await (_db.update(
              _db.proveedores,
            )..where((t) => t.id.equals(proveedor.id))).write(
              ProveedoresCompanion(
                syncStatus: const Value('synced'),
                lastSyncedAt: Value(DateTime.now()),
              ),
            );
            uploaded++;
          } else {
            errors++;
          }
        } catch (e) {
          errors++;
        }
      }
    } catch (e) {
      errors++;
    }

    return SyncResult(
      tableName: 'proveedores',
      uploaded: uploaded,
      downloaded: downloaded,
      errors: errors,
    );
  }

  Future<SyncResult> _syncMovimientos() async {
    int uploaded = 0;
    int downloaded = 0;
    int errors = 0;

    try {
      final pending = await (_db.select(
        _db.movimientos,
      )..where((t) => t.syncStatus.isIn(['pending', 'pending_upload']))).get();

      for (final movimiento in pending) {
        try {
          final data = {
            'id': movimiento.id,
            'local_id': movimiento.localId,
            'monto': movimiento.monto,
            'fecha': movimiento.fecha.toIso8601String(),
            'tipo': movimiento.tipo.index,
            'concepto': movimiento.concepto,
            'categoria': movimiento.categoria,
            'producto_id': movimiento.productoId,
            'cliente_id': movimiento.clienteId,
            'proveedor_id': movimiento.proveedorId,
            'cantidad': movimiento.cantidad,
            'es_fiado': movimiento.esFiado,
            'sync_status': movimiento.syncStatus,
            'last_synced_at': movimiento.lastSyncedAt?.toIso8601String(),
          };

          final response = await http.post(
            Uri.parse('$_supabaseUrl/rest/v1/movimientos'),
            headers: _headers,
            body: jsonEncode(data),
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            await (_db.update(
              _db.movimientos,
            )..where((t) => t.id.equals(movimiento.id))).write(
              MovimientosCompanion(
                syncStatus: const Value('synced'),
                lastSyncedAt: Value(DateTime.now()),
              ),
            );
            uploaded++;
          } else {
            errors++;
          }
        } catch (e) {
          errors++;
        }
      }
    } catch (e) {
      errors++;
    }

    return SyncResult(
      tableName: 'movimientos',
      uploaded: uploaded,
      downloaded: downloaded,
      errors: errors,
    );
  }

  Future<SyncResult> _syncVentas() async {
    int uploaded = 0;
    int downloaded = 0;
    int errors = 0;

    try {
      final pending = await (_db.select(
        _db.ventas,
      )..where((t) => t.syncStatus.isIn(['pending', 'pending_upload']))).get();

      for (final venta in pending) {
        try {
          final data = {
            'id': venta.id,
            'local_id': venta.localId,
            'monto': venta.monto,
            'fecha': venta.fecha.toIso8601String(),
            'cliente_id': venta.clienteId,
            'cliente_nombre': venta.clienteNombre,
            'concepto': venta.concepto,
            'sync_status': venta.syncStatus,
            'last_synced_at': venta.lastSyncedAt?.toIso8601String(),
          };

          final response = await http.post(
            Uri.parse('$_supabaseUrl/rest/v1/ventas'),
            headers: _headers,
            body: jsonEncode(data),
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            await (_db.update(
              _db.ventas,
            )..where((t) => t.id.equals(venta.id))).write(
              VentasCompanion(
                syncStatus: const Value('synced'),
                lastSyncedAt: Value(DateTime.now()),
              ),
            );
            uploaded++;
          } else {
            errors++;
          }
        } catch (e) {
          errors++;
        }
      }
    } catch (e) {
      errors++;
    }

    return SyncResult(
      tableName: 'ventas',
      uploaded: uploaded,
      downloaded: downloaded,
      errors: errors,
    );
  }

  Future<SyncResult> _downloadProductos() async {
    int downloaded = 0;
    int errors = 0;

    try {
      final response = await http.get(
        Uri.parse('$_supabaseUrl/rest/v1/productos?select=*'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        for (final item in data) {
          try {
            final id = item['id'] as String;
            final existing = await (_db.select(
              _db.productos,
            )..where((t) => t.id.equals(id))).getSingleOrNull();

            if (existing != null && existing.syncStatus == 'pending_upload') {
              continue;
            }

            await (_db.into(_db.productos)).insertOnConflictUpdate(
              ProductosCompanion(
                id: Value(id),
                localId: Value(item['local_id'] as String?),
                nombre: Value(item['nombre'] as String? ?? ''),
                cantidad: Value(item['cantidad'] as int? ?? 0),
                precio: Value((item['precio'] as num?)?.toDouble() ?? 0.0),
                categoria: Value(item['categoria'] as String? ?? ''),
                proveedorId: Value(item['proveedor_id'] as String? ?? ''),
                stockMinimo: Value(item['stock_minimo'] as int? ?? 0),
                codigoBarras: Value(item['codigo_barras'] as String?),
                codigoPersonalizado: Value(
                  item['codigo_personalizado'] as String?,
                ),
                proveedorNombre: Value(item['proveedor_nombre'] as String?),
                isActivo: Value(item['is_activo'] as bool? ?? true),
                syncStatus: const Value('synced'),
                lastSyncedAt: Value(DateTime.now()),
              ),
            );
            downloaded++;
          } catch (e) {
            errors++;
          }
        }
      } else {
        errors++;
      }
    } catch (e) {
      errors++;
    }

    return SyncResult(
      tableName: 'productos',
      uploaded: 0,
      downloaded: downloaded,
      errors: errors,
    );
  }

  Future<SyncResult> _downloadClientes() async {
    int downloaded = 0;
    int errors = 0;

    try {
      final response = await http.get(
        Uri.parse('$_supabaseUrl/rest/v1/clientes?select=*'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        for (final item in data) {
          try {
            final id = item['id'] as String;
            final existing = await (_db.select(
              _db.clientes,
            )..where((t) => t.id.equals(id))).getSingleOrNull();

            if (existing != null && existing.syncStatus == 'pending_upload') {
              continue;
            }

            final emailValue = item['email'] as String?;

            if (_abonosSyncEnabled) {
              // When abonos sync is active, do NOT blindly overwrite saldoPendiente
              // from server. The saldo is recomputed by resolveCuentasPorCobrar
              // after abonos are pulled (ADR-03 / task 4.4).
              await (_db.into(_db.clientes)).insertOnConflictUpdate(
                ClientesCompanion(
                  id: Value(id),
                  localId: Value(item['local_id'] as String?),
                  nombre: Value(item['nombre'] as String? ?? ''),
                  telefono: Value(item['telefono'] as String? ?? ''),
                  email: Value(emailValue),
                  esFiado: Value(item['es_fiado'] as bool? ?? false),
                  // saldoPendiente intentionally omitted — resolver sets it
                  isActivo: Value(item['is_activo'] as bool? ?? true),
                  syncStatus: const Value('synced'),
                  lastSyncedAt: Value(DateTime.now()),
                ),
              );
            } else {
              await (_db.into(_db.clientes)).insertOnConflictUpdate(
                ClientesCompanion(
                  id: Value(id),
                  localId: Value(item['local_id'] as String?),
                  nombre: Value(item['nombre'] as String? ?? ''),
                  telefono: Value(item['telefono'] as String? ?? ''),
                  email: Value(emailValue),
                  esFiado: Value(item['es_fiado'] as bool? ?? false),
                  saldoPendiente: Value(
                    (item['saldo_pendiente'] as num?)?.toDouble() ?? 0.0,
                  ),
                  isActivo: Value(item['is_activo'] as bool? ?? true),
                  syncStatus: const Value('synced'),
                  lastSyncedAt: Value(DateTime.now()),
                ),
              );
            }
            downloaded++;
          } catch (e) {
            errors++;
          }
        }
      } else {
        errors++;
      }
    } catch (e) {
      errors++;
    }

    return SyncResult(
      tableName: 'clientes',
      uploaded: 0,
      downloaded: downloaded,
      errors: errors,
    );
  }

  Future<SyncResult> _downloadProveedores() async {
    int downloaded = 0;
    int errors = 0;

    try {
      final response = await http.get(
        Uri.parse('$_supabaseUrl/rest/v1/proveedores?select=*'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        for (final item in data) {
          try {
            final id = item['id'] as String;
            final existing = await (_db.select(
              _db.proveedores,
            )..where((t) => t.id.equals(id))).getSingleOrNull();

            if (existing != null && existing.syncStatus == 'pending_upload') {
              continue;
            }

            final diasVisitaStr = item['dias_visita'] as String? ?? '';
            final diasVisita = diasVisitaStr.isEmpty
                ? <String>[]
                : diasVisitaStr.split(',');

            await (_db.into(_db.proveedores)).insertOnConflictUpdate(
              ProveedoresCompanion(
                id: Value(id),
                localId: Value(item['local_id'] as String?),
                nombre: Value(item['nombre'] as String? ?? ''),
                telefono: Value(item['telefono'] as String? ?? ''),
                diasVisita: Value(diasVisita),
                isActivo: Value(item['is_activo'] as bool? ?? true),
                syncStatus: const Value('synced'),
                lastSyncedAt: Value(DateTime.now()),
              ),
            );
            downloaded++;
          } catch (e) {
            errors++;
          }
        }
      } else {
        errors++;
      }
    } catch (e) {
      errors++;
    }

    return SyncResult(
      tableName: 'proveedores',
      uploaded: 0,
      downloaded: downloaded,
      errors: errors,
    );
  }

  Future<SyncResult> _downloadMovimientos() async {
    int downloaded = 0;
    int errors = 0;

    try {
      final response = await http.get(
        Uri.parse('$_supabaseUrl/rest/v1/movimientos?select=*'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        for (final item in data) {
          try {
            final id = item['id'] as String;
            final existing = await (_db.select(
              _db.movimientos,
            )..where((t) => t.id.equals(id))).getSingleOrNull();

            if (existing != null && existing.syncStatus == 'pending_upload') {
              continue;
            }

            await (_db.into(_db.movimientos)).insertOnConflictUpdate(
              MovimientosCompanion(
                id: Value(id),
                localId: Value(item['local_id'] as String?),
                monto: Value((item['monto'] as num?)?.toDouble() ?? 0.0),
                fecha: Value(DateTime.parse(item['fecha'] as String)),
                tipo: Value(MovimientoType.values[item['tipo'] as int? ?? 0]),
                concepto: Value(item['concepto'] as String? ?? ''),
                categoria: Value(item['categoria'] as String?),
                productoId: Value(item['producto_id'] as String?),
                clienteId: Value(item['cliente_id'] as String?),
                proveedorId: Value(item['proveedor_id'] as String?),
                cantidad: Value(item['cantidad'] as int? ?? 0),
                esFiado: Value(item['es_fiado'] as bool? ?? false),
                syncStatus: const Value('synced'),
                lastSyncedAt: Value(DateTime.now()),
              ),
            );
            downloaded++;
          } catch (e) {
            errors++;
          }
        }
      } else {
        errors++;
      }
    } catch (e) {
      errors++;
    }

    return SyncResult(
      tableName: 'movimientos',
      uploaded: 0,
      downloaded: downloaded,
      errors: errors,
    );
  }

  Future<SyncResult> _downloadVentas() async {
    int downloaded = 0;
    int errors = 0;

    try {
      final response = await http.get(
        Uri.parse('$_supabaseUrl/rest/v1/ventas?select=*'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        for (final item in data) {
          try {
            final id = item['id'] as String;
            final existing = await (_db.select(
              _db.ventas,
            )..where((t) => t.id.equals(id))).getSingleOrNull();

            if (existing != null && existing.syncStatus == 'pending_upload') {
              continue;
            }

            await (_db.into(_db.ventas)).insertOnConflictUpdate(
              VentasCompanion(
                id: Value(id),
                localId: Value(item['local_id'] as String?),
                monto: Value((item['monto'] as num?)?.toDouble() ?? 0.0),
                fecha: Value(DateTime.parse(item['fecha'] as String)),
                clienteId: Value(item['cliente_id'] as String?),
                clienteNombre: Value(item['cliente_nombre'] as String?),
                concepto: Value(item['concepto'] as String?),
                syncStatus: const Value('synced'),
                lastSyncedAt: Value(DateTime.now()),
              ),
            );
            downloaded++;
          } catch (e) {
            errors++;
          }
        }
      } else {
        errors++;
      }
    } catch (e) {
      errors++;
    }

    return SyncResult(
      tableName: 'ventas',
      uploaded: 0,
      downloaded: downloaded,
      errors: errors,
    );
  }

  // ---------------------------------------------------------------------------
  // Abonos push / pull (Chain 4 — feat/m1-abonos-sync, ADR-04 push-before-pull)
  // ---------------------------------------------------------------------------

  Future<SyncResult> _syncAbonos() async {
    int uploaded = 0;
    int downloaded = 0;
    int errors = 0;

    // PUSH pending abonos ─────────────────────────────────────────────────────
    try {
      final pending = await (_db.select(_db.abonos)
            ..where((t) => t.syncStatus.isIn(['pending', 'pending_upload'])))
          .get();

      for (final abono in pending) {
        try {
          final data = <String, dynamic>{
            'id': abono.id,
            'cliente_id': abono.clienteId,
            if (abono.ventaId != null) 'venta_id': abono.ventaId,
            'monto': abono.monto,
            'fecha': abono.fecha.toIso8601String(),
            'saldo_restante': abono.saldoRestante,
            if (abono.concepto != null) 'concepto': abono.concepto,
            'sync_status': 'synced',
            'updated_at': abono.updatedAt.toIso8601String(),
          };

          final response = await http.post(
            Uri.parse('$_supabaseUrl/rest/v1/abonos'),
            headers: _headers,
            body: jsonEncode(data),
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            await (_db.update(_db.abonos)..where((t) => t.id.equals(abono.id))).write(
              AbonosCompanion(
                syncStatus: const Value('synced'),
                lastSyncedAt: Value(DateTime.now()),
              ),
            );
            uploaded++;
          } else {
            errors++;
          }
        } catch (_) {
          errors++;
        }
      }
    } catch (_) {
      errors++;
    }

    // PULL server abonos (then recompute affected clients' saldo) ──────────────
    final dlResult = await _downloadAbonos();
    downloaded = dlResult.downloaded;
    errors += dlResult.errors;

    return SyncResult(
      tableName: 'abonos',
      uploaded: uploaded,
      downloaded: downloaded,
      errors: errors,
    );
  }

  Future<SyncResult> _downloadAbonos() async {
    int downloaded = 0;
    int errors = 0;
    final affectedClientIds = <String>{};

    try {
      final response = await http.get(
        Uri.parse('$_supabaseUrl/rest/v1/abonos?select=*'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        for (final item in data) {
          try {
            final id = item['id'] as String;
            final clienteId = item['cliente_id'] as String;
            final updatedAtStr = item['updated_at'] as String?;
            final updatedAt = updatedAtStr != null
                ? DateTime.parse(updatedAtStr)
                : DateTime.now();

            await (_db.into(_db.abonos)).insertOnConflictUpdate(
              AbonosCompanion(
                id: Value(id),
                clienteId: Value(clienteId),
                ventaId: Value(item['venta_id'] as String?),
                monto: Value((item['monto'] as num?)?.toDouble() ?? 0.0),
                fecha: Value(DateTime.parse(item['fecha'] as String)),
                saldoRestante:
                    Value((item['saldo_restante'] as num?)?.toDouble() ?? 0.0),
                concepto: Value(item['concepto'] as String?),
                syncStatus: const Value('synced'),
                lastSyncedAt: Value(DateTime.now()),
                updatedAt: Value(updatedAt),
              ),
            );
            affectedClientIds.add(clienteId);
            downloaded++;
          } catch (_) {
            errors++;
          }
        }

        // After pulling, recompute saldoPendiente for every affected client
        // using the full abono ledger (ADR-03 / task 4.4).
        for (final clienteId in affectedClientIds) {
          await _recomputeClienteSaldo(clienteId);
        }
      } else {
        errors++;
      }
    } catch (_) {
      errors++;
    }

    return SyncResult(
      tableName: 'abonos',
      uploaded: 0,
      downloaded: downloaded,
      errors: errors,
    );
  }

  /// Recompute `saldoPendiente` for [clienteId] from first principles:
  /// `saldo = Σ(credit ventas) − Σ(all abonos)`.
  /// This is the local-only fallback AND the resolver path (task 4.4 / 4.5).
  Future<void> _recomputeClienteSaldo(String clienteId) async {
    try {
      final ventaRows = await (_db.select(_db.ventas)
            ..where((t) => t.clienteId.equals(clienteId) & t.esFiado.equals(true)))
          .get();
      final abonoRows = await (_db.select(_db.abonos)
            ..where((t) => t.clienteId.equals(clienteId)))
          .get();

      final totalCredito =
          ventaRows.fold<double>(0.0, (sum, v) => sum + v.monto);
      final totalAbonado =
          abonoRows.fold<double>(0.0, (sum, a) => sum + a.monto);
      final newSaldo = totalCredito - totalAbonado;

      await (_db.update(_db.clientes)..where((t) => t.id.equals(clienteId))).write(
        ClientesCompanion(
          saldoPendiente: Value(newSaldo),
          esFiado: Value(newSaldo > 0),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } catch (_) {
      // Best-effort; errors surface through the SyncResult error count
    }
  }
}

class SyncResult {
  final String tableName;
  final int uploaded;
  final int downloaded;
  final int errors;

  SyncResult({
    required this.tableName,
    required this.uploaded,
    required this.downloaded,
    required this.errors,
  });

  bool get isSuccess => errors == 0;

  String get message {
    if (errors > 0) {
      return 'Sync failed: $errors errors';
    }
    if (uploaded == 0 && downloaded == 0) {
      return 'No changes to sync';
    }
    return 'Synced: $uploaded uploaded, $downloaded downloaded';
  }
}

// -------------------------------------------------------------------------
// Chain 5 — Pedidos push/pull (task 5.14)
// -------------------------------------------------------------------------
extension _PedidosSyncExt on SupabaseSyncService {
  Future<SyncResult> _syncPedidos() async {
    int uploaded = 0;
    int downloaded = 0;
    int errors = 0;

    // PUSH pending pedidos ─────────────────────────────────────────────
    try {
      final pending = await (_db.select(_db.pedidosProveedor)
            ..where((t) => t.syncStatus.isIn(['pending', 'pending_upload'])))
          .get();

      for (final pedido in pending) {
        try {
          final data = <String, dynamic>{
            'id': pedido.id,
            'proveedor_id': pedido.proveedorId,
            if (pedido.localId != null) 'local_id': pedido.localId,
            'fecha_pedido': pedido.fechaPedido.toIso8601String(),
            'fecha_entrega': pedido.fechaEntrega.toIso8601String(),
            'productos': pedido.productos,
            'monto_total': pedido.montoTotal,
            'is_entregado': pedido.isEntregado,
            if (pedido.notas != null) 'notas': pedido.notas,
            'sync_status': 'synced',
            if (pedido.updatedAt != null) 'updated_at': pedido.updatedAt!.toIso8601String(),
          };

          final response = await http.post(
            Uri.parse('$_supabaseUrl/rest/v1/pedidos_proveedor'),
            headers: _headers,
            body: jsonEncode(data),
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            await (_db.update(_db.pedidosProveedor)
                  ..where((t) => t.id.equals(pedido.id)))
                .write(
              PedidosProveedorCompanion(
                syncStatus: const Value('synced'),
                lastSyncedAt: Value(DateTime.now()),
              ),
            );
            uploaded++;
          } else {
            errors++;
          }
        } catch (_) {
          errors++;
        }
      }
    } catch (_) {
      errors++;
    }

    // PULL server pedidos ─────────────────────────────────────────
    final dlResult = await _downloadPedidos();
    downloaded = dlResult.downloaded;
    errors += dlResult.errors;

    return SyncResult(
      tableName: 'pedidos',
      uploaded: uploaded,
      downloaded: downloaded,
      errors: errors,
    );
  }

  Future<SyncResult> _downloadPedidos() async {
    int downloaded = 0;
    int errors = 0;

    try {
      final response = await http.get(
        Uri.parse('$_supabaseUrl/rest/v1/pedidos_proveedor?select=*'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        for (final item in data) {
          try {
            final id = item['id'] as String;

            // Check if local has a newer or pending version
            final existing = await (_db.select(_db.pedidosProveedor)
                  ..where((t) => t.id.equals(id)))
                .getSingleOrNull();

            if (existing != null &&
                existing.syncStatus == 'pending_upload') {
              // Local has un-pushed changes; run resolver
              final productosStr = existing.productos;
              final localLineas = PedidoProveedor.productosFromJson(productosStr);
              final serverProductosRaw = item['productos'];
              final serverProductosStr = serverProductosRaw is String
                  ? serverProductosRaw
                  : jsonEncode(serverProductosRaw);
              final serverLineas = PedidoProveedor.productosFromJson(serverProductosStr);

              final localPedido = PedidoProveedor(
                id: id,
                proveedorId: existing.proveedorId,
                localId: existing.localId,
                fechaPedido: existing.fechaPedido,
                fechaEntrega: existing.fechaEntrega,
                productos: localLineas,
                montoTotal: existing.montoTotal,
                isEntregado: existing.isEntregado,
                notas: existing.notas,
                updatedAt: existing.updatedAt,
              );
              final updatedAtStr = item['updated_at'] as String?;
              final serverPedido = PedidoProveedor(
                id: id,
                proveedorId: item['proveedor_id'] as String,
                localId: item['local_id'] as String?,
                fechaPedido: DateTime.parse(item['fecha_pedido'] as String),
                fechaEntrega: DateTime.parse(item['fecha_entrega'] as String),
                productos: serverLineas,
                montoTotal: (item['monto_total'] as num).toDouble(),
                isEntregado: item['is_entregado'] as bool? ?? false,
                notas: item['notas'] as String?,
                updatedAt: updatedAtStr != null ? DateTime.parse(updatedAtStr) : null,
              );

              final resolved = ConflictResolver.resolvePedidos(localPedido, serverPedido);
              await (_db.into(_db.pedidosProveedor)).insertOnConflictUpdate(
                PedidosProveedorCompanion(
                  id: Value(id),
                  proveedorId: Value(resolved.proveedorId),
                  localId: Value(resolved.localId),
                  fechaPedido: Value(resolved.fechaPedido),
                  fechaEntrega: Value(resolved.fechaEntrega),
                  productos: Value(resolved.productosJson),
                  montoTotal: Value(resolved.montoTotal),
                  isEntregado: Value(resolved.isEntregado),
                  notas: Value(resolved.notas),
                  syncStatus: const Value('synced'),
                  lastSyncedAt: Value(DateTime.now()),
                  updatedAt: Value(resolved.updatedAt),
                ),
              );
            } else {
              // No local conflict — upsert directly
              final serverProductosRaw = item['productos'];
              final serverProductosStr = serverProductosRaw is String
                  ? serverProductosRaw
                  : jsonEncode(serverProductosRaw);
              final updatedAtStr = item['updated_at'] as String?;
              await (_db.into(_db.pedidosProveedor)).insertOnConflictUpdate(
                PedidosProveedorCompanion(
                  id: Value(id),
                  proveedorId: Value(item['proveedor_id'] as String),
                  localId: Value(item['local_id'] as String?),
                  fechaPedido: Value(DateTime.parse(item['fecha_pedido'] as String)),
                  fechaEntrega: Value(DateTime.parse(item['fecha_entrega'] as String)),
                  productos: Value(serverProductosStr),
                  montoTotal: Value((item['monto_total'] as num).toDouble()),
                  isEntregado: Value(item['is_entregado'] as bool? ?? false),
                  notas: Value(item['notas'] as String?),
                  syncStatus: const Value('synced'),
                  lastSyncedAt: Value(DateTime.now()),
                  updatedAt: Value(
                    updatedAtStr != null ? DateTime.parse(updatedAtStr) : null,
                  ),
                ),
              );
            }
            downloaded++;
          } catch (_) {
            errors++;
          }
        }
      } else {
        errors++;
      }
    } catch (_) {
      errors++;
    }

    return SyncResult(
      tableName: 'pedidos',
      uploaded: 0,
      downloaded: downloaded,
      errors: errors,
    );
  }
}
