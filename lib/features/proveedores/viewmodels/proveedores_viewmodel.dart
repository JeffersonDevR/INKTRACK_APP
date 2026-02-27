import '../../../core/base_crud_viewmodel.dart';
import '../models/proveedor.dart';
import '../../movimientos/viewmodels/movimientos_viewmodel.dart';
import '../../movimientos/models/movimiento.dart';
import 'package:uuid/uuid.dart';

class ProveedoresViewModel extends BaseCrudViewModel<Proveedor> {
  List<Proveedor> get proveedores => items;

  void agregar({
    required String nombre,
    required String telefono,
    required List<String> diasVisita,
    MovimientosViewModel? movimientosVM,
  }) {
    add(
      Proveedor(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: nombre,
        telefono: telefono,
        diasVisita: diasVisita,
      ),
    );

    if (movimientosVM != null) {
      movimientosVM.add(Movimiento(
        id: const Uuid().v4(),
        monto: 0,
        fecha: DateTime.now(),
        tipo: MovimientoType.actividad,
        concepto: 'Nuevo proveedor: $nombre',
        categoria: 'Proveedores',
      ));
    }
  }

  void editar({
    required String id,
    required String nombre,
    required String telefono,
    required List<String> diasVisita,
  }) {
    update(
      id,
      Proveedor(
        id: id,
        nombre: nombre,
        telefono: telefono,
        diasVisita: diasVisita,
      ),
    );
  }

  void eliminar(String id) => delete(id);
}
