import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/inventario/data/repositories/drift_productos_repository.dart';

void main() {
  late AppDatabase db;
  late DriftProductosRepository repository;

  setUp(() {
    db = AppDatabase.fromConnection(NativeDatabase.memory());
    repository = DriftProductosRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('DriftProductosRepository — precioCompra persistence round-trip', () {
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
        codigoBarras: 'BC-RT-001',
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

  group('DriftProductosRepository — updated_at stamping', () {
    test('save sets updated_at to a non-null value', () async {
      final producto = Producto(
        id: 'prod-ut-001',
        nombre: 'Test updated_at',
        cantidad: 5,
        precioVenta: 100.0,
        categoria: 'Test',
        proveedorId: 'prov-1',
      );

      await repository.save(producto);
      final result = await repository.getById('prod-ut-001');

      expect(result, isNotNull);
      expect(result!.updatedAt, isNotNull,
          reason: 'updated_at MUST be set on save');
    });

    test('update advances updated_at beyond the save value', () async {
      final producto = Producto(
        id: 'prod-ut-002',
        nombre: 'Test update stamp',
        cantidad: 5,
        precioVenta: 100.0,
        categoria: 'Test',
        proveedorId: 'prov-1',
      );

      await repository.save(producto);
      final saved = await repository.getById('prod-ut-002');
      expect(saved, isNotNull);
      final savedUpdatedAt = saved!.updatedAt;
      expect(savedUpdatedAt, isNotNull);

      await repository.update(
        'prod-ut-002',
        producto.copyWith(cantidad: 10),
      );
      final updated = await repository.getById('prod-ut-002');

      expect(updated, isNotNull);
      expect(updated!.updatedAt, isNotNull);
      expect(
        updated.updatedAt!.isAfter(savedUpdatedAt!) ||
            updated.updatedAt!.isAtSameMomentAs(savedUpdatedAt),
        isTrue,
        reason: 'updated_at MUST NOT regress on update (Drift stores seconds)',
      );
    });

    test('unidad persists with default "unidad"', () async {
      final producto = Producto(
        id: 'prod-ut-003',
        nombre: 'Test unidad',
        cantidad: 5,
        precioVenta: 100.0,
        categoria: 'Test',
        proveedorId: 'prov-1',
      );

      await repository.save(producto);
      final result = await repository.getById('prod-ut-003');

      expect(result, isNotNull);
      expect(result!.unidad, 'unidad',
          reason: 'Default unidad must persist');
    });

    test('unidad persists with "kg"', () async {
      final producto = Producto(
        id: 'prod-ut-004',
        nombre: 'Test kg',
        cantidad: 5,
        precioVenta: 100.0,
        categoria: 'Test',
        proveedorId: 'prov-1',
        unidad: 'kg',
      );

      await repository.save(producto);
      final result = await repository.getById('prod-ut-004');

      expect(result, isNotNull);
      expect(result!.unidad, 'kg',
          reason: 'Custom unidad must persist');
    });
  });
}
