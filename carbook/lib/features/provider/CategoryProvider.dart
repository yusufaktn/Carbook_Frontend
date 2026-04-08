import 'package:carbook/features/model/Category/CategoryModel.dart';
import 'package:carbook/features/service/ApiService/Category/CategoryService.dart';
import 'package:flutter/cupertino.dart';

class CategoryProvider with ChangeNotifier {
  List<Categorymodel> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<Categorymodel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCategories() async {
    if (_isLoading) return; // Eğer zaten yükleniyor ise tekrar yükleme

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<Categorymodel> response =
          await Categoryservice.fetchCategory();
      _categories = response; // addAll yerine direkt atama
      _error = null;
      print('Categories loaded successfully: ${response.length} items');
    } catch (error) {
      String errorMessage;

      if (error.toString().contains('XMLHttpRequest') ||
          error.toString().contains('Connection refused') ||
          error.toString().contains('Network error')) {
        errorMessage =
            'Sunucuya bağlanılamadı. İnternet bağlantınızı kontrol edin.';
      } else if (error.toString().contains('certificate') ||
          error.toString().contains('CERTIFICATE_VERIFY_FAILED')) {
        errorMessage =
            'Güvenlik sertifikası hatası. Sunucu ayarlarını kontrol edin.';
      } else if (error.toString().contains('timeout')) {
        errorMessage = 'Bağlantı zaman aşımına uğradı. Tekrar deneyin.';
      } else {
        errorMessage = 'Kategoriler yüklenirken hata oluştu: $error';
      }

      _error = errorMessage;
      print('Detailed error: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
