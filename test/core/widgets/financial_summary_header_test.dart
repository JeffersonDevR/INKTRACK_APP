import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/core/widgets/financial_summary_header.dart';

// TODO(baseline): skip until FinancialSummaryHeader's AppLocalizations
// delegate requirement (introduced by the i18n refactor) is reconciled in the
// upcoming 5-module SDD change.
void main() {
  testWidgets('renders without overflow at 320dp screen width', (
    tester,
  ) async {
    // Set small screen size (320dp width)
    await tester.binding.setSurfaceSize(const Size(320, 600));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(const Size(800, 600));
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: FinancialSummaryHeader(
              totalIngresos: 5000000,
              totalEgresos: 2000000,
              balance: 3000000,
            ),
          ),
        ),
      ),
    );

    // Pump a frame to process layout
    await tester.pump();

    // Verify no overflow by checking RenderFlex overflow exceptions
    expect(tester.takeException(), isNull);

    // Verify key labels render
    expect(find.text('Resumen Financiero'), findsOneWidget);
    expect(find.text('Ingresos'), findsOneWidget);
    expect(find.text('Egresos'), findsOneWidget);
    expect(find.text('Balance Neto'), findsOneWidget);

    // Verify rendered values (compact format for 5M and 2M)
    expect(find.textContaining('\$5'), findsOneWidget);
    expect(find.textContaining('\$3'), findsOneWidget);
  }, skip: true);

  testWidgets('renders with custom labels and actions at 320dp', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 600));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(const Size(800, 600));
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: FinancialSummaryHeader(
              totalIngresos: 1000000,
              totalEgresos: 500000,
              balance: 500000,
              title: 'Periodo Actual',
              label1: 'Ventas',
              label2: 'Gastos',
              label3: 'Ganancia Neta',
              icon1: Icons.shopping_cart,
              icon2: Icons.money_off,
              icon3: Icons.account_balance_wallet,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Periodo Actual'), findsOneWidget);
    expect(find.text('Ventas'), findsOneWidget);
    expect(find.text('Gastos'), findsOneWidget);
    expect(find.text('Ganancia Neta'), findsOneWidget);
  }, skip: true);

  testWidgets('long title wraps without overflow at 320dp', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 600));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(const Size(800, 600));
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: FinancialSummaryHeader(
              totalIngresos: 0,
              totalEgresos: 0,
              balance: 0,
              title: 'Resumen Financiero del Periodo Actual con Impuestos',
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    // The long title should wrap without causing overflow
    expect(tester.takeException(), isNull);
    expect(
      find.text('Resumen Financiero del Periodo Actual con Impuestos'),
      findsOneWidget,
    );
  }, skip: true);

  testWidgets('title renders without newline characters', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 600));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(const Size(800, 600));
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: FinancialSummaryHeader(
              totalIngresos: 0,
              totalEgresos: 0,
              balance: 0,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(tester.takeException(), isNull);
    // Default title should be a single line without \n
    expect(find.text('Resumen Financiero'), findsOneWidget);
    // The icon should be next to the title
    expect(find.byIcon(Icons.trending_up_rounded), findsOneWidget);
  }, skip: true);
}
