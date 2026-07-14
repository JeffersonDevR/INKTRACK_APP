import 'package:InkTrack/core/base_crud_viewmodel.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/clientes/data/repositories/clientes_repository.dart';
import 'package:InkTrack/features/clientes/data/repositories/abonos_repository.dart';
import 'package:InkTrack/features/clientes/data/models/abono.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';

class ClientesViewModel extends BaseCrudViewModel<Cliente> {
  final ClientesRepository _repository;
  final AbonosRepository _abonosRepository;
  String? _localId;

  ClientesViewModel(this._repository, this._abonosRepository) {
    _loadClientes();
  }


  void setLocalId(String? localId) {
    _localId = localId;
    notifyListeners();
  }

  bool _showInactive = false;
  bool get showInactive => _showInactive;

  void toggleShowInactive() {
    _showInactive = !_showInactive;
    notifyListeners();
  }

  List<Cliente> get clientes {
    if (_localId == null) {
      return _showInactive
          ? items.toList()
          : items.where((c) => c.isActivo).toList();
    }
    var result = items.where((c) => c.localId == _localId).toList();
    if (!_showInactive) {
      result = result.where((c) => c.isActivo).toList();
    }
    return result;
  }

  int get totalInactivos => _localId != null
      ? items.where((c) => !c.isActivo && c.localId == _localId).length
      : items.where((c) => !c.isActivo).length;

  double get totalDeuda {
    final base = _localId != null
        ? items.where((c) => c.localId == _localId)
        : items;
    return base.fold(0.0, (sum, item) => sum + item.saldoPendiente);
  }

  int get totalClientes => _localId != null
      ? items.where((c) => c.localId == _localId).length
      : items.length;

  int get clientesConDeuda {
    final base = _localId != null
        ? items.where((c) => c.localId == _localId)
        : items;
    return base.where((c) => c.saldoPendiente > 0).length;
  }

  Future<void> _loadClientes() async {
    clearAll();
    final loaded = await _repository.getAll();
    for (var cliente in loaded) {
      add(cliente);
    }
  }

  @override
  Future<void> refresh() async {
    await _loadClientes();
    notifyListeners();
  }

  bool checkDuplicado(String nombre, String telefono) {
    if (telefono.trim().isEmpty) {
      return false;
    }
    return items.any(
      (c) =>
          c.telefono.trim() == telefono.trim() &&
          c.nombre.trim() == nombre.trim(),
    );
  }

  Future<String> agregar({
    required String nombre,
    required String telefono,
    required String email,
    bool esFiado = false,
    MovimientosViewModel? movimientosVM,
    String? localId,
    DateTime? promesaPago,
  }) async {
    if (checkDuplicado(nombre, telefono)) {
      throw Exception('El cliente ya existe (mismo nombre y teléfono)');
    }

    final nuevoCliente = Cliente(
      id: IdUtils.generateId(),
      nombre: nombre,
      telefono: telefono,
      email: email,
      localId: localId ?? _localId,
      esFiado: esFiado,
      promesaPago: promesaPago,
      updatedAt: DateTime.now(),
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
    DateTime? promesaPago,
  }) async {
    final existing = getById(id);
    if (existing != null) {
      final actualizado = existing.copyWith(
        nombre: nombre,
        telefono: telefono,
        email: email,
        esFiado: esFiado,
        promesaPago: promesaPago,
        updatedAt: DateTime.now(),
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
    MovimientosViewModel movimientosVM, {
    String? conceptoDetalle,
  }) async {
    final cliente = getById(clienteId);
    if (cliente == null || monto <= 0) return;

    final abono = Abono(
      id: IdUtils.generateId(),
      clienteId: clienteId,
      monto: monto,
      fecha: DateTime.now(),
      saldoRestante: cliente.saldoPendiente - monto,
      concepto: conceptoDetalle ?? 'Pago de deuda: ${cliente.nombre}',
      updatedAt: DateTime.now(),
    );

    await _abonosRepository.save(abono);
    await _loadClientes();
    await movimientosVM.refresh();
  }
}

