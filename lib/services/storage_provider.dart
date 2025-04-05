import 'storage_service.dart';
import '../models/tasting.dart';

class StorageProvider {
  static StorageService? _instance;
  static Tasting? _selectedTasting; // Added for testing purposes

  static void setInstance(StorageService instance) {
    _instance = instance;
  }

  static StorageService get instance {
    return _instance ?? HiveStorageService();
  }
  
  // Getter and setter for selectedTasting (used in tests)
  static Tasting? get selectedTasting => _selectedTasting;
  
  static set selectedTasting(Tasting? tasting) {
    _selectedTasting = tasting;
  }
}
