import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static final SecureStorageHelper _instance = SecureStorageHelper._internal();

  SecureStorageHelper._internal();

  factory SecureStorageHelper() {
    return _instance;
  }

  Future<void> writeValue(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> readValue(String key) async {
    return await _storage.read(key: key);
  }

  Future<Map<String, String>> readAllValues() async {
    return await _storage.readAll();
  }

  Future<void> deleteValue(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAllValues() async {
    await _storage.deleteAll();
  }
}
