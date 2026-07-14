import 'package:drift/drift.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/clientes/data/models/abono.dart';
import 'abonos_repository.dart';

class DriftAbonosRepository implements AbonosRepository {
  final AppDatabase _db;

  DriftAbonosRepository(this._db);

  @override
  Future<List<Abono>> getByCliente(String clienteId) async {
    final query = _db.select(_db.abonos)
      ..where((t) => t.clienteId.equals(clienteId))
      ..orderBy([(t) => OrderingTerm.desc(t.fecha)]);

    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<void> save(Abono item) async {
    await _db.transaction(() async {
      await _db
          .into(_db.abonos)
          .insertOnConflictUpdate(
            AbonosCompanion(
              id: Value(item.id),
              clienteId: Value(item.clienteId),
              ventaId: item.ventaId != null
                  ? Value(item.ventaId)
                  : const Value.absent(),
              monto: Value(item.monto),
              fecha: Value(item.fecha),
              saldoRestante: Value(item.saldoRestante),
              concepto: item.concepto != null
                  ? Value(item.concepto)
                  : const Value.absent(),
              syncStatus: const Value('pending_upload'),
              updatedAt: Value(DateTime.now()),
            ),
          );

      final double nuevoSaldo = await getSaldoPendiente(item.clienteId);
      await (_db.update(
        _db.clientes,
      )..where((t) => t.id.equals(item.clienteId))).write(
        ClientesCompanion(
          saldoPendiente: Value(nuevoSaldo),
          esFiado: Value(nuevoSaldo > 0),
          syncStatus: const Value('pending_upload'),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  @override
  Future<void> delete(String id) async {
    final abono = await (_db.select(
      _db.abonos,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (abono == null) return;

    await _db.transaction(() async {
      await (_db.delete(_db.abonos)..where((t) => t.id.equals(id))).go();

      final double nuevoSaldo = await getSaldoPendiente(abono.clienteId);
      await (_db.update(
        _db.clientes,
      )..where((t) => t.id.equals(abono.clienteId))).write(
        ClientesCompanion(
          saldoPendiente: Value(nuevoSaldo),
          esFiado: Value(nuevoSaldo > 0),
          syncStatus: const Value('pending_upload'),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  @override
  Future<double> getSaldoPendiente(String clienteId) async {
    final ventasQuery = await _db
        .customSelect(
          "SELECT SUM(monto) AS total_credito FROM ventas WHERE cliente_id = ? AND es_fiado = 1",
          variables: [Variable(clienteId)],
        )
        .getSingle();
    final double totalCredito =
        (ventasQuery.read<double?>('total_credito') ?? 0.0);

    final abonosQuery = await _db
        .customSelect(
          "SELECT SUM(monto) AS total_abonos FROM abonos WHERE cliente_id = ?",
          variables: [Variable(clienteId)],
        )
        .getSingle();
    final double totalAbonos =
        (abonosQuery.read<double?>('total_abonos') ?? 0.0);

    return totalCredito - totalAbonos;
  }

  Abono _toModel(AbonoData data) {
    return Abono(
      id: data.id,
      clienteId: data.clienteId,
      ventaId: data.ventaId,
      monto: data.monto,
      fecha: data.fecha,
      saldoRestante: data.saldoRestante,
      concepto: data.concepto,
      syncStatus: data.syncStatus,
      lastSyncedAt: data.lastSyncedAt,
      updatedAt: data.updatedAt,
    );
  }
}
