import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/movimientos/data/repositories/movimientos_repository.dart';

class CrearMovimientoResult {
  final Movimiento movimiento;
  final bool wasCreated;

  CrearMovimientoResult({required this.movimiento, required this.wasCreated});
}

class CrearMovimientoUseCase {
  final MovimientosRepository _repository;

  CrearMovimientoUseCase(this._repository);

  Future<CrearMovimientoResult> call(Movimiento movimiento) async {
    final isNew = movimiento.id.isEmpty;
    final id = isNew ? IdUtils.generateId() : movimiento.id;

    final toSave = movimiento.copyWith(id: id);

    if (isNew) {
      await _repository.save(toSave);
    } else {
      await _repository.update(id, toSave);
    }

    return CrearMovimientoResult(movimiento: toSave, wasCreated: isNew);
  }

  Future<CrearMovimientoResult> registrarActividad({
    required String concepto,
    required String categoria,
    double monto = 0,
    String? clienteId,
    String? localId,
    String? proveedorId,
    String? productoId,
  }) async {
    return call(
      Movimiento(
        id: '',
        monto: monto,
        fecha: DateTime.now(),
        tipo: MovimientoType.actividad,
        concepto: concepto,
        categoria: categoria,
        clienteId: clienteId,
        localId: localId,
        proveedorId: proveedorId,
        productoId: productoId,
      ),
    );
  }

  Future<CrearMovimientoResult> registrarIngreso({
    required double monto,
    required String concepto,
    required String categoria,
    String? clienteId,
    String? localId,
    String? productosJson,
  }) async {
    return call(
      Movimiento(
        id: '',
        monto: monto,
        fecha: DateTime.now(),
        tipo: MovimientoType.ingreso,
        concepto: concepto,
        categoria: categoria,
        clienteId: clienteId,
        localId: localId,
        productosJson: productosJson,
      ),
    );
  }

  Future<CrearMovimientoResult> registrarEgreso({
    required double monto,
    required String concepto,
    required String categoria,
    String? localId,
  }) async {
    return call(
      Movimiento(
        id: '',
        monto: monto,
        fecha: DateTime.now(),
        tipo: MovimientoType.egreso,
        concepto: concepto,
        categoria: categoria,
        localId: localId,
      ),
    );
  }
}
