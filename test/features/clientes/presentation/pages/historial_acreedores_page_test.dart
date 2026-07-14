import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/clientes/presentation/pages/historial_acreedores_page.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('renders debtor traffic light status badges correctly in HistorialAcreedoresPage', (tester) async {
    final providers = TestAppProviders();

    // 1. Setup mock clients with different statuses
    final now = DateTime.now();
    final clientAlDia = Cliente(
      id: 'c-1',
      nombre: 'Juan Al Dia',
      telefono: '123',
      saldoPendiente: 0.0,
      promesaPago: null,
    );
    final clientPorVencer = Cliente(
      id: 'c-2',
      nombre: 'Pedro Por Vencer',
      telefono: '456',
      saldoPendiente: 200.0,
      promesaPago: now.add(const Duration(days: 3)),
    );
    final clientVencido = Cliente(
      id: 'c-3',
      nombre: 'Luis Vencido',
      telefono: '789',
      saldoPendiente: 400.0,
      promesaPago: now.subtract(const Duration(days: 2)),
    );

    // Save mock clients to in-memory repo
    await providers.clientesRepo.save(clientAlDia);
    await providers.clientesRepo.save(clientPorVencer);
    await providers.clientesRepo.save(clientVencido);

    // Re-initialize viewmodel to load the mock clients
    await providers.clientesVM.refresh();

    // 2. Pump HistorialAcreedoresPage
    await tester.pumpWidget(
      appShell(providers: providers)(const HistorialAcreedoresPage()),
    );
    await tester.pumpAndSettle();

    // 3. Assertions: check presence of status text labels
    // Note: clientAlDia has saldo == 0, so it will not show up in the acreedores list (it only shows clients with debt)
    // Wait, let's verify if clientAlDia shows up. In HistorialAcreedoresPage, it filters:
    // final acreedores = clientesVM.items.where((c) => c.saldoPendiente > 0).toList();
    // Yes! So only clientPorVencer and clientVencido will render.
    
    expect(find.text('Pedro Por Vencer'), findsOneWidget);
    expect(find.text('Luis Vencido'), findsOneWidget);

    // Check for status badges
    expect(find.text('Por vencer'), findsOneWidget);
    expect(find.text('Vencido'), findsOneWidget);

    // Check for payment promise date labels
    expect(find.textContaining('Promesa de pago:'), findsNWidgets(2));
  });
}
