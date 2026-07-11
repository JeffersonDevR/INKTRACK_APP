// SPEC-005 – Ventas and movements
// Tests for: MovimientosViewModel KPIs (ingresos, egresos, balance, daily totals),
// VentasViewModel sale registration with movement side-effect,
// and the link between a sale and a fiado client balance (via ClientesViewModel).

import 'package:flutter_test/flutter_test.dart';

import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/movimientos/data/repositories/movimientos_repository.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/movimientos/domain/use_cases/crear_movimiento_use_case.dart';

import 'package:InkTrack/features/ventas/presentation/viewmodels/ventas_viewmodel.dart';
import 'package:InkTrack/features/ventas/data/repositories/ventas_repository.dart';
import 'package:InkTrack/features/ventas/data/models/venta.dart';
import 'package:InkTrack/features/ventas/domain/use_cases/registrar_venta_use_case.dart';

import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/clientes/data/repositories/clientes_repository.dart';
import 'package:InkTrack/features/clientes/domain/use_cases/registrar_pago_cliente_use_case.dart';
import 'package:InkTrack/features/clientes/domain/use_cases/auto_crear_cliente_use_case.dart';

import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/inventario/data/repositories/productos_repository.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/inventario/domain/use_cases/actualizar_stock_use_case.dart';
import 'package:InkTrack/features/categorias/data/repositories/categorias_repository.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/core/data/local/database.dart';

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

Movimiento _ingreso(double monto, {DateTime? fecha}) => Movimiento(
      id: 'ing-${DateTime.now().microsecondsSinceEpoch}',
      monto: monto,
      fecha: fecha ?? DateTime.now(),
      tipo: MovimientoType.ingreso,
      concepto: 'Test ingreso',
    );

Movimiento _egreso(double monto, {DateTime? fecha}) => Movimiento(
      id: 'egr-${DateTime.now().microsecondsSinceEpoch}',
      monto: monto,
      fecha: fecha ?? DateTime.now(),
      tipo: MovimientoType.egreso,
      concepto: 'Test egreso',
    );

