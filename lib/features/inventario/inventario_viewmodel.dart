import '../../core/base_crud_viewmodel.dart';
import 'producto.dart';

class InventarioViewModel extends BaseCrudViewModel<Producto> {
  List<Producto> get productos => items;

  void agregar({
    required String nombre,
    required int cantidad,
    required double precio,
    required String categoria,
    required String proveedorId,
    String? codigoBarras,
    String? proveedorNombre,
  }) {
    add(
      Producto(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: nombre,
        cantidad: cantidad,
        precio: precio,
        categoria: categoria,
        proveedorId: proveedorId,
        codigoBarras: codigoBarras,
        proveedorNombre: proveedorNombre,
      ),
    );
  }

  void editar({
    required String id,
    required String nombre,
    required int cantidad,
    required double precio,
    required String categoria,
    required String proveedorId,
    String? codigoBarras,
    String? proveedorNombre,
  }) {
    update(
      id,
      Producto(
        id: id,
        nombre: nombre,
        cantidad: cantidad,
        precio: precio,
        categoria: categoria,
        proveedorId: proveedorId,
        codigoBarras: codigoBarras,
        proveedorNombre: proveedorNombre,
      ),
    );
  }

  void eliminar(String id) => delete(id);

  double get valorTotalInventario => items.fold(
    0.0,
    (sum, producto) => sum + (producto.precio * producto.cantidad),
  );

  int get totalProductos =>
      items.fold(0, (sum, producto) => sum + producto.cantidad);

  List<Producto> getProductosPorCategoria(String categoria) =>
      items.where((producto) => producto.categoria == categoria).toList();

  List<Producto> getProductosPorProveedor(String proveedorId) =>
      items.where((producto) => producto.proveedorId == proveedorId).toList();
}
