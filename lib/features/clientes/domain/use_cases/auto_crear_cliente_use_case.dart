import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/clientes/data/repositories/clientes_repository.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/movimientos/domain/use_cases/crear_movimiento_use_case.dart';

class AutoCrearClienteResult {
  final Cliente cliente;
  final bool wasCreated;

  AutoCrearClienteResult({required this.cliente, required this.wasCreated});
}

class AutoCrearClienteUseCase {
  final ClientesRepository _repository;
  final CrearMovimientoUseCase _crearMovimiento;

  AutoCrearClienteUseCase(this._repository, this._crearMovimiento);

  Future<AutoCrearClienteResult> call({
    required String nombre,
    required String telefono,
    required String email,
    String? localId,
    bool esFiado = false,
  }) async {
    final cliente = Cliente(
      id: IdUtils.generateTimestampId(),
      nombre: nombre,
      telefono: telefono,
      email: email,
      localId: localId,
      esFiado: esFiado,
    );

    await _repository.save(cliente);

    await _crearMovimiento(
      Movimiento(
        id: '',
        monto: 0,
        fecha: DateTime.now(),
        tipo: MovimientoType.actividad,
        concepto: 'Nuevo cliente: $nombre',
        categoria: 'Clientes',
      ),
    );

    return AutoCrearClienteResult(cliente: cliente, wasCreated: true);
  }
}
