import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:InkTrack/features/inventario/presentation/pages/barcode_scanner_page.dart';
import 'package:InkTrack/features/inventario/presentation/pages/producto_form_page.dart';
import 'package:InkTrack/features/proveedores/presentation/pages/crear_pedido_page.dart';
import '../../../../helpers/pump_app.dart';

BarcodeCapture _capture(String code) {
  return BarcodeCapture(
    barcodes: [Barcode(rawValue: code)],
    image: null,
  );
}

void main() {
  group('BarcodeScannerPage modes', () {
    testWidgets(
      'restock mode with existing product shows restock confirm dialog and navigates to CrearPedidoPage',
      (tester) async {
        final providers = TestAppProviders();
        await pumpPage(
          tester,
          const BarcodeScannerPage(mode: BarcodeScannerMode.restock),
          providers: providers,
        );

        final state = tester.state(find.byType(BarcodeScannerPage));
        (state as dynamic).onDetectForTest(_capture('7701001001'));
        await tester.pumpAndSettle();

        expect(find.text('Producto ya existe'), findsOneWidget);
        expect(find.text('Crear pedido'), findsOneWidget);

        await tester.tap(find.text('Crear pedido'));
        await tester.pumpAndSettle();

        expect(find.byType(CrearPedidoPage), findsOneWidget);
        expect(find.text('Arroz 1kg'), findsOneWidget);
      },
    );

    testWidgets(
      'restock mode with unknown code navigates to ProductoFormPage',
      (tester) async {
        final providers = TestAppProviders();
        await pumpPage(
          tester,
          const BarcodeScannerPage(mode: BarcodeScannerMode.restock),
          providers: providers,
        );

        final state = tester.state(find.byType(BarcodeScannerPage));
        (state as dynamic).onDetectForTest(_capture('UNKNOWN_CODE'));
        await tester.pumpAndSettle();

        expect(find.byType(ProductoFormPage), findsOneWidget);
      },
    );

    testWidgets(
      'selectProduct mode with existing product pops the product',
      (tester) async {
        final providers = TestAppProviders();
        Object? capturedResult;

        await tester.pumpWidget(
          appShell(providers: providers)(
            Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BarcodeScannerPage(
                          mode: BarcodeScannerMode.selectProduct,
                        ),
                      ),
                    );
                    capturedResult = result;
                  },
                  child: const Text('OPEN SCANNER'),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('OPEN SCANNER'));
        await tester.pumpAndSettle();

        final state = tester.state(find.byType(BarcodeScannerPage));
        (state as dynamic).onDetectForTest(_capture('7701001001'));
        await tester.pumpAndSettle();

        expect(find.byType(BarcodeScannerPage), findsNothing);
        expect(capturedResult, isNotNull);
        expect(
          (capturedResult as dynamic).nombre,
          'Arroz 1kg',
        );
      },
    );

    testWidgets(
      'scanCode mode pops the raw barcode string',
      (tester) async {
        final providers = TestAppProviders();
        Object? capturedResult;

        await tester.pumpWidget(
          appShell(providers: providers)(
            Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BarcodeScannerPage(
                          mode: BarcodeScannerMode.scanCode,
                        ),
                      ),
                    );
                    capturedResult = result;
                  },
                  child: const Text('OPEN SCANNER'),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('OPEN SCANNER'));
        await tester.pumpAndSettle();

        final state = tester.state(find.byType(BarcodeScannerPage));
        (state as dynamic).onDetectForTest(_capture('7701001001'));
        await tester.pumpAndSettle();

        expect(find.byType(BarcodeScannerPage), findsNothing);
        expect(capturedResult, equals('7701001001'));
      },
    );
  });
}
