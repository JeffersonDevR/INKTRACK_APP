import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/inventario/data/repositories/drift_productos_repository.dart';

void main() {
  late AppDatabase db;
  late DriftProductosRepository repository;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    repository = DriftProductosRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('DriftProductosRepository — persistence round-trip', () {
    test('precioCompra, unidadesPorPaquete, esPaquete round-trip correctly',
        () async {
      final producto = Producto(
        id: 'prod-rt-001',
        nombre: 'Prueba RT',
        cantidad: 10,
        precioVenta: 150.0,
        precioCompra: 120.0,
        unidadesPorPaquete: 12,
        esPaquete: true,
        categoria: 'Papeleria',
        proveedorId: 'prov-1',
        stockMinimo: 5,
        localId: 'local-1',
        codigoBarras: 'BC-RT-001',
        codigoPersonalizado: null,
        proveedorNombre: 'Proveedor Test',
        isActivo: true,
      );

      await repository.save(producto);
      final result = await repository.getById('prod-rt-001');

      expect(result, isNotNull, reason: 'Product must be read back');
      expect(result!.precioCompra, 120.0,
          reason: 'precioCompra must persist through Drift');
      expect(result.unidadesPorPaquete, 12,
          reason: 'unidadesPorPaquete must persist through Drift');
      expect(result.esPaquete, isTrue,
          reason: 'esPaquete must persist through Drift');
    });

    test('null precioCompra round-trips correctly', () async {
      final producto = Producto(
        id: 'prod-rt-002',
        nombre: 'Sin Precio Compra',
        cantidad: 5,
        precioVenta: 80.0,
        precioCompra: null,
        unidadesPorPaquete: 1,
        esPaquete: false,
        categoria: 'Limpieza',
        proveedorId: 'prov-2',
        stockMinimo: 3,
      );

      await repository.save(producto);
      final result = await repository.getById('prod-rt-002');

      expect(result, isNotNull, reason: 'Product must be read back');
      expect(result!.precioCompra, isNull,
          reason: 'null precioCompra must persist as null');
    });

    test('update preserves precioCompra, unidadesPorPaquete, esPaquete',
        () async {
      final original = Producto(
        id: 'prod-rt-003',
        nombre: 'Original',
        cantidad: 10,
        precioVenta: 200.0,
        precioCompra: 150.0,
        unidadesPorPaquete: 24,
        esPaquete: true,
        categoria: 'Electronica',
        proveedorId: 'prov-3',
      );

      await repository.save(original);

      final updated = original.copyWith(
        cantidad: 20,
        precioCompra: 140.0,
        unidadesPorPaquete: 12,
        esPaquete: false,
      );

      await repository.update('prod-rt-003', updated);
      final result = await repository.getById('prod-rt-003');

      expect(result, isNotNull, reason: 'Product must exist after update');
      expect(result!.cantidad, 20,
          reason: 'Updated cantidad must be reflected');
      expect(result.precioCompra, 140.0,
          reason: 'Updated precioCompra must persist');
      expect(result.unidadesPorPaquete, 12,
          reason: 'Updated unidadesPorPaquete must persist');
      expect(result.esPaquete, isFalse,
          reason: 'Updated esPaquete must persist');
    });
  });
}
