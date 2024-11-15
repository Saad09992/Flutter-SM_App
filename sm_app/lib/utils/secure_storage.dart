import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> writeStorageData(String key, String value) async {
    await secureStorage.write(key: key, value: value);
    print('Key: $key & value: $value');
  }

  Future<String?> readStorageData(String key) async {
    String? value = await secureStorage.read(key: key);
    print('Data read from storage key: $key & value: $value');
    return value;
  }

  Future<void> removeStorageData(String key) async {
    await secureStorage.delete(key: key);
    print("$key deleted successfully");
  }
}
