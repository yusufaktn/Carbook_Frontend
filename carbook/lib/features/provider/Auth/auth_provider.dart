import 'package:flutter/material.dart';
import '../../model/Auth/login_request.dart';
import '../../model/Auth/register_request.dart';
import '../../model/Auth/auth_token.dart';
import '../../model/User/user_model.dart';
import '../../service/ApiService/Auth/auth_service.dart';
import '../../service/Storage/token_storage_service.dart';

/// Authentication state management provider
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final TokenStorageService _tokenStorage = TokenStorageService();

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;
  UserModel? _currentUser;
  AuthToken? _authToken;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  UserModel? get currentUser => _currentUser;
  AuthToken? get authToken => _authToken;

  /// Initialize auth state from storage
  Future<void> initializeAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isAuth = await _tokenStorage.isAuthenticated();
      if (isAuth) {
        final token = await _tokenStorage.getAuthToken();
        if (token != null && !token.isExpired) {
          _authToken = token;
          _isAuthenticated = true;
          
          // TODO: Load user data from token or API
          // For now, we'll load it when needed
        } else {
          // Token expired, clear storage
          await _tokenStorage.clearTokens();
          _isAuthenticated = false;
        }
      }
    } catch (e) {
      _error = 'Auth durumu kontrol edilirken hata oluştu: $e';
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login user
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _authService.login(request);

      if (response.success &&
          response.accessToken != null &&
          response.refreshToken != null) {
        // Save tokens
        final authToken = AuthToken(
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken!,
          expiryDate: response.expiryDate ?? DateTime.now().add(const Duration(hours: 1)),
          userId: response.userId ?? 0,
        );

        await _tokenStorage.saveTokens(authToken);
        _authToken = authToken;
        _isAuthenticated = true;

        // Set current user
        if (response.userId != null) {
          _currentUser = UserModel(
            userId: response.userId!,
            userName: response.userName ?? '',
            userLastName: response.userLastName ?? '',
            email: response.email ?? email,
          );
        }

        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = response.message ?? 'Giriş başarısız';
        _isAuthenticated = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Giriş sırasında hata oluştu: $e';
      _isAuthenticated = false;
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Register user
  Future<bool> register(RegisterRequest request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.register(request);

      if (response.success) {
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = response.message ?? 'Kayıt başarısız';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Kayıt sırasında hata oluştu: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logout user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Get refresh token before clearing
      final refreshToken = await _tokenStorage.getRefreshToken();
      
      // Call logout API if refresh token exists
      if (refreshToken != null) {
        await _authService.logout(refreshToken);
      }

      // Clear storage
      await _tokenStorage.clearTokens();
      
      // Reset state
      _isAuthenticated = false;
      _authToken = null;
      _currentUser = null;
      _error = null;
    } catch (e) {
      _error = 'Çıkış sırasında hata oluştu: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh access token
  Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        await logout();
        return false;
      }

      final response = await _authService.refreshToken(refreshToken);

      if (response.success &&
          response.accessToken != null &&
          response.refreshToken != null) {
        final authToken = AuthToken(
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken!,
          expiryDate: response.expiryDate ?? DateTime.now().add(const Duration(hours: 1)),
          userId: _authToken?.userId ?? 0,
        );

        await _tokenStorage.saveTokens(authToken);
        _authToken = authToken;
        return true;
      } else {
        await logout();
        return false;
      }
    } catch (e) {
      await logout();
      return false;
    }
  }

  /// Check if token needs refresh
  Future<bool> ensureValidToken() async {
    if (_authToken == null) return false;
    
    if (_authToken!.isExpiringSoon) {
      return await refreshAccessToken();
    }
    
    return true;
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
