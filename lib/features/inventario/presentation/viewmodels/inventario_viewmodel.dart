import 'package:InkTrack/core/base_crud_viewmodel.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/inventario/data/repositories/productos_repository.dart';
import 'package:InkTrack/features/inventario/data/repositories/drift_productos_repository.dart';

class InventarioViewModel extends BaseCrudViewModel<Producto> {
  final ProductosRepository _repository;

  InventarioViewModel(this._repository) {
    _loadProductos();
  }

  List<Producto> get productos {
    if (_showInactive) {
      return items;
    }
    return items.where((p) => p.isActivo).toList();
  }

  bool _showInactive = false;
  bool get showInactive => _showInactive;

  void toggleShowInactive() {
    _showInactive = !_showInactive;
    notifyListeners();
  }

  final List<String> _categorias = [
    'Papeleria',
    'Comestibles',
    'Bebidas',
    'Otros',
  ];
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

    if (producto.codigoBarras != null && producto.codigoBarras!.isNotEmpty) {
      finalId = producto.codigoBarras!;
    } else if (isNew) {
      finalId = IdUtils.generateTimestampId();
    }

    final productoAGuardar = producto.copyWith(id: finalId);

    if (!isNew && producto.id != finalId) {
      await _repository.delete(producto.id);
      delete(producto.id);
      await _repository.save(productoAGuardar);
      add(productoAGuardar);
    } else {
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
    await _repository.softDelete(id);
    final producto = getById(id);
    if (producto != null) {
      update(id, producto.copyWith(isActivo: false));
    }
  }

  Future<void> reactivar(String id) async {
    final producto = await _repository.getByIdIncludingInactive(id);
    if (producto != null) {
      final activated = producto.copyWith(isActivo: true);
      await _repository.update(id, activated);
      if (getById(id) == null) {
        add(activated);
      } else {
        update(id, activated);
      }
    }
  }

  Producto? getByIdIncludingInactive(String id) {
    try {
      return items.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
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

  Future<void> restockWithReactivation(String codigo, int cantidad) async {
    Producto? producto = findProductoByCodigoIncludingInactive(codigo);

    if (producto != null && !producto.isActivo) {
      await reactivar(producto.id);
      producto = findProductoByCodigo(codigo);
    }

    if (producto != null) {
      await actualizarStock(producto.id, cantidad);
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

  int get totalInactivos {
    if (_repository is DriftProductosRepository) {
      return items.where((p) => !p.isActivo).length;
    }
    return 0;
  }

  Producto? findProductoByCodigo(String codigo) {
    try {
      return items.firstWhere(
        (p) =>
            p.codigoBarras == codigo ||
            p.codigoPersonalizado == codigo ||
            p.id == codigo,
      );
    } catch (_) {
      return null;
    }
  }

  Producto? findProductoByCodigoIncludingInactive(String codigo) {
    if (_repository is DriftProductosRepository) {
      // ignore: unnecessary_cast
      final repo = _repository as DriftProductosRepository;
      return repo.getByAnyCodeIncludingInactive(codigo) as Producto?;
    }
    return findProductoByCodigo(codigo);
  }
}
