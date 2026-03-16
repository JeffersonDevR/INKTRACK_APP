import 'package:InkTrack/core/base_crud_viewmodel.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/inventario/data/repositories/productos_repository.dart';

class InventarioViewModel extends BaseCrudViewModel<Producto> {
  final ProductosRepository _repository;

  InventarioViewModel(this._repository) {
    _loadProductos();
  }

  List<Producto> get productos => items;

  final List<String> _categorias = ['Papeleria', 'Comestibles', 'Bebidas', 'Otros'];
  List<String> get categorias => List.unmodifiable(_categorias);

  Future<void> _loadProductos() async {
    final loaded = await _repository.getAll();
    for (var producto in loaded) {
      add(producto);
    }
  }

  void agregarCategoria(String nombre) {
    if (nombre.trim().isNotEmpty && !_categorias.contains(nombre.trim())) {
      _categorias.add(nombre.trim());
      notifyListeners();
    }
  }

  Future<void> guardar(Producto producto) async {
    String finalId = producto.id;
    bool isNew = finalId.isEmpty;
    
    // If we have a barcode, it should be the ID
    if (producto.codigoBarras != null && producto.codigoBarras!.isNotEmpty) {
      finalId = producto.codigoBarras!;
    } else if (isNew) {
      finalId = IdUtils.generateTimestampId();
    }

    final productoAGuardar = producto.copyWith(id: finalId);
    
    // If it's an update where the ID might have changed
    if (!isNew && producto.id != finalId) {
      // Delete old one from repo and local list
      await _repository.delete(producto.id);
      delete(producto.id);
      // Save as new with finalId
      await _repository.save(productoAGuardar);
      add(productoAGuardar);
    } else {
      // Normal save or update with same ID
      final existingIndex = items.indexWhere((p) => p.id == finalId);
      if (existingIndex != -1) {
        await _repository.update(finalId, productoAGuardar);
        update(finalId, productoAGuardar);
      } else {
        await _repository.save(productoAGuardar);
        add(productoAGuardar);
      }
    }
  }

  Future<void> eliminar(String id) async {
    await _repository.delete(id);
    delete(id);
  }

  Future<void> actualizarStock(String id, int delta) async {
    final p = getById(id);
    if (p != null) {
      final actualizado = p.copyWith(
        cantidad: (p.cantidad + delta).clamp(0, 999999),
      );
      await _repository.update(id, actualizado);
      update(id, actualizado);
    }
  }

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

  List<Producto> get productosConStockBajo =>
      items.where((p) => p.stockBajo).toList();

  bool get hayStockBajo => items.any((p) => p.stockBajo);

  Producto? findProductoByCodigo(String codigo) {
    try {
      return items.firstWhere(
        (p) => p.codigoBarras == codigo || 
               p.codigoPersonalizado == codigo || 
               p.id == codigo,
      );
    } catch (_) {
      return null;
    }
  }
}
