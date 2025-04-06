import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/tasting.dart';
import '../models/wine.dart';
import '../models/settings.dart';

abstract class StorageService {
  /// Dispose of any resources
  Future<void> dispose();
  Stream<Settings> get settingsStream;
  /// Initialize storage
  Future<void> init();

  /// Save a tasting
  Future<void> saveTasting(Tasting tasting);

  /// Get all tastings
  List<Tasting> getAllTastings();

  /// Get a specific tasting by id
  Tasting? getTasting(int id);

  /// Delete a tasting by id
  Future<void> deleteTasting(int id);

  /// Get user settings
  Settings getSettings();

  /// Save user settings
  Future<void> saveSettings(Settings settings);
}

class HiveStorageService implements StorageService {
  static const String _tastingBoxName = 'tastings';
  static Box<Tasting>? _tastingBox;
  static Box<Settings>? _settingsBox;
  static Settings? _settings;
  static final _settingsController = StreamController<Settings>.broadcast();

  @override
  Stream<Settings> get settingsStream => _settingsController.stream;

  @override
  Future<void> init() async {
    print('[StorageService] Initializing');
    await Hive.initFlutter();
    print('[StorageService] Hive initialized');
    
    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      print('[StorageService] Registering TastingAdapter');
      Hive.registerAdapter(TastingAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      print('[StorageService] Registering WineAdapter');
      Hive.registerAdapter(WineAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      print('[StorageService] Registering SettingsAdapter');
      Hive.registerAdapter(SettingsAdapter());
    }
    
    // Open the boxes
    print('[StorageService] Opening tasting box');
    _tastingBox = await Hive.openBox<Tasting>(_tastingBoxName);
    print('[StorageService] Opening settings box');
    _settingsBox = await Hive.openBox<Settings>('settings');
    _settings = _settingsBox?.get('user_settings') ?? Settings();
    print('[StorageService] Initialization complete');
  }

  @override
  Future<void> saveTasting(Tasting tasting) async {
    print('[StorageService] Attempting to save tasting with ID: ${tasting.id}');
    if (_tastingBox == null) {
      print('[StorageService] Error: Storage not initialized');
      throw Exception('Storage not initialized');
    }

    // Use the tasting id as the key
    await _tastingBox!.put(tasting.id, tasting);
    print('[StorageService] Tasting saved successfully');
  }

  @override
  List<Tasting> getAllTastings() {
    if (_tastingBox == null) {
      throw Exception('Storage not initialized');
    }

    return _tastingBox!.values.toList();
  }

  @override
  Settings getSettings() {
    if (_settingsBox == null) {
      throw Exception('Storage not initialized');
    }

    final settings = _settingsBox!.get('user_settings') ?? Settings();
    _settingsController.add(settings);
    return settings;
  }

  @override
  Future<void> saveSettings(Settings settings) async {
    if (_settingsBox == null) {
      throw Exception('Storage not initialized');
    }

    await _settingsBox!.put('user_settings', settings);
    _settingsController.add(settings);
  }

  @override
  Tasting? getTasting(int id) {
    if (_tastingBox == null) {
      throw Exception('Storage not initialized');
    }

    return _tastingBox!.get(id);
  }

  @override
  Future<void> dispose() async {
    await _settingsController.close();
  }

  @override
  Future<void> deleteTasting(int id) async {
    if (_tastingBox == null) {
      throw Exception('Storage not initialized');
    }

    await _tastingBox!.delete(id);
  }
}
