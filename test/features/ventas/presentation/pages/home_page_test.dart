import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:InkTrack/features/ventas/presentation/pages/home_page.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late TestAppProviders providers;

  setUp(() {
    providers = TestAppProviders();
  });

  group('HomePage export buttons', () {
    testWidgets(
      'BUG-003: PDF and Excel buttons are present, SQLite button is absent',
      (tester) async {
        await pumpPage(tester, const HomePage(), providers: providers);

        // Wait for widgets to render
        await tester.pumpAndSettle();

        // PDF button should still be present
        expect(find.text('PDF'), findsOneWidget,
            reason: 'PDF export button must remain');

        // Excel button should still be present
        expect(find.text('Excel'), findsOneWidget,
            reason: 'Excel export button must remain');

        // SQLite button must be removed (data leak fix)
        expect(find.text('SQLite'), findsNothing,
            reason:
                'SQLite export button must NOT be present (data leak fix)');
      },
    );

    testWidgets(
      'BUG-003: SQLite storage icon is absent from the export row',
      (tester) async {
        await pumpPage(tester, const HomePage(), providers: providers);
        await tester.pumpAndSettle();

        // The SQLite button used Icons.storage_rounded — should be gone
        // (PDF uses Icons.picture_as_pdf_rounded, Excel uses Icons.table_chart_rounded,
        //  so finding a lone storage icon would indicate the leak persisted)
        final storageIcons = find.byIcon(Icons.storage_rounded);
        expect(storageIcons, findsNothing,
            reason: 'Storage icon (SQLite leak indicator) must be absent');
      },
    );
  });
}
