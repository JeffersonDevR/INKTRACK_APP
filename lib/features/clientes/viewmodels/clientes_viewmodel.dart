import '../../../core/base_crud_viewmodel.dart';
import '../models/cliente.dart';

class ClientesViewModel extends BaseCrudViewModel<Cliente> {
  List<Cliente> get clientes => items;

  void agregar({
    required String nombre,
    required String telefono,
    required String email,
  }) {
    add(
      Cliente(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: nombre,
        telefono: telefono,
        email: email,
      ),
    );
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
