import 'package:flutter_complete_project/Core/Strings/strings.dart';
import 'package:flutter_complete_project/Core/utils/secure_storage_helper.dart';

abstract class SecureToken {
  static SecureStorageHelper secureStorageHelper = SecureStorageHelper();
  static addToken(String token) async {
    await secureStorageHelper.writeValue(StringManager.kToken, token);
  }

  static Future<String?> getToken() async {
    return await secureStorageHelper.readValue(StringManager.kToken);
  }

  static deleteToken() async {
    await secureStorageHelper.deleteValue(StringManager.kToken);
  }
}
