import '../../../core/base_crud_viewmodel.dart';
import '../models/cliente.dart';
import '../../movimientos/viewmodels/movimientos_viewmodel.dart';
import '../../movimientos/models/movimiento.dart';
import 'package:uuid/uuid.dart';

class ClientesViewModel extends BaseCrudViewModel<Cliente> {
  List<Cliente> get clientes => items;

  void agregar({
    required String nombre,
    required String telefono,
    required String email,
    MovimientosViewModel? movimientosVM,
  }) {
    add(
      Cliente(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: nombre,
        telefono: telefono,
        email: email,
      ),
    );

    if (movimientosVM != null) {
      movimientosVM.add(Movimiento(
        id: const Uuid().v4(),
        monto: 0,
        fecha: DateTime.now(),
        tipo: MovimientoType.actividad,
        concepto: 'Nuevo cliente: $nombre',
        categoria: 'Clientes',
      ));
    }
  }

  void editar({
    required String id,
    required String nombre,
    required String telefono,
    required String email,
  }) {
    update(
      id,
      Cliente(id: id, nombre: nombre, telefono: telefono, email: email),
    );
  }

  void eliminar(String id) => delete(id);
}
