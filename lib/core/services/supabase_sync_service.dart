import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:InkTrack/core/data/local/database.dart';
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
