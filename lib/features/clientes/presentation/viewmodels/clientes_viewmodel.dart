import 'package:InkTrack/core/base_crud_viewmodel.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/clientes/data/repositories/clientes_repository.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';

class ClientesViewModel extends BaseCrudViewModel<Cliente> {
  final ClientesRepository _repository;

  ClientesViewModel(this._repository) {
    _loadClientes();
  }

  List<Cliente> get clientes => items;

  double get totalDeuda => items.fold(0.0, (sum, item) => sum + item.saldoPendiente);
  int get totalClientes => items.length;
  int get clientesConDeuda => items.where((c) => c.saldoPendiente > 0).length;

  Future<void> _loadClientes() async {
    final loaded = await _repository.getAll();
    for (var cliente in loaded) {
      add(cliente);
    }
  }

  Future<void> agregar({
    required String nombre,
    required String telefono,
    required String email,
    bool esFiado = false,
    MovimientosViewModel? movimientosVM,
  }) async {
    final nuevoCliente = Cliente(
      id: IdUtils.generateTimestampId(),
      nombre: nombre,
      telefono: telefono,
      email: email,
      esFiado: esFiado,
    );

    await _repository.save(nuevoCliente);
    add(nuevoCliente);

    if (movimientosVM != null) {
      final movimiento = Movimiento(
        id: IdUtils.generateId(),
        monto: 0,
        fecha: DateTime.now(),
        tipo: MovimientoType.actividad,
        concepto: 'Nuevo cliente: $nombre',
        categoria: 'Clientes',
      );
      // Note: MovimientosViewModel will also be refactored similarly
      movimientosVM.guardar(movimiento);
    }
  }

  Future<void> editar({
    required String id,
    required String nombre,
    required String telefono,
    required String email,
    required bool esFiado,
  }) async {
    final existing = getById(id);
    if (existing != null) {
      final actualizado = existing.copyWith(
        nombre: nombre,
        telefono: telefono,
        email: email,
        esFiado: esFiado,
      );
      
      await _repository.update(id, actualizado);
      update(id, actualizado);
    }
  }

  Future<void> actualizarSaldo(String id, double delta) async {
    final c = getById(id);
    if (c != null) {
      final actualizado = c.copyWith(
        saldoPendiente: c.saldoPendiente + delta,
      );
      
      await _repository.update(id, actualizado);
      update(id, actualizado);
    }
  }

  Future<void> eliminar(String id) async {
    await _repository.delete(id);
    delete(id);
  }

  Future<void> registrarPago(
    String clienteId,
    double monto,
    MovimientosViewModel movimientosVM,
  ) async {
    final cliente = getById(clienteId);
    if (cliente == null || monto <= 0) return;

    // 1. Reduce debt
    await actualizarSaldo(clienteId, -monto);

    // 2. Register income movement
    final movimiento = Movimiento(
      id: IdUtils.generateId(),
      monto: monto,
      fecha: DateTime.now(),
      tipo: MovimientoType.ingreso,
      concepto: 'Pago de deuda: ${cliente.nombre}',
      categoria: 'Cobros',
      clienteId: clienteId,
    );
    await movimientosVM.guardar(movimiento);
  }
}
