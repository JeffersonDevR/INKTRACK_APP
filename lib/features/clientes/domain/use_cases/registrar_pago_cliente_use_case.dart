import 'package:InkTrack/features/clientes/data/repositories/clientes_repository.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/movimientos/domain/use_cases/crear_movimiento_use_case.dart';

class RegistrarPagoClienteUseCase {
  final ClientesRepository _clientesRepo;
  final CrearMovimientoUseCase _crearMovimiento;

  RegistrarPagoClienteUseCase(this._clientesRepo, this._crearMovimiento);

  Future<void> call(
    String clienteId,
    double monto, {
    String? conceptoDetalle,
  }) async {
    if (monto <= 0) return;

    final cliente = await _clientesRepo.getById(clienteId);
    if (cliente == null) return;

    final newSaldo = cliente.saldoPendiente - monto;
    final actualizado = cliente.copyWith(
      saldoPendiente: newSaldo.clamp(0.0, double.infinity),
      esFiado: newSaldo > 0,
    );
    await _clientesRepo.update(clienteId, actualizado);

    await _crearMovimiento(
      Movimiento(
        id: '',
        monto: monto,
        fecha: DateTime.now(),
        tipo: MovimientoType.ingreso,
        concepto: conceptoDetalle ?? 'Pago de deuda: ${cliente.nombre}',
        categoria: 'Cobros',
        clienteId: clienteId,
      ),
    );
  }
}
