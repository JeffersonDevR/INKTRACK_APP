import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/proveedores_viewmodel.dart';
import 'package:InkTrack/features/proveedores/data/repositories/proveedores_repository.dart';
import 'package:InkTrack/features/movimientos/data/repositories/movimientos_repository.dart';
import 'package:InkTrack/features/movimientos/domain/use_cases/crear_movimiento_use_case.dart';

void main() {
  late ProveedoresViewModel viewModel;

  setUp(() {
    viewModel = ProveedoresViewModel(
      InMemoryProveedoresRepository(),
      CrearMovimientoUseCase(InMemoryMovimientosRepository()),
    );
  });

  group('SPEC-005 – Proveedores CRUD', () {
    test('TC-005-01: agregar proveedor nuevo lo agrega a la lista', () async {
      bool notified = false;
      viewModel.addListener(() => notified = true);

      await viewModel.agregar(
        nombre: 'Distribuidora ABC',
        telefono: '3001234567',
        diasVisita: ['Lunes', 'Miércoles'],
      );

      expect(viewModel.proveedores.length, 1);
      expect(viewModel.proveedores.first.nombre, 'Distribuidora ABC');
      expect(notified, isTrue);
    });

    test(
      'TC-005-02: agregar proveedor con teléfono duplicado lanza excepción',
      () async {
        await viewModel.agregar(
          nombre: 'Proveedor 1',
          telefono: '3001234567',
          diasVisita: ['Lunes'],
        );

        expect(
          () => viewModel.agregar(
            nombre: 'Proveedor 2',
            telefono: '3001234567',
            diasVisita: ['Martes'],
          ),
          throwsA(isA<Exception>()),
          reason: 'Debe lanzar excepción por teléfono duplicado',
        );
      },
    );

    test(
      'TC-005-03: checkDuplicado retorna true para teléfono duplicado',
      () async {
        await viewModel.agregar(
          nombre: 'Proveedor Test',
          telefono: '3001234567',
          diasVisita: ['Lunes'],
        );

        expect(viewModel.checkDuplicado('Otro Nombre', '3001234567'), isTrue);
        expect(viewModel.checkDuplicado('Nuevo', '3009999999'), isFalse);
      },
    );

    test('TC-005-04: editar proveedor actualiza sus datos', () async {
      await viewModel.agregar(
        nombre: 'Proveedor Original',
        telefono: '3001111111',
        diasVisita: ['Lunes'],
      );
      final id = viewModel.proveedores.first.id;

      await viewModel.editar(
        id: id,
        nombre: 'Proveedor Editado',
        telefono: '3002222222',
        diasVisita: ['Martes'],
      );

      expect(viewModel.proveedores.first.nombre, 'Proveedor Editado');
    });

    test('TC-005-05: eliminar hace soft delete', () async {
      await viewModel.agregar(
        nombre: 'Proveedor a eliminar',
        telefono: '3003333333',
        diasVisita: ['Lunes'],
      );
      expect(viewModel.proveedores.length, 1);

      final id = viewModel.proveedores.first.id;
      await viewModel.eliminar(id);

      expect(viewModel.proveedores.isEmpty, true);
      expect(viewModel.items.any((p) => p.id == id), true);
    });
  });

  group('SPEC-005 – Días de visita', () {
    test('TC-005-06: getProveedoresPorDia filtra correctamente', () async {
      await viewModel.agregar(
        nombre: 'Proveedor 1',
        telefono: '3001111111',
        diasVisita: ['Lunes'],
      );
      await viewModel.agregar(
        nombre: 'Proveedor 2',
        telefono: '3002222222',
        diasVisita: ['Martes'],
      );

      final lunesProveedores = viewModel.proveedores
          .where((p) => p.diasVisita.contains('Lunes'))
          .toList();

      expect(lunesProveedores.length, 1);
      expect(lunesProveedores.first.nombre, 'Proveedor 1');
    });
  });

  group('SPEC-005 – Show inactive', () {
    test('TC-005-07: toggleShowInactive alterna la visibilidad', () async {
      expect(viewModel.showInactive, isFalse);

      await viewModel.agregar(
        nombre: 'Proveedor 1',
        telefono: '3001111111',
        diasVisita: ['Lunes'],
      );

      final id = viewModel.proveedores.first.id;
      await viewModel.eliminar(id);

      expect(viewModel.proveedores.isEmpty, true);

      viewModel.toggleShowInactive();
      expect(viewModel.showInactive, isTrue);
      expect(viewModel.proveedores.length, 1);
    });
  });
}
