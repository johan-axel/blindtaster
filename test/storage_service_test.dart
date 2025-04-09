import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:wine_taster/models/settings.dart';
import 'package:wine_taster/models/tasting.dart';
import 'package:wine_taster/models/wine.dart';
import 'package:wine_taster/services/storage_provider.dart';
import 'package:wine_taster/services/storage_service.dart';

class TestPathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async => './test';
}

void main() {
  PathProviderPlatform.instance = TestPathProviderPlatform();
  late HiveStorageService storageService;
  late Box<Settings> settingsBox;
  late Box<Tasting> tastingBox;

  setUp(() async {
    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(WineAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(TastingAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(SettingsAdapter());
    
    // Open test boxes in memory
    settingsBox = await Hive.openBox<Settings>('settings_test', bytes: Uint8List(0));
    tastingBox = await Hive.openBox<Tasting>('tastings_test', bytes: Uint8List(0));
    
    // Create storage service instance
    storageService = HiveStorageService();
    await storageService.init();
  });

  tearDown(() async {
    await settingsBox.clear();
    await tastingBox.clear();
    await settingsBox.close();
    await tastingBox.close();
  });

  group('Rating Range Changes', () {
    test('wine ratings stay within new min-max range after settings change', () async {
      // Create initial settings with range 1-5
      final initialSettings = Settings(minRating: 1.0, maxRating: 5.0);
      await storageService.saveSettings(initialSettings);

      // Create a tasting with wines having various ratings
      final tasting = Tasting(
        id: 1,
        name: 'Test Tasting',
        date: DateTime.now().toIso8601String(),
        details: 'Test tasting details',
        isRevealed: true,
        wines: [
          Wine(
            wineNumber: 1,
            name: 'Wine 1',
            rating: 1.0, // min
            smellQuality: 2.5, // middle
            tasteQuality: 5.0, // max
            aftertasteQuality: 3.75, // 75% of range
            acidity: 1.5,
            body: 4.0,
            fruit: 2.0,
            sweetness: 3.0,
            tannins: 4.5,
          ),
        ],
      );
      await storageService.saveTasting(tasting);

      // Change settings to range 10-20
      final newSettings = Settings(minRating: 10.0, maxRating: 20.0);
      await storageService.saveSettings(newSettings);

      // Get updated tasting
      final updatedTasting = storageService.getTasting(1);
      final updatedWine = updatedTasting!.wines.first;

      // Check that all ratings are within new range
      expect(updatedWine.rating, greaterThanOrEqualTo(10.0));
      expect(updatedWine.rating, lessThanOrEqualTo(20.0));
      expect(updatedWine.smellQuality, greaterThanOrEqualTo(10.0));
      expect(updatedWine.smellQuality, lessThanOrEqualTo(20.0));
      expect(updatedWine.tasteQuality, greaterThanOrEqualTo(10.0));
      expect(updatedWine.tasteQuality, lessThanOrEqualTo(20.0));
      expect(updatedWine.aftertasteQuality, greaterThanOrEqualTo(10.0));
      expect(updatedWine.aftertasteQuality, lessThanOrEqualTo(20.0));

      // Check that relative positions are maintained
      expect(updatedWine.rating, equals(10.0)); // Was at min, should still be at min
      expect(updatedWine.tasteQuality, equals(20.0)); // Was at max, should still be at max
      expect(updatedWine.smellQuality, closeTo(13.75, 0.1)); // Was at 2.5 (37.5% of range)
      expect(updatedWine.aftertasteQuality, closeTo(16.875, 0.1)); // Was at 3.75 (68.75% of range)
    });
  });
}
