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

  bool _showInactive = false;
  bool get showInactive => _showInactive;

  void toggleShowInactive() {
    _showInactive = !_showInactive;
    notifyListeners();
  }

  List<Cliente> get clientes {
    if (_showInactive) {
      return items;
    }
    return items.where((c) => c.isActivo).toList();
  }

  int get totalInactivos => items.where((c) => !c.isActivo).length;

  double get totalDeuda =>
      items.fold(0.0, (sum, item) => sum + item.saldoPendiente);
  int get totalClientes => items.length;
  int get clientesConDeuda => items.where((c) => c.saldoPendiente > 0).length;

  Future<void> _loadClientes() async {
    final loaded = await _repository.getAll();
    for (var cliente in loaded) {
      add(cliente);
    }
  }

  bool checkDuplicado(String nombre, String telefono) {
    return items.any((c) => c.telefono.trim() == telefono.trim());
  }

  Future<String> agregar({
    required String nombre,
    required String telefono,
    required String email,
    bool esFiado = false,
    MovimientosViewModel? movimientosVM,
  }) async {
    if (checkDuplicado(nombre, telefono)) {
      throw Exception('El cliente ya existe (mismo nombre y teléfono)');
    }

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
      movimientosVM.guardar(movimiento);
    }

    return nuevoCliente.id;
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
      final newSaldo = c.saldoPendiente + delta;
      final shouldBeFiado = newSaldo > 0;

      final actualizado = c.copyWith(
        saldoPendiente: newSaldo,
        esFiado: shouldBeFiado || c.esFiado,
      );

      await _repository.update(id, actualizado);
      update(id, actualizado);
    }
  }

  Future<void> eliminar(String id) async {
    await _repository.softDelete(id);
    final cliente = getById(id);
    if (cliente != null) {
      update(id, cliente.copyWith(isActivo: false));
    }
  }

  Future<void> reactivar(String id) async {
    final cliente = await _repository.getByIdIncludingInactive(id);
    if (cliente != null) {
      final activated = cliente.copyWith(isActivo: true);
      await _repository.update(id, activated);
      if (getById(id) == null) {
        add(activated);
      } else {
        update(id, activated);
      }
    }
  }

  Cliente? getByIdIncludingInactive(String id) {
    try {
      return items.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> registrarPago(
    String clienteId,
    double monto,
    MovimientosViewModel movimientosVM,
  ) async {
    final cliente = getById(clienteId);
    if (cliente == null || monto <= 0) return;

    await actualizarSaldo(clienteId, -monto);

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
