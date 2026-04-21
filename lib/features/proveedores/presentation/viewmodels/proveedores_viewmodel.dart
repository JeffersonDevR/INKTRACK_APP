import 'package:InkTrack/core/base_crud_viewmodel.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/proveedores/data/models/proveedor.dart';
import 'package:InkTrack/features/proveedores/data/repositories/proveedores_repository.dart';
import '../../../movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import '../../../movimientos/data/models/movimiento.dart';

class ProveedoresViewModel extends BaseCrudViewModel<Proveedor> {
  final ProveedoresRepository _repository;
  String? _localId;

  ProveedoresViewModel(this._repository) {
    _loadProveedores();
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

  List<Proveedor> get proveedores {
    if (_showInactive) {
      return _localId != null
          ? items.where((p) => p.localId == _localId).toList()
          : items.toList();
    }
    var result = items.where((p) => p.isActivo).toList();
    if (_localId != null) {
      result = result.where((p) => p.localId == _localId).toList();
    }
    return result;
  }

  int get totalInactivos => _localId != null
      ? items.where((p) => !p.isActivo && p.localId == _localId).length
      : items.where((p) => !p.isActivo).length;

  Future<void> _loadProveedores() async {
    clearAll();
    final loaded = await _repository.getAll();
    for (var proveedor in loaded) {
      add(proveedor);
    }
  }

  @override
  Future<void> refresh() async {
    await _loadProveedores();
    notifyListeners();
  }

  bool checkDuplicado(String nombre, String telefono) {
    return items.any((p) => p.telefono.trim() == telefono.trim());
  }

  Future<void> agregar({
    required String nombre,
    required String telefono,
    required List<String> diasVisita,
    MovimientosViewModel? movimientosVM,
    String? localId,
  }) async {
    if (checkDuplicado(nombre, telefono)) {
      throw Exception('El proveedor ya existe (mismo nombre y teléfono)');
    }

    final nuevoProveedor = Proveedor(
      id: IdUtils.generateTimestampId(),
      nombre: nombre,
      telefono: telefono,
      diasVisita: diasVisita,
      localId: localId ?? _localId,
    );

    await _repository.save(nuevoProveedor);
    add(nuevoProveedor);

    if (movimientosVM != null) {
      final movimiento = Movimiento(
        id: IdUtils.generateId(),
        monto: 0,
        fecha: DateTime.now(),
        tipo: MovimientoType.actividad,
        concepto: 'Nuevo proveedor: $nombre',
        categoria: 'Proveedores',
      );
      movimientosVM.guardar(movimiento);
    }
  }

  Future<void> editar({
    required String id,
    required String nombre,
    required String telefono,
    required List<String> diasVisita,
  }) async {
    final existing = getById(id);
    if (existing != null) {
      final actualizado = existing.copyWith(
        nombre: nombre,
        telefono: telefono,
        diasVisita: diasVisita,
      );

      await _repository.update(id, actualizado);
      update(id, actualizado);
    }
  }

  Future<void> eliminar(String id) async {
    await _repository.softDelete(id);
    final proveedor = getById(id);
    if (proveedor != null) {
      update(id, proveedor.copyWith(isActivo: false));
    }
  }

  Future<void> reactivar(String id) async {
    final proveedor = await _repository.getByIdIncludingInactive(id);
    if (proveedor != null) {
      final activated = proveedor.copyWith(isActivo: true);
      await _repository.update(id, activated);
      if (getById(id) == null) {
        add(activated);
      } else {
        update(id, activated);
      }
    }
  }

  Proveedor? getByIdIncludingInactive(String id) {
    try {
      return items.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
