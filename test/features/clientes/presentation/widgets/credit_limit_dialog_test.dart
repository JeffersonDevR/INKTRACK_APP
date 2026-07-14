import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/features/clientes/presentation/widgets/credit_limit_dialog.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('renders creditLimitExceededTitle, message, continue question and actions', (tester) async {
    await pumpPage(
      tester,
      CreditLimitDialog(
        actual: 800.0,
        nuevo: 300.0,
        limite: 1000.0,
        onVerifyPin: (pin) async {
          return pin == '1234';
        },
        onOverrideSuccess: () {
        },
      ),
    );

    expect(find.text('Límite de crédito excedido'), findsOneWidget);
    expect(find.text('El saldo pendiente del cliente (800.00) más el nuevo monto (300.00) excede su límite de crédito (1000.00).'), findsOneWidget);
    expect(find.text('¿Desea continuar de todos modos?'), findsOneWidget);
    expect(find.text('Cancelar'), findsOneWidget);
  });
}
