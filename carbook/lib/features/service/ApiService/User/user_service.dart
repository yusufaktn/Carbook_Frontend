import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../model/User/user_model.dart';

class UserService {
  // API base URL - projenize göre güncelleyin
  static const String baseUrl = 'http://localhost:5291/api/User';

  // Kullanıcı listesini getir
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/GetUser'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Kullanıcılar yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kullanıcılar yüklenirken hata oluştu: $e');
    }
  }

  // ID'ye göre kullanıcı getir
  Future<UserModel> getUserById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/GetUserById?id=$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserModel.fromJson(data);
      } else {
        throw Exception('Kullanıcı bulunamadı: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kullanıcı yüklenirken hata oluştu: $e');
    }
  }

  // Kullanıcı oluştur
  Future<bool> createUser(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/CreateUser'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userName': user.userName,
          'userLastName': user.userLastName,
          'email': user.email,
          'passwordHash': 'temp_password', // Şifre hash'i için
          'profileImageUrl': user.profileImageUrl,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Kullanıcı oluşturulurken hata oluştu: $e');
    }
  }

  // Kullanıcı güncelle
  Future<bool> updateUser(UserModel user) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/UpdateUser'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': user.userId,
          'userName': user.userName,
          'userLastName': user.userLastName,
          'email': user.email,
          'passwordHash': 'temp_password', // Şifre değişikliği için ayrı endpoint olabilir
          'profileImageUrl': user.profileImageUrl,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Kullanıcı güncellenirken hata oluştu: $e');
    }
  }

  // Kullanıcı sil
  Future<bool> deleteUser(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/DeleteUser?id=$id'),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Kullanıcı silinirken hata oluştu: $e');
    }
  }
}
