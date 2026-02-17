import '../../core/base_crud_viewmodel.dart';
import 'proveedor.dart';

class ProveedoresViewModel extends BaseCrudViewModel<Proveedor> {
  List<Proveedor> get proveedores => items;

  void agregar({
    required String nombre,
    required String telefono,
    required int diasParaLlegar,
    required String diaDeLlegada,
  }) {
    add(
      Proveedor(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: nombre,
        telefono: telefono,
        diasParaLlegar: diasParaLlegar,
        diaDeLlegada: diaDeLlegada,
      ),
    );
  }

  void editar({
    required String id,
    required String nombre,
    required String telefono,
    required int diasParaLlegar,
    required String diaDeLlegada,
  }) {
    update(
      id,
      Proveedor(
        id: id,
        nombre: nombre,
        telefono: telefono,
        diasParaLlegar: diasParaLlegar,
        diaDeLlegada: diaDeLlegada,
      ),
    );
  }

  void eliminar(String id) => delete(id);
}
