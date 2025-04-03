import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wine_taster/screens/tasting_summary.dart';
import 'package:wine_taster/screens/wine_deck_page.dart';
import 'package:wine_taster/models/tasting.dart';
import 'package:wine_taster/models/wine.dart';
import 'package:wine_taster/services/storage_provider.dart';
import 'mocks/mock_storage_service.dart';

void main() {
  print('[Test] Starting test suite');
  
  setUp(() async {
    print('[Test] Setting up test environment');
    try {
      final mockStorage = MockStorageService();
      await mockStorage.init();
      StorageProvider.setInstance(mockStorage);
      print('[Test] Mock storage service initialized');
    } catch (e) {
      print('[Test] Error during setup: $e');
      rethrow;
    }
  });

  tearDown(() {
    print('[Test] Test completed');
  });
  group('TastingSummary Widget Tests', () {
    testWidgets('TastingSummary form validation works', (WidgetTester tester) async {
      print('[Test] Starting TastingSummary form validation test');
      print('[Test] Pumping TastingSummary widget');
      // Wrap in try-catch for better error reporting
      try {
        await tester.pumpWidget(MaterialApp(
          home: const TastingSummary(),
        ));
      } catch (e) {
        print('[Test] Error pumping widget: $e');
        rethrow;
      }
      print('[Test] TastingSummary widget pumped');

      // Try to submit empty form
      print('[Test] Attempting to tap submit button');
      await tester.tap(find.byKey(const Key('goToWines')));
      print('[Test] Submit button tapped, waiting for pump and settle');
      await tester.pumpAndSettle();
      print('[Test] Pump and settle completed');

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
      print('[Test] Filling in form fields');
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
      print('[Test] Form fields filled');

      // Submit form with timeout and error handling
      print('[Test] Attempting to submit form');
      try {
        await tester.tap(find.byKey(const Key('goToWines')));
        print('[Test] Submit button tapped');
        
        // Add a timeout to pumpAndSettle to prevent infinite loops
        await tester.pumpAndSettle(const Duration(seconds: 2));
        print('[Test] Pump and settle completed');
      } catch (e) {
        print('[Test] Error during form submission: $e');
        rethrow;
      }

      // Verify we're on the WineDeckPage
      expect(find.byType(WineDeckPage), findsOneWidget);
      expect(find.text('Add your first wine tasting note!'), findsOneWidget); // Empty state message
    });

    testWidgets('TastingSummary loads initial session data', (WidgetTester tester) async {
      final initialTasting = Tasting(
        id: 1,
        isRevealed: false,
        name: 'Initial Test',
        date: '2025-03-25',
        details: 'Initial details',
        wines: [],
      );

      await tester.pumpWidget(MaterialApp(
        home: TastingSummary(initialTasting: initialTasting),
      ));

      // Verify initial values are loaded
      expect(find.text('Initial Test'), findsOneWidget);
      expect(find.text('2025-03-25'), findsOneWidget);
      expect(find.text('Initial details'), findsOneWidget);
    });
  });

  group('WineDeckPage Widget Tests', () {
    testWidgets('WineDeckPage displays empty state', (WidgetTester tester) async {
      final tasting = Tasting(
        id: 1,
        isRevealed: false,
        name: 'Empty Session',
        date: '2025-03-25',
        details: 'No wines yet',
        wines: [],
      );

      await tester.pumpWidget(MaterialApp(
        home: WineDeckPage(tasting: tasting),
      ));

      // Verify empty state message
      expect(find.text('Add your first wine tasting note!'), findsOneWidget);
      //TODO Does not test that card deck is empty
      // instead test that card deck is empty by checking that navigation buttons are "new wine" and "return to summary"
    });

    testWidgets('WineDeckPage add wine works', (WidgetTester tester) async {
      final tasting = Tasting(
        id: 1,
        isRevealed: false,
        name: 'Test Session',
        date: '2025-03-25',
        details: 'Test details',
        wines: [],
      );

      await tester.pumpWidget(MaterialApp(
        home: WineDeckPage(tasting: tasting),
      ));

      // Verify empty state
      expect(find.text('Add your first wine tasting note!'), findsOneWidget);
      expect(tasting.wines.length, equals(0));

      // Add a wine
      await tester.tap(find.widgetWithIcon(IconButton, Icons.wine_bar));
      await tester.pumpAndSettle();

      // Verify wine was added
      expect(tasting.wines.length, equals(1));
      expect(find.text('Wine 1 of 1'), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget); // Edit button shown for first wine
      expect(find.byIcon(Icons.arrow_back), findsNothing); // No back button on first wine
      expect(find.byIcon(Icons.wine_bar), findsOneWidget); // Add wine button shown

      // Add another wine
      await tester.tap(find.widgetWithIcon(IconButton, Icons.wine_bar));
      await tester.pumpAndSettle();

      // Verify second wine was added
      expect(tasting.wines.length, equals(2));
      
      // Wait for a frame to ensure page indicator updates
      await tester.pump();
      await tester.pumpAndSettle();
      
      // Now verify the page indicator and navigation buttons
      expect(find.text('Wine 2 of 2'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget); // Back button shown for second wine
      expect(find.byIcon(Icons.wine_bar), findsOneWidget); // Add wine button shown
    });

    testWidgets('WineDeckPage navigation works', (WidgetTester tester) async {
      final tasting = Tasting(
        id: 1,
        isRevealed: false,
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
        home: WineDeckPage(tasting: tasting),
      ));

      // Verify initial state
      expect(find.text('Wine 1 of 2'), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget); // Edit button shown for first wine
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget); // Forward button shown

      // Navigate to next wine
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      // Verify navigation
      expect(find.text('Wine 2 of 2'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget); // Back button shown
      expect(find.byIcon(Icons.arrow_forward), findsNothing); // No forward button on last wine

      // Navigate back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify navigation back
      expect(find.text('Wine 1 of 2'), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget); // Edit button shown for first wine
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget); // Forward button shown
    });
  });
}
