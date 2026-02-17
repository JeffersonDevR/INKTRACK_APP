import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/features/ventas/viewmodels/ventas_viewmodel.dart';
import 'package:InkTrack/features/ventas/models/venta.dart';

void main() {
  late VentasViewModel viewModel;

  setUp(() {
    viewModel = VentasViewModel();
  });

  group('VentasViewModel Business Logic Requirements', () {
    test('TC-UNIT-01: Should register a valid sale and notify listeners', () {
      const validAmount = 100.0;
      bool wasNotified = false;
      viewModel.addListener(() => wasNotified = true);

      viewModel.guardar(Venta(
        id: '',
        monto: validAmount,
        fecha: DateTime.now(),
      ));

      expect(
        viewModel.ventas.length,
        1,
        reason: 'List count should increase by 1',
      );
      expect(
        viewModel.ventas.first.monto,
        validAmount,
        reason: 'Stored amount matches input',
      );
      expect(wasNotified, isTrue, reason: 'Listeners should be notified');
    });

    test('TC-UNIT-02: Should calculate daily total correctly', () {
      viewModel.guardar(Venta(id: '', monto: 50.0, fecha: DateTime.now()));
      viewModel.guardar(Venta(id: '', monto: 150.0, fecha: DateTime.now()));
      viewModel.guardar(Venta(id: '', monto: 25.50, fecha: DateTime.now()));

      final total = viewModel.totalVentasDia;

      expect(total, 225.50);
    });

    test(
      'TC-UNIT-03: Should NOT register sales with zero or negative amounts',
      () {
        final initialCount = viewModel.ventas.length;

        viewModel.guardar(Venta(id: '', monto: 0, fecha: DateTime.now()));
        viewModel.guardar(Venta(id: '', monto: -10.5, fecha: DateTime.now()));

        expect(
          viewModel.ventas.length,
          initialCount,
          reason: 'Invalid sales should not be added to the list',
        );
      },
    );
  });
}
