import 'storage_service.dart';

class StorageProvider {
  static StorageService? _instance;

  static void setInstance(StorageService instance) {
    _instance = instance;
  }

  static StorageService get instance {
    return _instance ?? HiveStorageService();
  }
}
