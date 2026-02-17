import '../../../core/base_crud_viewmodel.dart';
import '../models/producto.dart';

class InventarioViewModel extends BaseCrudViewModel<Producto> {
  List<Producto> get productos => items;

  void guardar(Producto producto) {
    // If the product has a barcode, we use it as the ID.
    // This allows us to update the existing product if we scan it again,
    // or create a new one if it doesn't exist.
    // Ideally, we would look up if a product with this barcode already exists
    // but in this simple version, using the barcode as ID achieves "upsert" behavior
    // for local state management (Map/List based on ID).
    
    String finalId = producto.id;
    
    if (producto.codigoBarras != null && producto.codigoBarras!.isNotEmpty) {
       finalId = producto.codigoBarras!;
    } else if (finalId.isEmpty) {
       // If no ID and no barcode, generate a new random/time-based ID.
       finalId = DateTime.now().millisecondsSinceEpoch.toString();
    }

    // Create the final object with the correct ID
    final productoAGuardar = Producto(
      id: finalId,
      nombre: producto.nombre,
      cantidad: producto.cantidad,
      precio: producto.precio,
      categoria: producto.categoria,
      proveedorId: producto.proveedorId,
      codigoBarras: producto.codigoBarras,
      proveedorNombre: producto.proveedorNombre,
    );

    // Check if it exists to decide whether to add or update (for notification purposes if needed, 
    // but BaseCrudeViewModel.update handles existence check internally via index).
    // However, BaseCrudViewModel.add simply appends. We want Upsert.
    
    final existingIndex = items.indexWhere((p) => p.id == finalId);
    
    if (existingIndex != -1) {
      update(finalId, productoAGuardar);
    } else {
      add(productoAGuardar);
    }
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

  Producto? findProductoByCodigo(String codigo) {
    try {
      return items.firstWhere(
        (p) => p.codigoBarras == codigo || p.id == codigo,
      );
    } catch (_) {
      return null;
    }
  }
}
