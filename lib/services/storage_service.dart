import 'package:hive_flutter/hive_flutter.dart';
import '../models/tasting_session.dart';
import '../models/wine.dart';

class StorageService {
  static const String _tastingBoxName = 'tasting_sessions';
  static Box<TastingSession>? _tastingBox;

  /// Initialize Hive and open the box
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(TastingSessionAdapter());
    Hive.registerAdapter(WineAdapter());
    
    // Open the box
    _tastingBox = await Hive.openBox<TastingSession>(_tastingBoxName);
  }

  /// Save a tasting session
  static Future<void> saveTastingSession(TastingSession session) async {
    if (_tastingBox == null) {
      throw Exception('Storage not initialized');
    }

    // Use the session name as the key
    await _tastingBox!.put(session.name, session);
  }

  /// Get all tasting sessions
  static List<TastingSession> getAllTastingSessions() {
    if (_tastingBox == null) {
      throw Exception('Storage not initialized');
    }

    return _tastingBox!.values.toList();
  }

  /// Get a specific tasting session by name
  static TastingSession? getTastingSession(String name) {
    if (_tastingBox == null) {
      throw Exception('Storage not initialized');
    }

    return _tastingBox!.get(name);
  }

  /// Delete a tasting session
  static Future<void> deleteTastingSession(String name) async {
    if (_tastingBox == null) {
      throw Exception('Storage not initialized');
    }

    await _tastingBox!.delete(name);
  }
}
