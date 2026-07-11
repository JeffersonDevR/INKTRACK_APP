// SPEC-004 – Inventario basic lifecycle
// Tests for: InventarioViewModel CRUD, barcode logic (new vs restock),
// stock updates, low-stock detection, and inventory value computation.

import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/inventario/data/repositories/productos_repository.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/categorias/data/repositories/categorias_repository.dart';

class _FakeCategoriasRepository implements CategoriasRepository {
  final List<CategoriaData> _items = [];

  @override
  Future<List<CategoriaData>> getAll(String tipo) async =>
      _items.where((c) => c.tipo == tipo).toList();

  @override
  Future<void> save(String nombre, String tipo) async {
    _items.add(CategoriaData(
      id: IdUtils.generateId(),
      nombre: nombre,
      tipo: tipo,
      syncStatus: 'synced',
    ));
  }

  @override
  Future<void> update(String id, String nuevoNombre) async {
    final index = _items.indexWhere((c) => c.id == id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(nombre: nuevoNombre);
    }
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((c) => c.id == id);
  }

  @override
  Future<bool> exists(String nombre, String tipo) async {
    return _items.any((c) => c.nombre == nombre && c.tipo == tipo);
  }
}

Producto _makeProduct({
  String id = 'prod-1',
  String nombre = 'Cuaderno',
  int cantidad = 10,
  double precio = 5.0,
  double? precioVenta,
  String? codigoBarras,
  int stockMinimo = 3,
}) {
  return Producto(
    id: id,
    nombre: nombre,
    cantidad: cantidad,
    precioVenta: precioVenta ?? precio,
    categoria: 'Papeleria',
    proveedorId: '',
    stockMinimo: stockMinimo,
    codigoBarras: codigoBarras,
    codigoPersonalizado: null,
  );
}

