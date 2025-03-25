import 'package:hive_flutter/hive_flutter.dart';
import '../models/tasting.dart';
import '../models/wine.dart';

class StorageService {
  static const String _tastingBoxName = 'tastings';
  static Box<Tasting>? _tastingBox;

  /// Initialize Hive and open the box
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(TastingAdapter());
    Hive.registerAdapter(WineAdapter());
    
    // Open the box
    _tastingBox = await Hive.openBox<Tasting>(_tastingBoxName);
  }

  /// Save a tasting
  static Future<void> saveTasting(Tasting tasting) async {
    if (_tastingBox == null) {
      throw Exception('Storage not initialized');
    }

    // Use the tasting name as the key
    await _tastingBox!.put(tasting.name, tasting);
  }

  /// Get all tastings
  static List<Tasting> getAllTastings() {
    if (_tastingBox == null) {
      throw Exception('Storage not initialized');
    }

    return _tastingBox!.values.toList();
  }

  /// Get a specific tasting by name
  static Tasting? getTasting(String name) {
    if (_tastingBox == null) {
      throw Exception('Storage not initialized');
    }

    return _tastingBox!.get(name);
  }

  /// Delete a tasting
  static Future<void> deleteTasting(String name) async {
    if (_tastingBox == null) {
      throw Exception('Storage not initialized');
    }

    await _tastingBox!.delete(name);
  }
}
