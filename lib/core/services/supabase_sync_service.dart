import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:drift/drift.dart';

class SupabaseSyncService {
  final AppDatabase _db;
  final String _supabaseUrl;
  final String _supabaseKey;

  SupabaseSyncService(this._db, this._supabaseUrl, this._supabaseKey);

  Map<String, String> get _headers => {
    'apikey': _supabaseKey,
    'Authorization': 'Bearer $_supabaseKey',
    'Content-Type': 'application/json',
    'Prefer': 'resolution=merge-duplicates',
  };

  Future<SyncResult> syncTable(String tableName) async {
    int uploaded = 0;
    int downloaded = 0;
    int errors = 0;

    switch (tableName) {
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
    int downloaded = 0;
    int errors = 0;

    switch (tableName) {
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
    final results = await Future.wait([
      downloadFromSupabase('productos'),
      downloadFromSupabase('clientes'),
      downloadFromSupabase('proveedores'),
      downloadFromSupabase('movimientos'),
      downloadFromSupabase('ventas'),
    ]);

    return SyncResult(
      tableName: 'all',
      uploaded: 0,
      downloaded: results.fold(0, (sum, r) => sum + r.downloaded),
      errors: results.fold(0, (sum, r) => sum + r.errors),
    );
  }

  Future<SyncResult> syncAll() async {
    final results = await Future.wait([
      syncTable('productos'),
      syncTable('clientes'),
      syncTable('proveedores'),
      syncTable('movimientos'),
      syncTable('ventas'),
    ]);

    return SyncResult(
      tableName: 'all',
      uploaded: results.fold(0, (sum, r) => sum + r.uploaded),
      downloaded: results.fold(0, (sum, r) => sum + r.downloaded),
      errors: results.fold(0, (sum, r) => sum + r.errors),
    );
  }

  Future<SyncResult> _syncProductos() async {
    int uploaded = 0;
    int downloaded = 0;
    int errors = 0;

    try {
      final pending = await (_db.select(
        _db.productos,
      )..where((t) => t.syncStatus.equals('pending_upload'))).get();

      for (final producto in pending) {
        try {
          final data = {
            'id': producto.id,
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
      )..where((t) => t.syncStatus.equals('pending_upload'))).get();

      for (final cliente in pending) {
        try {
          final data = {
            'id': cliente.id,
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
      )..where((t) => t.syncStatus.equals('pending_upload'))).get();

      for (final proveedor in pending) {
        try {
          final data = {
            'id': proveedor.id,
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
      )..where((t) => t.syncStatus.equals('pending_upload'))).get();

      for (final movimiento in pending) {
        try {
          final data = {
            'id': movimiento.id,
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
      )..where((t) => t.syncStatus.equals('pending_upload'))).get();

      for (final venta in pending) {
        try {
          final data = {
            'id': venta.id,
            'monto': venta.monto,
            'fecha': venta.fecha.toIso8601String(),
            'cliente_id': venta.clienteId,
            'cliente_nombre': venta.clienteNombre,
            'concepto': venta.concepto,
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
            await (_db.into(_db.productos)).insertOnConflictUpdate(
              ProductosCompanion(
                id: Value(item['id'] as String),
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
            final emailValue = item['email'] as String?;
            await (_db.into(_db.clientes)).insertOnConflictUpdate(
              ClientesCompanion(
                id: Value(item['id'] as String),
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
            final diasVisitaStr = item['dias_visita'] as String? ?? '';
            final diasVisita = diasVisitaStr.isEmpty
                ? <String>[]
                : diasVisitaStr.split(',');

            await (_db.into(_db.proveedores)).insertOnConflictUpdate(
              ProveedoresCompanion(
                id: Value(item['id'] as String),
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
            await (_db.into(_db.movimientos)).insertOnConflictUpdate(
              MovimientosCompanion(
                id: Value(item['id'] as String),
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
            await (_db.into(_db.ventas)).insertOnConflictUpdate(
              VentasCompanion(
                id: Value(item['id'] as String),
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
