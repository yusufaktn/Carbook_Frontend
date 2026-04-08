import 'package:flutter/material.dart';
import '../../model/User/user_model.dart';
import '../../service/ApiService/User/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  
  List<UserModel> _users = [];
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  List<UserModel> get users => _users;
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Kullanıcıları yükle
  Future<void> loadUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _users = await _userService.getUsers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mevcut kullanıcıyı yükle (ID ile)
  Future<void> loadCurrentUser(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _userService.getUserById(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Kullanıcı profili güncelle
  Future<bool> updateUserProfile(UserModel user) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _userService.updateUser(user);
      if (success) {
        _currentUser = user;
        // Kullanıcı listesini de güncelle
        final index = _users.indexWhere((u) => u.userId == user.userId);
        if (index != -1) {
          _users[index] = user;
        }
      }
      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Kullanıcı oluştur
  Future<bool> createUser(UserModel user) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _userService.createUser(user);
      if (success) {
        await loadUsers(); // Listeyi yenile
      }
      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Profil resmini güncelle
  Future<bool> updateProfileImage(String imageUrl) async {
    if (_currentUser == null) return false;

    final updatedUser = UserModel(
      userId: _currentUser!.userId,
      userName: _currentUser!.userName,
      userLastName: _currentUser!.userLastName,
      email: _currentUser!.email,
      profileImageUrl: imageUrl,
    );

    return await updateUserProfile(updatedUser);
  }

  // Hata mesajını temizle
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
