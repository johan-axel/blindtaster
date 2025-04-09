import 'dart:async';
import 'package:hive/hive.dart';
import 'package:wine_taster/services/storage_service.dart';
import 'package:wine_taster/models/tasting.dart';
import 'package:wine_taster/models/settings.dart';

class MockStorageService implements StorageService {
  final Map<int, Tasting> _mockStorage = {};
  final Settings _settings = Settings();
  final _settingsController = StreamController<Settings>.broadcast();

  @override
  Future<void> init() async {
    print('[MockStorage] Initialized');
  }

  @override
  Future<void> saveTasting(Tasting tasting) async {
    print('[MockStorage] Saving tasting with ID: ${tasting.id}');
    _mockStorage[tasting.id] = tasting;
    print('[MockStorage] Tasting saved successfully');
  }

  @override
  List<Tasting> getAllTastings() {
    return _mockStorage.values.toList();
  }

  @override
  Tasting? getTasting(int id) {
    return _mockStorage[id];
  }

  @override
  Future<void> deleteTasting(int id) async {
    print('[MockStorage] Deleting tasting with ID: $id');
    _mockStorage.remove(id);
    print('[MockStorage] Tasting deleted successfully');
  }

  @override
  Future<void> dispose() async {
    await _settingsController.close();
    // Close any in-memory boxes if they were created during testing
    if (Hive.isBoxOpen('settings')) {
      await Hive.box('settings').close();
    }
    if (Hive.isBoxOpen('tastings')) {
      await Hive.box('tastings').close();
    }
  }


  @override
  Settings getSettings() {
    return _settings;
  }

  @override
  Future<void> saveSettings(Settings settings) async {
    _settings
      ..minRating = settings.minRating
      ..maxRating = settings.maxRating
      ..ratingSteps = settings.ratingSteps
      ..showWineType = settings.showWineType
      ..showGrapes = settings.showGrapes
      ..showCountry = settings.showCountry
      ..showRegion = settings.showRegion
      ..showProducer = settings.showProducer
      ..showYear = settings.showYear
      ..showColor = settings.showColor
      ..showSmell = settings.showSmell
      ..showSmellQuality = settings.showSmellQuality
      ..showTaste = settings.showTaste
      ..showTasteQuality = settings.showTasteQuality
      ..showAftertaste = settings.showAftertaste
      ..showAftertasteQuality = settings.showAftertasteQuality
      ..showCharacteristics = settings.showCharacteristics
      ..showRating = settings.showRating;
    _settingsController.add(_settings);
  }

  @override
  Stream<Settings> get settingsStream => _settingsController.stream;
}
