import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSession {
  static const _storage = FlutterSecureStorage();

  static const _userIdKey = 'userId';
  static const _userNameKey = 'userName';
  static const _userEmailKey = 'userEmail';

  // Store the user ID securely
  static Future<void> storeUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  // Get the user ID from secure storage
  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  // Clear the stored user ID (e.g., for logout)
  static Future<void> clearUserId() async {
    await _storage.delete(key: _userIdKey);
  }

  // Store the user name securely
  static Future<void> storeUserName(String userName) async {
    await _storage.write(key: _userNameKey, value: userName);
  }

  // Get the user name from secure storage
  static Future<String?> getUserName() async {
    return await _storage.read(key: _userNameKey);
  }

  // Clear the stored user name (e.g., for logout)
  static Future<void> clearUserName() async {
    await _storage.delete(key: _userNameKey);
  }

  // Store the user email securely
  static Future<void> storeUserEmail(String userEmail) async {
    await _storage.write(key: _userEmailKey, value: userEmail);
  }

  // Get the user email from secure storage
  static Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  // Clear the stored user email (e.g., for logout)
  static Future<void> clearUserEmail() async {
    await _storage.delete(key: _userEmailKey);
  }

  // Clear all stored user information (e.g., for logout)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
