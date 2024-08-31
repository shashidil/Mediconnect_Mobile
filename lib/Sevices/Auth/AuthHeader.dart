import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthHeader {
  static final _storage = FlutterSecureStorage();

  static const _accessTokenKey = 'accessToken';

  // Store the access token securely
  static Future<void> storeAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  // Get the access token from secure storage
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // Generate an authentication header with the stored token
  static Future<Map<String, String>> getAuthHeader() async {
    final token = await getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }

    return {
      'Authorization': 'Bearer $token',
    };
  }

  // Clear the stored token (e.g., for logout)
  static Future<void> clearAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
  }
}
