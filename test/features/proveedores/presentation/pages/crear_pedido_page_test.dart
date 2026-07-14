import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/proveedores/presentation/pages/crear_pedido_page.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  group('CrearPedidoPage initialProducto', () {
    testWidgets('seeds one product line at quantity 1 with purchase price', (
      tester,
    ) async {
      final providers = TestAppProviders();
      final producto = Producto(
        id: 'prod-seed',
        nombre: 'Tinta de prueba',
        cantidad: 10,
        precioVenta: 150.0,
        precioCompra: 100.0,
        categoria: 'Papeleria',
        proveedorId: 'prov-1',
      );

      await pumpPage(
        tester,
        CrearPedidoPage(initialProducto: producto),
        providers: providers,
      );

      expect(find.text('Tinta de prueba'), findsOneWidget);
      expect(find.text(r'$100.00'), findsNWidgets(2));
    });

    testWidgets(
      'falls back to sell price when purchase price is missing',
      (tester) async {
        final providers = TestAppProviders();
        final producto = Producto(
          id: 'prod-seed',
          nombre: 'Tinta de prueba',
          cantidad: 10,
          precioVenta: 150.0,
          categoria: 'Papeleria',
          proveedorId: 'prov-1',
        );

        await pumpPage(
          tester,
          CrearPedidoPage(initialProducto: producto),
          providers: providers,
        );

        expect(find.text('Tinta de prueba'), findsOneWidget);
        expect(find.text(r'$150.00'), findsNWidgets(2));
      },
    );
  });
}
