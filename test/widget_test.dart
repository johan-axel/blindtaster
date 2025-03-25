import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wine_taster/screens/tasting_summary.dart';
import 'package:wine_taster/screens/wine_deck_page.dart';
import 'package:wine_taster/models/tasting_session.dart';
import 'package:wine_taster/models/wine.dart';

void main() {
  group('TastingSummary Widget Tests', () {
    testWidgets('TastingSummary form validation works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: const TastingSummary(),
      ));

      // Try to submit empty form
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify validation errors are shown
      final nameField = tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, 'Tasting Name'),
      );
      final dateField = tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, 'Date (YYYY-MM-DD)'),
      );
      expect(nameField.validator!(''), equals('Please enter a tasting name'));
      expect(dateField.validator!(''), equals('Please enter a date'));

      // Fill in the form
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Tasting Name'),
        'Test Tasting',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Date (YYYY-MM-DD)'),
        '2025-03-25',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Details'),
        'Test details',
      );

      // Submit form
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify validation errors are gone
      expect(nameField.validator!('Test Tasting'), isNull);
      expect(dateField.validator!('2025-03-25'), isNull);
    });

    testWidgets('TastingSummary loads initial session data', (WidgetTester tester) async {
      final initialSession = TastingSession(
        name: 'Initial Test',
        date: '2025-03-25',
        details: 'Initial details',
        wines: [],
      );

      await tester.pumpWidget(MaterialApp(
        home: TastingSummary(initialSession: initialSession),
      ));

      // Verify initial values are loaded
      expect(find.text('Initial Test'), findsOneWidget);
      expect(find.text('2025-03-25'), findsOneWidget);
      expect(find.text('Initial details'), findsOneWidget);
    });
  });

  group('WineDeckPage Widget Tests', () {
    testWidgets('WineDeckPage displays empty state', (WidgetTester tester) async {
      final session = TastingSession(
        name: 'Empty Session',
        date: '2025-03-25',
        details: 'No wines yet',
        wines: [],
      );

      await tester.pumpWidget(MaterialApp(
        home: WineDeckPage(session: session),
      ));

      // Verify empty state message
      expect(find.text('Add your first wine tasting note!'), findsOneWidget);
    });

    testWidgets('WineDeckPage navigation works', (WidgetTester tester) async {
      final session = TastingSession(
        name: 'Test Session',
        date: '2025-03-25',
        details: 'Test details',
        wines: [
          Wine(
            wineNumber: 1,
            name: 'Wine 1',
            color: 'Red',
            smell: 'Fruity',
            taste: 'Full',
            comments: 'Great wine',
          ),
          Wine(
            wineNumber: 2,
            name: 'Wine 2',
            color: 'White',
            smell: 'Floral',
            taste: 'Light',
            comments: 'Nice wine',
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp(
        home: WineDeckPage(session: session),
      ));

      // Verify initial state
      expect(find.text('Wine 1 of 2'), findsOneWidget);
      expect(find.text('Wine 1'), findsOneWidget);

      // Navigate to next wine
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      // Verify navigation
      expect(find.text('Wine 2 of 2'), findsOneWidget);
      expect(find.text('Wine 2'), findsOneWidget);

      // Navigate back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify navigation back
      expect(find.text('Wine 1 of 2'), findsOneWidget);
      expect(find.text('Wine 1'), findsOneWidget);
    });
  });
}
