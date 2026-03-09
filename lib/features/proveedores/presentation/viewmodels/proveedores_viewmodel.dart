import 'package:InkTrack/core/base_crud_viewmodel.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/proveedores/data/models/proveedor.dart';
import 'package:InkTrack/features/proveedores/data/repositories/proveedores_repository.dart';
import '../../../movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import '../../../movimientos/data/models/movimiento.dart';

class ProveedoresViewModel extends BaseCrudViewModel<Proveedor> {
  final ProveedoresRepository _repository;

  ProveedoresViewModel(this._repository) {
    _loadProveedores();
  }

  List<Proveedor> get proveedores => items;

  Future<void> _loadProveedores() async {
    final loaded = await _repository.getAll();
    for (var proveedor in loaded) {
      add(proveedor);
    }
  }

  Future<void> agregar({
    required String nombre,
    required String telefono,
    required List<String> diasVisita,
    MovimientosViewModel? movimientosVM,
  }) async {
    final nuevoProveedor = Proveedor(
      id: IdUtils.generateTimestampId(),
      nombre: nombre,
      telefono: telefono,
      diasVisita: diasVisita,
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
    await _repository.delete(id);
    delete(id);
  }
}