void main() {
  late MovimientosViewModel movimientosVM;
  late VentasViewModel ventasVM;
  late ClientesViewModel clientesVM;
  late InventarioViewModel inventarioVM;

  setUp(() {
    final movimientosRepo = InMemoryMovimientosRepository();
    final productosRepo = InMemoryProductosRepository();
    final clientesRepo = InMemoryClientesRepository();
    final ventasRepo = InMemoryVentasRepository();

    final crearMov = CrearMovimientoUseCase(movimientosRepo);
    final actualizarStock = ActualizarStockUseCase(productosRepo);

    movimientosVM = MovimientosViewModel(movimientosRepo, _FakeCategoriasRepository());
    ventasVM = VentasViewModel(
      ventasRepo,
      RegistrarVentaUseCase(
        ventasRepo: ventasRepo,
        productosRepo: productosRepo,
        clientesRepo: clientesRepo,
        crearMovimiento: crearMov,
        actualizarStock: actualizarStock,
        autoCrearCliente: AutoCrearClienteUseCase(clientesRepo, crearMov),
      ),
    );
    clientesVM = ClientesViewModel(
      clientesRepo,
      RegistrarPagoClienteUseCase(clientesRepo, crearMov),
      crearMov,
    );
    inventarioVM = InventarioViewModel(productosRepo, _FakeCategoriasRepository());
  });

  // ─── SPEC-005 – MovimientosViewModel KPIs ──────────────────────────────────

  group('SPEC-005 – Movement KPIs: totals and balance', () {
    test('TC-005-01: totalIngresos sums all ingreso movements', () async {
      await movimientosVM.guardar(_ingreso(100.0));
      await movimientosVM.guardar(_ingreso(250.0));

      expect(movimientosVM.totalIngresos, 350.0,
          reason: '100 + 250 = 350');
    });

    test('TC-005-02: totalEgresos sums all egreso movements', () async {
      await movimientosVM.guardar(_egreso(80.0));
      await movimientosVM.guardar(_egreso(120.0));

      expect(movimientosVM.totalEgresos, 200.0,
          reason: '80 + 120 = 200');
    });

    test('TC-005-03: balance = totalIngresos - totalEgresos', () async {
      await movimientosVM.guardar(_ingreso(500.0));
      await movimientosVM.guardar(_egreso(150.0));

      expect(movimientosVM.balance, 350.0,
          reason: '500 - 150 = 350');
    });

    test('TC-005-04: totalIngresosHoy only counts today\'s ingresos', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      await movimientosVM.guardar(_ingreso(200.0, fecha: yesterday));
      await movimientosVM.guardar(_ingreso(300.0)); // today

      expect(movimientosVM.totalIngresosHoy, 300.0,
          reason: 'Only today\'s ingreso (300) should be counted');
    });

    test('TC-005-05: totalEgresosHoy only counts today\'s egresos', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      await movimientosVM.guardar(_egreso(500.0, fecha: yesterday));
      await movimientosVM.guardar(_egreso(75.0)); // today

      expect(movimientosVM.totalEgresosHoy, 75.0,
          reason: 'Only today\'s egreso (75) should be counted');
    });

    test('TC-005-06: balanceHoy = ingresosHoy - egresosHoy', () async {
      await movimientosVM.guardar(_ingreso(400.0));
      await movimientosVM.guardar(_egreso(90.0));

      expect(movimientosVM.balanceHoy, 310.0,
          reason: '400 - 90 = 310');
    });

    test('TC-005-07: ingresos getter only contains ingreso type', () async {
      await movimientosVM.guardar(_ingreso(100.0));
      await movimientosVM.guardar(_egreso(50.0));

      expect(movimientosVM.ingresos.length, 1);
      expect(movimientosVM.ingresos.first.tipo, MovimientoType.ingreso);
    });

    test('TC-005-08: egresos getter only contains egreso type', () async {
      await movimientosVM.guardar(_ingreso(100.0));
      await movimientosVM.guardar(_egreso(50.0));

      expect(movimientosVM.egresos.length, 1);
      expect(movimientosVM.egresos.first.tipo, MovimientoType.egreso);
    });

    test('TC-005-09: historialCompleto sorts movements newest first', () async {
      final earlier = DateTime.now().subtract(const Duration(hours: 2));
      await movimientosVM.guardar(_ingreso(10.0, fecha: earlier));
      await movimientosVM.guardar(_ingreso(20.0)); // now

      final historial = movimientosVM.historialCompleto;
      expect(historial.first.monto, 20.0,
          reason: 'Newest movement should appear first');
      expect(historial.last.monto, 10.0);
    });
  });

  // ─── SPEC-005 – VentasViewModel + MovimientosViewModel side-effect ─────────

  group('SPEC-005 – Sale registration creates a movement', () {
    test('TC-005-10: guardar venta also creates an ingreso movement', () async {
      await ventasVM.guardar(
        Venta(id: '', monto: 150.0, fecha: DateTime.now(), concepto: 'Lapiceros'),
      );

      await movimientosVM.refresh();

      expect(ventasVM.ventas.length, 1,
          reason: 'Venta should be saved');
      expect(movimientosVM.ingresos.length, 1,
          reason: 'An ingreso movement must be created alongside the venta');
      expect(movimientosVM.ingresos.first.monto, 150.0,
          reason: 'Movement amount should match the venta amount');
    });

    test('TC-005-11: guardar venta always creates an ingreso movement via use case',
        () async {
      await ventasVM.guardar(
        Venta(id: '', monto: 200.0, fecha: DateTime.now()),
      );

      await movimientosVM.refresh();

      expect(ventasVM.ventas.length, 1);
      expect(movimientosVM.ingresos.length, 1,
          reason: 'Movement should always be created via RegistrarVentaUseCase');
    });
  });

  // ─── SPEC-005 – Fiado sale → client saldoPendiente ─────────────────────────

  group('SPEC-005 – Fiado sale updates client saldoPendiente', () {
    test('TC-005-12: registering a fiado sale accumulates client debt', () async {
      // Setup: create a fiado client
      await clientesVM.agregar(
        nombre: 'Cliente Fiado',
        telefono: '0991234567',
        email: 'fiado@test.com',
        esFiado: true,
      );
      final clienteId = clientesVM.clientes.first.id;

      // Simulate fiado sale: register the venta with auto-update
      const saleAmount = 250.0;
      await ventasVM.guardar(
        Venta(
          id: '',
          monto: saleAmount,
          fecha: DateTime.now(),
          clienteId: clienteId,
          esFiado: true,
          concepto: 'Venta fiado',
        ),
      );

      await clientesVM.refresh();

      expect(
        clientesVM.clientes.first.saldoPendiente,
        250.0,
        reason: 'Client saldoPendiente should reflect the fiado sale amount automatically',
      );
    });
  });

  // ─── SPEC-005 – Stock decrease on sale ─────────────────────────────────────

  group('SPEC-005 – Sale decreases product stock', () {
    test('TC-005-13: registering a sale reduces inventory stock automatically', () async {
      // Setup: product with 10 units
      await inventarioVM.guardar(Producto(
        id: 'prod-sale',
        nombre: 'Cuaderno',
        cantidad: 10,
        precioVenta: 5.0,
        categoria: 'Papeleria',
        proveedorId: '',
      ));

      // Simulate a sale of 3 units
      const unitsSold = 3.0;
      await ventasVM.guardar(
        Venta(
          id: '',
          monto: 15.0,
          fecha: DateTime.now(),
          productoId: 'prod-sale',
          cantidad: unitsSold,
          concepto: 'Cuadernos',
        ),
      );

      await inventarioVM.refresh();

      expect(
        inventarioVM.productos.first.cantidad,
        7,
        reason: 'Stock should decrease automatically: 10 - 3 = 7',
      );
    });

    test('TC-005-14: stock cannot go below 0 after sale', () async {
      await inventarioVM.guardar(Producto(
        id: 'prod-clamp',
        nombre: 'Lapicero',
        cantidad: 2,
        precioVenta: 1.0,
        categoria: 'Papeleria',
        proveedorId: '',
      ));

      // Attempt to sell more than what is in stock
      await inventarioVM.actualizarStock('prod-clamp', -10);

      expect(
        inventarioVM.productos.first.cantidad,
        0,
        reason: 'Stock clamp prevents going below 0',
      );
    });
  });

  // ─── SPEC-005 – Dashboard KPIs match real data ─────────────────────────────

  group('SPEC-005 – Dashboard KPI accuracy', () {
    test('TC-005-15: daily KPIs match actual movements saved today', () async {
      await movimientosVM.guardar(_ingreso(500.0));
      await movimientosVM.guardar(_ingreso(200.0));
      await movimientosVM.guardar(_egreso(100.0));

      expect(movimientosVM.totalIngresosHoy, 700.0,
          reason: '500 + 200 = 700');
      expect(movimientosVM.totalEgresosHoy, 100.0);
      expect(movimientosVM.balanceHoy, 600.0,
          reason: '700 - 100 = 600');
    });

    test('TC-005-16: past movements do not affect today\'s KPIs', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      await movimientosVM.guardar(_ingreso(9999.0, fecha: yesterday));
      await movimientosVM.guardar(_egreso(9999.0, fecha: yesterday));

      expect(movimientosVM.totalIngresosHoy, 0.0,
          reason: 'Yesterday\'s movements should not count in today KPIs');
      expect(movimientosVM.balanceHoy, 0.0);
    });
  });
}
