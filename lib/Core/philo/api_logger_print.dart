import 'dart:developer';

class ApiLoggerPrint {
  static void info(String message) {
    log('💡 INFO: $message');
  }

  static void success(String message) {
    log('✅ SUCCESS: $message');
  }

  static void error(String message) {
    log('❌ ERROR: $message');
  }

  static void api(String message) {
    log('🌐 API: $message');
  }
}
