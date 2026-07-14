import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/core/widgets/stat_card.dart';
import 'package:InkTrack/core/theme/app_theme.dart';

void main() {
  group('StatCard Widget', () {
    testWidgets('muestra label y valor correctamente', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(
              label: 'Total Ventas',
              value: '\$1.500.000',
              color: AppTheme.successColor,
              icon: Icons.trending_up,
            ),
          ),
        ),
      );

      expect(find.text('Total Ventas'), findsOneWidget);
      expect(find.text('\$1.500.000'), findsOneWidget);
      expect(find.byIcon(Icons.trending_up), findsAtLeast(1));
    });

    testWidgets('muestra subtítulo cuando se proporciona', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(
              label: 'Ingresos',
              value: '\$500.000',
              color: AppTheme.successColor,
              icon: Icons.attach_money,
              subtitle: 'Este mes',
            ),
          ),
        ),
      );

      expect(find.text('Este mes'), findsOneWidget);
    });

    testWidgets('no muestra subtítulo cuando es null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(
              label: 'Egresos',
              value: '\$200.000',
              color: AppTheme.errorColor,
              icon: Icons.money_off,
            ),
          ),
        ),
      );

      expect(find.text('Este mes'), findsNothing);
    });

    testWidgets('aplica estilo large cuando isLarge=true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(
              label: 'Balance',
              value: '\$1.300.000',
              color: AppTheme.primaryColor,
              icon: Icons.account_balance_wallet,
              isLarge: true,
            ),
          ),
        ),
      );

      expect(find.text('Balance'), findsOneWidget);
      expect(find.text('\$1.300.000'), findsOneWidget);
    });

    testWidgets('aplica fondo sólido cuando useSolidBackground=true', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(
              label: 'Ventas',
              value: '\$5M',
              color: AppTheme.successColor,
              icon: Icons.shopping_cart,
              useSolidBackground: true,
            ),
          ),
        ),
      );

      expect(find.text('Ventas'), findsOneWidget);
      expect(find.text('\$5M'), findsOneWidget);
      // Solo 1 icono cuando useSolidBackground=true (sin icono de fondo)
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });
  });

  group('320dp screen (overflow protection)', () {
    testWidgets('long monetary value scales down without overflow at 320dp', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 600));
      addTearDown(() async {
        await tester.binding.setSurfaceSize(const Size(800, 600));
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(
              label: 'Total Ingresos',
              value: '\$1.234.567.890',
              color: AppTheme.successColor,
              icon: Icons.trending_up,
            ),
          ),
        ),
      );

      await tester.pump();

      // No overflow exception should occur
      expect(tester.takeException(), isNull);

      // Label and value should still be visible
      expect(find.text('Total Ingresos'), findsOneWidget);
      expect(find.text('\$1.234.567.890'), findsOneWidget);
    });

    testWidgets('long label wraps properly at 320dp', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 600));
      addTearDown(() async {
        await tester.binding.setSurfaceSize(const Size(800, 600));
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(
              label: 'Promedio de Ventas Mensuales con Impuestos',
              value: '\$500.000',
              color: AppTheme.primaryColor,
              icon: Icons.analytics,
            ),
          ),
        ),
      );

      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(
        find.text('Promedio de Ventas Mensuales con Impuestos'),
        findsOneWidget,
      );
    });
  });
}
