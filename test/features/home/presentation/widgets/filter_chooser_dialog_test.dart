// test/features/home/presentation/widgets/filter_chooser_dialog_test.dart
// Chain 6 — feat/m4-reportes-filtros-preview

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/core/services/reports/report_filters.dart';
import 'package:InkTrack/features/home/presentation/widgets/filter_chooser_dialog.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('FilterChooserDialog', () {
    testWidgets('surfaces all Spanish filter labels and returns ReportFilters', (tester) async {
      ReportFilters? result;

      await pumpPage(tester,
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                result = await showDialog<ReportFilters>(
                  context: context,
                  builder: (context) => const FilterChooserDialog(),
                );
              },
              child: const Text('Show Dialog'),
            );
          },
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Filtros de Reporte'), findsOneWidget);
      expect(find.text('Solo deudores'), findsOneWidget);
      expect(find.text('Abonos del mes'), findsOneWidget);
      expect(find.text('Más vendidos'), findsOneWidget);
      expect(find.text('Inventario crítico valorizado'), findsOneWidget);
      expect(find.text('Incluir costo'), findsOneWidget);

      // Toggle 'Solo deudores'
      await tester.tap(find.text('Solo deudores'));
      await tester.pumpAndSettle();

      // Tap 'Aplicar' / 'Apply' equivalent action (we'll just use a 'Generar' or 'Aplicar' button)
      await tester.tap(find.text('Generar Reporte'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.soloDeudores, isTrue);
      expect(result!.abonosDelMes, isFalse);
    });
  });
}
