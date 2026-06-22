import 'package:InkTrack/features/locales/data/models/local.dart';

class MigrationSummary {
  final int productos;
  final int clientes;
  final int proveedores;
  final int movimientos;
  final int ventas;
  final int pedidos;

  const MigrationSummary({
    required this.productos,
    required this.clientes,
    required this.proveedores,
    required this.movimientos,
    required this.ventas,
    required this.pedidos,
  });

  int get total =>
      productos + clientes + proveedores + movimientos + ventas + pedidos;
}

abstract class LocalesRepository {
  Future<List<Local>> getAll();
  Future<Local?> getById(String id);
  Future<void> save(Local local);
  Future<void> update(String id, Local local);
  Future<void> delete(String id);

  /// Returns per-entity counts of rows where [localId] is null.
  Future<MigrationSummary> getOrphanedCounts();

  /// Bulk-assigns [localId] to all rows with [localId] IS NULL
  /// across all entity tables, and marks them as [pending_upload].
  Future<void> assignLocalId(String localId);
}
