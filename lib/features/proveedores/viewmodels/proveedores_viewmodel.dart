import '../../../core/base_crud_viewmodel.dart';
import '../models/proveedor.dart';

class ProveedoresViewModel extends BaseCrudViewModel<Proveedor> {
  List<Proveedor> get proveedores => items;

  void agregar({
    required String nombre,
    required String telefono,
    required int diasParaLlegar,
    required List<String> diasVisita,
  }) {
    add(
      Proveedor(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: nombre,
        telefono: telefono,
        diasParaLlegar: diasParaLlegar,
        diasVisita: diasVisita,
      ),
    );
  }

  void editar({
    required String id,
    required String nombre,
    required String telefono,
    required int diasParaLlegar,
    required List<String> diasVisita,
  }) {
    update(
      id,
      Proveedor(
        id: id,
        nombre: nombre,
        telefono: telefono,
        diasParaLlegar: diasParaLlegar,
        diasVisita: diasVisita,
      ),
    );
  }

  void eliminar(String id) => delete(id);
}
