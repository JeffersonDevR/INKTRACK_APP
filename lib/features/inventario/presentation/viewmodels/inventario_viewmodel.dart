import 'package:InkTrack/core/base_crud_viewmodel.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/inventario/data/repositories/productos_repository.dart';
import 'package:InkTrack/features/inventario/data/repositories/drift_productos_repository.dart';
import 'package:InkTrack/features/categorias/data/repositories/categorias_repository.dart';

class InventarioViewModel extends BaseCrudViewModel<Producto> {
  final ProductosRepository _repository;
  final CategoriasRepository _categoriasRepo;
  String? _localId;
  List<String> _categorias = [];

  InventarioViewModel(this._repository, this._categoriasRepo) {
    _loadProductos();
    _loadCategorias();
  }

  void setLocalId(String? localId) {
    _localId = localId;
    notifyListeners();
  }

  String? get currentLocalId => _localId;

  List<Producto> get productos {
    if (_localId == null) {
      return _showInactive
          ? items.toList()
          : items.where((p) => p.isActivo).toList();
    }
    var result = items.where((p) => p.localId == _localId).toList();
    if (!_showInactive) {
      result = result.where((p) => p.isActivo).toList();
    }
    return result;
  }

  bool _showInactive = false;
  bool get showInactive => _showInactive;

  void toggleShowInactive() {
    _showInactive = !_showInactive;
    notifyListeners();
  }

  List<String> get categorias => List.unmodifiable(_categorias);

  Future<void> _loadCategorias() async {
    final cats = await _categoriasRepo.getAll('inventario');
    _categorias = cats.map((c) => c.nombre).toList();
    notifyListeners();
  }

  Future<void> agregarCategoria(String nombre) async {
    final trimmed = nombre.trim();
    if (trimmed.isEmpty || _categorias.contains(trimmed)) return;
    await _categoriasRepo.save(trimmed, 'inventario');
    await _loadCategorias();
  }

  Future<void> _loadProductos() async {
    clearAll();
    final loaded = await _repository.getAll();
    for (var producto in loaded) {
      add(producto);
    }
  }

  @override
  Future<void> refresh() async {
    await _loadProductos();
    await _loadCategorias();
    notifyListeners();
  }

  double get valorTotalInventario => _itemsFiltrados.fold(
    0.0,
    (sum, producto) => sum + (producto.precioVenta * producto.cantidad),
  );

  double get totalProductos =>
      _itemsFiltrados.fold(0.0, (sum, producto) => sum + producto.cantidad);

  int get totalInactivos => _itemsFiltrados.where((p) => !p.isActivo).length;

  // below methods unchanged from original

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
        if (isNew) {
          throw Exception('El producto ya existe (mismo código de barras)');
        }
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

  Future<void> actualizarStock(String id, num delta) async {
    final p = getById(id);
    if (p != null) {
      final actualizado = p.copyWith(
        cantidad: (p.cantidad + delta.toInt()).clamp(0, 999999),
      );
      await _repository.update(id, actualizado);
      update(id, actualizado);
    }
  }
  List<Producto> get _itemsFiltrados {
    if (_localId == null) return items;
    return items.where((p) => p.localId == _localId).toList();
  }

  List<Producto> getProductosPorCategoria(String categoria) => _itemsFiltrados
      .where((producto) => producto.categoria == categoria)
      .toList();

  List<Producto> getProductosPorProveedor(String proveedorId) => _itemsFiltrados
      .where((producto) => producto.proveedorId == proveedorId)
      .toList();

  List<Producto> get productosConStockBajo =>
      _itemsFiltrados.where((p) => p.stockBajo).toList();

  bool get hayStockBajo => _itemsFiltrados.any((p) => p.stockBajo);

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
