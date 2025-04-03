import 'package:wine_taster/services/storage_service.dart';
import 'package:wine_taster/models/tasting.dart';

class MockStorageService implements StorageService {
  final Map<int, Tasting> _mockStorage = {};

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
}
