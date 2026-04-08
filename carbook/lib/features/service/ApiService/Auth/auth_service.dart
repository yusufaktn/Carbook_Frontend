import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../model/Auth/login_request.dart';
import '../../../model/Auth/login_response.dart';
import '../../../model/Auth/register_request.dart';
import '../../../model/Auth/register_response.dart';

/// Authentication service for API communication
class AuthService {
  // API base URL - Update this based on your backend
  static const String baseUrl = 'http://localhost:5291/api/Auth';

  /// Login user with email and password
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(data);
      } else {
        // Handle error response
        return LoginResponse(
          success: false,
          message: data['message'] ?? 'Giriş başarısız',
        );
      }
    } catch (e) {
      return LoginResponse(
        success: false,
        message: 'Giriş sırasında bir hata oluştu: $e',
      );
    }
  }

  /// Register new user
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return RegisterResponse.fromJson(data);
      } else {
        return RegisterResponse(
          success: false,
          message: data['message'] ?? 'Kayıt başarısız',
        );
      }
    } catch (e) {
      return RegisterResponse(
        success: false,
        message: 'Kayıt sırasında bir hata oluştu: $e',
      );
    }
  }

  /// Refresh access token using refresh token
  Future<LoginResponse> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/RefreshToken'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refreshToken': refreshToken}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return LoginResponse(
          success: data['success'] ?? true,
          message: data['message'],
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'],
          expiryDate: data['expiryDate'] != null
              ? DateTime.parse(data['expiryDate'])
              : null,
        );
      } else {
        return LoginResponse(
          success: false,
          message: data['message'] ?? 'Token yenilenemedi',
        );
      }
    } catch (e) {
      return LoginResponse(
        success: false,
        message: 'Token yenilenirken hata oluştu: $e',
      );
    }
  }

  /// Logout user (revoke refresh token)
  Future<bool> logout(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Logout'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refreshToken': refreshToken}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  /// Get current user info (test authenticated endpoint)
  Future<Map<String, dynamic>?> getCurrentUser(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }
}
