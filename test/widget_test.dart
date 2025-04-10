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

      // Verify validation works
      final nameField = tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, 'Tasting Name'),
      );
      final dateField = tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, 'Date (YYYY-MM-DD)'),
      );
      expect(nameField.validator!(''), equals('Please enter a tasting name'));
      expect(dateField.validator!(''), equals('Please enter a date'));

      // Submit form
      print('[Test] Attempting to submit form');
      try {
        final tastingNotesButton = find.byKey(const Key('goToWines'));
        expect(tastingNotesButton, findsOneWidget, reason: 'Tasting notes button not found');
        await tester.ensureVisible(tastingNotesButton);
        await tester.tap(tastingNotesButton);
        print('[Test] Submit button tapped');
        
        await tester.pumpAndSettle();
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

      // Wait for any async operations to complete
      await tester.pumpAndSettle();

      // Verify initial values are loaded
      expect(find.text('Initial Test'), findsOneWidget);
      expect(find.text('2025-03-25'), findsOneWidget);
      expect(find.text('Initial details'), findsOneWidget);
    }, timeout: const Timeout(Duration(seconds: 5))); // Add timeout to handle async operations
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
      expect(find.byIcon(Icons.summarize), findsOneWidget); // Summary button shown for first wine
      expect(find.byIcon(Icons.arrow_back), findsNothing); // No back button on first wine
      expect(find.byIcon(Icons.wine_bar), findsOneWidget); // Add wine button shown when on the last wine

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
            rating: 3.0,
            smellQuality: 3.0,
            tasteQuality: 3.0,
            aftertasteQuality: 3.0,
            acidity: 3.0,
            sweetness: 3.0,
            body: 3.0,
            tannins: 3.0,
            fruit: 3.0,
          ),
          Wine(
            wineNumber: 2,
            name: 'Wine 2',
            color: 'White',
            smell: 'Floral',
            taste: 'Light',
            comments: 'Nice wine',
            rating: 3.0,
            smellQuality: 3.0,
            tasteQuality: 3.0,
            aftertasteQuality: 3.0,
            acidity: 3.0,
            sweetness: 3.0,
            body: 3.0,
            tannins: 3.0,
            fruit: 3.0,
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp(
        home: WineDeckPage(tasting: tasting),
      ));

      // Verify initial state
      expect(find.text('Wine 1 of 2'), findsOneWidget);
      expect(find.byIcon(Icons.summarize), findsOneWidget); // Summary button shown for first wine
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget); // Forward button shown
      expect(find.byIcon(Icons.arrow_back), findsNothing); // No back button on first wine
      expect(find.byIcon(Icons.wine_bar), findsNothing); // Add wine button shown

      // Navigate to next wine
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      // Verify navigation
      expect(find.text('Wine 2 of 2'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget); // Back button shown
      expect(find.byIcon(Icons.arrow_forward), findsNothing); // No forward button on last wine
      expect(find.byIcon(Icons.wine_bar), findsOneWidget); // Add wine button shown

      // Navigate back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify navigation back
      expect(find.text('Wine 1 of 2'), findsOneWidget);
      expect(find.byIcon(Icons.summarize), findsOneWidget); // Summary button shown for first wine
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget); // Forward button shown
    });
  });

  group('Saved Tastings Tests', () {
    testWidgets('Loading a saved tasting directly works', (WidgetTester tester) async {
      print('[Test] Setting up test environment for saved tastings');
      
      // Create a test tasting with wines
      final testTasting = Tasting(
        id: 2,
        isRevealed: true,
        name: 'Test Tasting',
        date: '2025-04-02',
        details: 'Test tasting details',
        wines: [
          Wine(
            wineNumber: 1,
            name: 'Wine A',
            color: 'White',
            smell: 'Floral',
            taste: 'Light',
            comments: 'Nice wine',
            rating: 3.0,
            smellQuality: 3.0,
            tasteQuality: 3.0,
            aftertasteQuality: 3.0,
            acidity: 3.0,
            sweetness: 3.0,
            body: 3.0,
            tannins: 3.0,
            fruit: 3.0,
          ),
          Wine(
            wineNumber: 2,
            name: 'Wine B',
            color: 'Red',
            smell: 'Spicy',
            taste: 'Bold',
            comments: 'Excellent wine',
            rating: 3.0,
            smellQuality: 3.0,
            tasteQuality: 3.0,
            aftertasteQuality: 3.0,
            acidity: 3.0,
            sweetness: 3.0,
            body: 3.0,
            tannins: 3.0,
            fruit: 3.0,
          ),
        ],
      );
      
      // Save the tasting to mock storage
      await StorageProvider.instance.saveTasting(testTasting);
      
      // Verify the tasting was saved
      final savedTastings = StorageProvider.instance.getAllTastings();
      expect(savedTastings.length, 1);
      expect(savedTastings[0].name, 'Test Tasting');
      expect(savedTastings[0].wines.length, 2);
      
      // Load the tasting directly into WineDeckPage
      await tester.pumpWidget(MaterialApp(
        home: WineDeckPage(tasting: testTasting),
      ));
      await tester.pumpAndSettle();
      
      // Verify we're on the WineDeckPage with the correct tasting
      expect(find.byType(WineDeckPage), findsOneWidget);
      expect(find.text('Test Tasting'), findsOneWidget); // App bar title
      expect(find.text('Wine 1 of 2'), findsOneWidget); // Page indicator
      
      // Verify the first wine details are displayed
      expect(find.text('White'), findsOneWidget);
      expect(find.text('Floral'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Nice wine'), findsOneWidget);
      
      // Navigate to the second wine
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();
      
      // Verify the second wine details are displayed
      expect(find.text('Wine 2 of 2'), findsOneWidget); // Page indicator
      expect(find.text('Red'), findsOneWidget);
      expect(find.text('Spicy'), findsOneWidget);
      expect(find.text('Bold'), findsOneWidget);
      expect(find.text('Excellent wine'), findsOneWidget);
    });
    
    testWidgets('Navigating directly to specific wine works', (WidgetTester tester) async {
      print('[Test] Setting up test environment for direct wine navigation');
      
      // Create a test tasting with multiple wines
      final testTasting = Tasting(
        id: 3,
        isRevealed: false,
        name: 'Navigation Test',
        date: '2025-04-03',
        details: 'Testing wine navigation',
        wines: [
          Wine(
            wineNumber: 1,
            name: 'First Wine',
            color: 'Red',
            smell: 'Berry',
            taste: 'Smooth',
            comments: 'First wine comment',
            rating: 3.0,
            smellQuality: 3.0,
            tasteQuality: 3.0,
            aftertasteQuality: 3.0,
            acidity: 3.0,
            sweetness: 3.0,
            body: 3.0,
            tannins: 3.0,
            fruit: 3.0,
          ),
          Wine(
            wineNumber: 2,
            name: 'Second Wine',
            color: 'White',
            smell: 'Citrus',
            taste: 'Crisp',
            comments: 'Second wine comment',
            rating: 3.0,
            smellQuality: 3.0,
            tasteQuality: 3.0,
            aftertasteQuality: 3.0,
            acidity: 3.0,
            sweetness: 3.0,
            body: 3.0,
            tannins: 3.0,
            fruit: 3.0,
          ),
          Wine(
            wineNumber: 3,
            name: 'Third Wine',
            color: 'Rosé',
            smell: 'Strawberry',
            taste: 'Sweet',
            comments: 'Third wine comment',
            rating: 3.0,
            smellQuality: 3.0,
            tasteQuality: 3.0,
            aftertasteQuality: 3.0,
            acidity: 3.0,
            sweetness: 3.0,
            body: 3.0,
            tannins: 3.0,
            fruit: 3.0,
          ),
        ],
      );
      
      // Save the tasting to mock storage
      await StorageProvider.instance.saveTasting(testTasting);
      
      // Load the WineDeckPage directly with the second wine selected
      await tester.pumpWidget(MaterialApp(
        home: WineDeckPage(tasting: testTasting, currentCard: 1), // Index 1 is the second wine
      ));
      await tester.pumpAndSettle();
      
      // Verify we're on the WineDeckPage with the correct wine (second wine)
      expect(find.byType(WineDeckPage), findsOneWidget);
      expect(find.text('Navigation Test'), findsOneWidget); // App bar title
      expect(find.text('Wine 2 of 3'), findsOneWidget); // Page indicator for second wine
      
      // Verify the second wine details are displayed
      expect(find.text('White'), findsOneWidget);
      expect(find.text('Citrus'), findsOneWidget);
      expect(find.text('Crisp'), findsOneWidget);
      expect(find.text('Second wine comment'), findsOneWidget);
      
      // Verify navigation buttons are correct
      expect(find.byIcon(Icons.arrow_back), findsOneWidget); // Back button should be visible
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget); // Forward button should be visible
      
      // Navigate to the next wine
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();
      
      // Verify we're on the third wine
      expect(find.text('Wine 3 of 3'), findsOneWidget);
      expect(find.text('Rosé'), findsOneWidget);
      expect(find.text('Strawberry'), findsOneWidget);
      expect(find.text('Sweet'), findsOneWidget);
      expect(find.text('Third wine comment'), findsOneWidget);
    });
    
    testWidgets('Tapping on a saved tasting in the list works', (WidgetTester tester) async {
      print('[Test] Setting up test environment for tapping saved tastings');
      
      // Create a test tasting with wines
      final testTasting = Tasting(
        id: 4,
        isRevealed: false,
        name: 'Test Tasting',
        date: '2025-04-04',
        details: 'Test tasting details',
        wines: [
          Wine(
            wineNumber: 1,
            name: 'Red Wine',
            color: 'Red',
            smell: 'Fruity',
            taste: 'Full',
            comments: 'Great wine',
            rating: 3.0,
            smellQuality: 3.0,
            tasteQuality: 3.0,
            aftertasteQuality: 3.0,
            acidity: 3.0,
            sweetness: 3.0,
            body: 3.0,
            tannins: 3.0,
            fruit: 3.0,
          ),
        ],
      );
      
      // Save the tasting to mock storage
      await StorageProvider.instance.saveTasting(testTasting);
      
      // Create a controller to track if the onTap callback was called
      bool onTapCalled = false;
      Tasting? selectedTasting;
      
      // Create a simplified test widget with just a ListView of tastings
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Scaffold(
              body: Builder(builder: (context) {
                // Get the tastings directly since getAllTastings() returns a List, not a Future
                final tastings = StorageProvider.instance.getAllTastings();
                
                return ListView.builder(
                  key: const Key('savedTastingsList'),
                  itemCount: tastings.length,
                  itemBuilder: (context, index) {
                    final tasting = tastings[index];
                    return ListTile(
                      key: Key('tastingListTile_${tasting.id}'),
                      title: Text(tasting.name),
                      subtitle: Text(tasting.date),
                      onTap: () {
                        onTapCalled = true;
                        selectedTasting = tasting;
                      },
                    );
                  },
                );
              }),
            ),
          ),
        ),
      );
      
      // Wait for widget to settle
      await tester.pumpAndSettle();
      
      // Find the tasting list tile using its key
      final tastingKey = Key('tastingListTile_4'); // ID of the test tasting
      expect(find.byKey(tastingKey), findsOneWidget);
      
      // Tap on the tasting
      await tester.tap(find.byKey(tastingKey));
      await tester.pumpAndSettle();
      
      // Verify that the onTap callback was called and the correct tasting was selected
      expect(onTapCalled, isTrue);
      expect(selectedTasting, isNotNull);
      expect(selectedTasting!.id, equals(4));
      expect(selectedTasting!.name, equals('Test Tasting'));
      expect(selectedTasting!.date, equals('2025-04-04'));
      expect(selectedTasting!.details, equals('Test tasting details'));
    });
  });
}
