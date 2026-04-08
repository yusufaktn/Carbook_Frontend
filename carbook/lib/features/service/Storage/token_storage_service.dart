import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../model/Auth/auth_token.dart';

/// Secure storage service for tokens
class TokenStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenDataKey = 'token_data';

  /// Save authentication tokens
  Future<void> saveTokens(AuthToken authToken) async {
    await _storage.write(key: _accessTokenKey, value: authToken.accessToken);
    await _storage.write(key: _refreshTokenKey, value: authToken.refreshToken);
    await _storage.write(key: _tokenDataKey, value: json.encode(authToken.toJson()));
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Get full auth token data
  Future<AuthToken?> getAuthToken() async {
    final tokenData = await _storage.read(key: _tokenDataKey);
    if (tokenData == null) return null;

    try {
      return AuthToken.fromJson(json.decode(tokenData));
    } catch (e) {
      return null;
    }
  }

  /// Check if user is authenticated (has valid token)
  Future<bool> isAuthenticated() async {
    final authToken = await getAuthToken();
    if (authToken == null) return false;
    
    // Check if token is expired
    return !authToken.isExpired;
  }

  /// Clear all tokens (logout)
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _tokenDataKey);
  }

  /// Clear all storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