void main() {
  late InventarioViewModel viewModel;

  setUp(() {
    viewModel = InventarioViewModel(
      InMemoryProductosRepository(),
      _FakeCategoriasRepository(),
    );
  });

  group('SPEC-004 – Inventario CRUD', () {
    test('TC-004-01: guardar a new product adds it to the list', () async {
      bool notified = false;
      viewModel.addListener(() => notified = true);

      await viewModel.guardar(_makeProduct());

      expect(viewModel.productos.length, 1,
          reason: 'Product list should have 1 item after guardar');
      expect(viewModel.productos.first.nombre, 'Cuaderno');
      expect(notified, isTrue, reason: 'Listeners must be notified');
    });

    test('TC-004-02: guardar with barcode uses barcode as product ID', () async {
      await viewModel.guardar(
        _makeProduct(id: '', codigoBarras: 'BARCODE-001'),
      );

      expect(viewModel.productos.first.id, 'BARCODE-001',
          reason: 'Barcode should be used as product ID when present');
    });

    test('TC-004-03: eliminar removes the product', () async {
      await viewModel.guardar(_makeProduct(id: 'prod-del'));
      await viewModel.eliminar('prod-del');

      expect(viewModel.productos.isEmpty, isTrue,
          reason: 'List should be empty after eliminar');
    });

    test('TC-004-04: guardar existing product updates it in place', () async {
      await viewModel.guardar(_makeProduct(id: 'prod-upd', cantidad: 5));
      await viewModel.guardar(_makeProduct(id: 'prod-upd', cantidad: 20));

      expect(viewModel.productos.length, 1,
          reason: 'Should not duplicate; must update existing');
      expect(viewModel.productos.first.cantidad, 20,
          reason: 'Quantity should be updated to 20');
    });
  });

  group('SPEC-004 – Barcode: new product vs restock flow', () {
    test('TC-004-05: findProductoByCodigo returns null for unknown barcode',
        () async {
      final result = viewModel.findProductoByCodigo('UNKNOWN-BC');

      expect(result, isNull,
          reason: 'Unknown barcode should return null → triggers new product flow');
    });

    test('TC-004-06: findProductoByCodigo returns product for known barcode',
        () async {
      await viewModel.guardar(_makeProduct(
        id: 'prod-bc',
        nombre: 'Lapicero',
        codigoBarras: 'BC-123',
      ));

      final result = viewModel.findProductoByCodigo('BC-123');

      expect(result, isNotNull,
          reason: 'Known barcode should return the matching product → triggers restock flow');
      expect(result!.nombre, 'Lapicero');
    });

    test('TC-004-07: findProductoByCodigo also matches by product id', () async {
      await viewModel.guardar(_makeProduct(id: 'prod-id-lookup'));

      final result = viewModel.findProductoByCodigo('prod-id-lookup');

      expect(result, isNotNull, reason: 'Lookup by ID should also work');
    });

    test('TC-004-08: findProductoByCodigo matches by custom code', () async {
      final product = _makeProduct(id: 'p-custom', nombre: 'Personalizado').copyWith(
        codigoPersonalizado: 'CUSTOM-123'
      );
      await viewModel.guardar(product);

      final result = viewModel.findProductoByCodigo('CUSTOM-123');

      expect(result, isNotNull, reason: 'Custom code should be found');
      expect(result!.id, 'p-custom');
    });
  });

  group('SPEC-004 – Stock management', () {
    test('TC-004-08: actualizarStock increases stock by delta', () async {
      await viewModel.guardar(_makeProduct(id: 'prod-stock', cantidad: 10));

      await viewModel.actualizarStock('prod-stock', 5);

      expect(viewModel.productos.first.cantidad, 15,
          reason: 'Stock should increase: 10 + 5 = 15');
    });

    test('TC-004-09: actualizarStock decreases stock by negative delta',
        () async {
      await viewModel.guardar(_makeProduct(id: 'prod-dec', cantidad: 10));

      await viewModel.actualizarStock('prod-dec', -3);

      expect(viewModel.productos.first.cantidad, 7,
          reason: 'Stock should decrease: 10 - 3 = 7');
    });

    test('TC-004-10: actualizarStock never goes below 0 (clamp)', () async {
      await viewModel.guardar(_makeProduct(id: 'prod-clamp', cantidad: 2));

      await viewModel.actualizarStock('prod-clamp', -100);

      expect(viewModel.productos.first.cantidad, 0,
          reason: 'Stock should be clamped at 0, never negative');
    });
  });

  group('SPEC-004 – Low-stock alerts', () {
    test('TC-004-11: stockBajo is true when cantidad <= stockMinimo', () {
      final product = _makeProduct(cantidad: 3, stockMinimo: 3);

      expect(product.stockBajo, isTrue,
          reason: 'Product is low-stock when cantidad == stockMinimo');
    });

    test('TC-004-12: stockBajo is false when cantidad > stockMinimo', () {
      final product = _makeProduct(cantidad: 4, stockMinimo: 3);

      expect(product.stockBajo, isFalse,
          reason: 'Product is not low-stock when cantidad > stockMinimo');
    });

    test('TC-004-13: productosConStockBajo lists only low-stock products',
        () async {
      await viewModel.guardar(_makeProduct(id: 'p1', cantidad: 2, stockMinimo: 5));
      await viewModel.guardar(_makeProduct(id: 'p2', cantidad: 10, stockMinimo: 5));
      await viewModel.guardar(_makeProduct(id: 'p3', cantidad: 0, stockMinimo: 5));

      final conStockBajo = viewModel.productosConStockBajo;

      expect(conStockBajo.length, 2,
          reason: 'p1 (2<=5) and p3 (0<=5) should be low-stock; p2 (10>5) should not');
    });

    test('TC-004-14: hayStockBajo is true when at least one product is low',
        () async {
      await viewModel.guardar(_makeProduct(id: 'pk1', cantidad: 1, stockMinimo: 5));

      expect(viewModel.hayStockBajo, isTrue);
    });

    test('TC-004-15: hayStockBajo is false when all products are sufficiently stocked',
        () async {
      await viewModel.guardar(_makeProduct(id: 'pk2', cantidad: 10, stockMinimo: 5));

      expect(viewModel.hayStockBajo, isFalse);
    });
  });

  group('SPEC-004 – Inventory value', () {
    test('TC-004-16: valorTotalInventario is price * cantidad summed', () async {
      await viewModel.guardar(_makeProduct(id: 'pv1', cantidad: 10, precio: 5.0));
      await viewModel.guardar(_makeProduct(id: 'pv2', cantidad: 4, precio: 25.0));

      expect(viewModel.valorTotalInventario, closeTo(150.0, 0.001),
          reason: '(10*5) + (4*25) = 50 + 100 = 150');
    });

    test('TC-004-17: totalProductos sums all quantities', () async {
      await viewModel.guardar(_makeProduct(id: 'pt1', cantidad: 8));
      await viewModel.guardar(_makeProduct(id: 'pt2', cantidad: 12));

      expect(viewModel.totalProductos, 20, reason: '8 + 12 = 20');
    });
  });
}
