// SPEC-003 – Clientes basic lifecycle
// Tests for: ClientesViewModel CRUD, fiado flag, saldoPendiente accumulation.

import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/clientes/data/repositories/clientes_repository.dart';
import 'package:InkTrack/features/clientes/domain/use_cases/registrar_pago_cliente_use_case.dart';
import 'package:InkTrack/features/movimientos/data/repositories/movimientos_repository.dart';
import 'package:InkTrack/features/movimientos/domain/use_cases/crear_movimiento_use_case.dart';

void main() {
  late ClientesViewModel viewModel;

  setUp(() {
    final repo = InMemoryClientesRepository();
    final crearMov = CrearMovimientoUseCase(InMemoryMovimientosRepository());
    viewModel = ClientesViewModel(
      repo,
      RegistrarPagoClienteUseCase(repo, crearMov),
      crearMov,
    );
  });

  group('SPEC-003 – Clientes CRUD', () {
    test('TC-003-01: Guardar cliente y notificar a los listeners', () async {
      bool notified = false;
      viewModel.addListener(() => notified = true);

      await viewModel.agregar(
        nombre: 'Juan Perez',
        telefono: '0987654321',
        email: 'juan@test.com',
      );

      expect(
        viewModel.clientes.length,
        1,
        reason: 'La lista deberia incrementar despues de un agregado',
      );
      expect(viewModel.clientes.first.nombre, 'Juan Perez');
      expect(notified, isTrue, reason: 'Los listeners debe ser notifcados');
    });

    test('TC-003-02:Editar Cliente', () async {
      await viewModel.agregar(
        nombre: 'Ana Lopez',
        telefono: '0991111111',
        email: 'ana@test.com',
      );
      final id = viewModel.clientes.first.id;

      await viewModel.editar(
        id: id,
        nombre: 'Ana Lopez Editada',
        telefono: '0991111111',
        email: 'ana@test.com',
        esFiado: false,
      );

      expect(
        viewModel.clientes.first.nombre,
        'Ana Lopez Editada',
        reason: 'El nombre debe estar actualizado despues de la edicion',
      );
    });

    test('TC-003-03: eliminar removes the client', () async {
      await viewModel.agregar(
        nombre: 'Carlos Ruiz',
        telefono: '0992222222',
        email: 'carlos@test.com',
      );
      final id = viewModel.clientes.first.id;

      await viewModel.eliminar(id);

      expect(
        viewModel.clientes.isEmpty,
        isTrue,
        reason: 'List should be empty after eliminar',
      );
    });
  });

  group('SPEC-003 – Fiado and saldoPendiente', () {
    test(
      'TC-003-04: new client has esFiado=false and saldoPendiente=0 by default',
      () async {
        await viewModel.agregar(
          nombre: 'Maria Sin Fiado',
          telefono: '0993333333',
          email: 'maria@test.com',
        );

        final cliente = viewModel.clientes.first;
        expect(
          cliente.esFiado,
          isFalse,
          reason: 'esFiado should default to false',
        );
        expect(
          cliente.saldoPendiente,
          0.0,
          reason: 'saldoPendiente should default to 0',
        );
      },
    );

    test(
      'TC-003-05: agregar with esFiado=true stores the flag correctly',
      () async {
        await viewModel.agregar(
          nombre: 'Pedro Fiado',
          telefono: '0994444444',
          email: 'pedro@test.com',
          esFiado: true,
        );

        expect(
          viewModel.clientes.first.esFiado,
          isTrue,
          reason: 'esFiado flag must be persisted',
        );
      },
    );

    test(
      'TC-003-06: actualizarSaldo correctly accumulates positive delta',
      () async {
        await viewModel.agregar(
          nombre: 'Lucia Fiado',
          telefono: '0995555555',
          email: 'lucia@test.com',
          esFiado: true,
        );
        final id = viewModel.clientes.first.id;

        await viewModel.actualizarSaldo(id, 150.0);
        await viewModel.actualizarSaldo(id, 50.0);

        expect(
          viewModel.clientes.first.saldoPendiente,
          200.0,
          reason: 'saldoPendiente should accumulate: 150 + 50 = 200',
        );
      },
    );

    test(
      'TC-003-07: actualizarSaldo with negative delta reduces the balance',
      () async {
        await viewModel.agregar(
          nombre: 'Roberto Cobro',
          telefono: '0996666666',
          email: 'roberto@test.com',
          esFiado: true,
        );
        final id = viewModel.clientes.first.id;

        await viewModel.actualizarSaldo(id, 300.0); // add debt
        await viewModel.actualizarSaldo(id, -100.0); // partial payment

        expect(
          viewModel.clientes.first.saldoPendiente,
          200.0,
          reason:
              'saldoPendiente should be 300 - 100 = 200 after partial payment',
        );
      },
    );

    test(
      'TC-003-08: client with saldoPendiente > 0 is detectable from list',
      () async {
        await viewModel.agregar(
          nombre: 'Sofia Deuda',
          telefono: '0997777777',
          email: 'sofia@test.com',
          esFiado: true,
        );
        final id = viewModel.clientes.first.id;
        await viewModel.actualizarSaldo(id, 75.0);

        final clientesConDeuda = viewModel.clientes
            .where((c) => c.saldoPendiente > 0)
            .toList();

        expect(
          clientesConDeuda.length,
          1,
          reason: 'One client should have pending balance',
        );
        expect(clientesConDeuda.first.nombre, 'Sofia Deuda');
      },
    );
  });

  group('SPEC-003 – Debt Payments', () {
    test(
      'TC-003-09: registrarPago reduces debt',
      () async {
        await viewModel.agregar(
          nombre: 'Jose Deuda',
          telefono: '0998888888',
          email: 'jose@test.com',
          esFiado: true,
        );
        final id = viewModel.clientes.first.id;
        await viewModel.actualizarSaldo(id, 500.0);

        await viewModel.registrarPago(id, 200.0);

        final cliente = viewModel.clientes.first;
        expect(
          cliente.saldoPendiente,
          300.0,
          reason: '500 - 200 = 300 should be the new balance',
        );
      },
    );
  });

  group('SPEC-003 – Validaciones de teléfono duplicado', () {
    test(
      'TC-003-10: agregar cliente con teléfono duplicado lanza excepción',
      () async {
        await viewModel.agregar(
          nombre: 'Cliente Original',
          telefono: '3001234567',
          email: 'original@test.com',
        );

        expect(
          () => viewModel.agregar(
            nombre: 'Cliente Original',
            telefono: '3001234567',
            email: 'dup@test.com',
          ),
          throwsA(isA<Exception>()),
          reason: 'Debe lanzar excepción cuando nombre y teléfono ya existen',
        );
      },
    );

    test(
      'TC-003-11: checkDuplicado retorna true para nombre y teléfono duplicado',
      () async {
        await viewModel.agregar(
          nombre: 'Cliente Test',
          telefono: '3001234567',
          email: 'test@test.com',
        );

        expect(
          viewModel.checkDuplicado('Cliente Test', '3001234567'),
          isTrue,
          reason: 'Debe retornar true cuando nombre y teléfono coinciden',
        );

        expect(
          viewModel.checkDuplicado('Otro Nombre', '3001234567'),
          isFalse,
          reason: 'Debe retornar false si solo el teléfono coincide',
        );

        expect(
          viewModel.checkDuplicado('Cliente Test', '3009999999'),
          isFalse,
          reason: 'Debe retornar false si solo el nombre coincide',
        );
      },
    );
  });
}
