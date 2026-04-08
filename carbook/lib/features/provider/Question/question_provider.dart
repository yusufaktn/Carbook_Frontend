import 'package:carbook/features/model/Question/question_model.dart';
import 'package:carbook/features/service/ApiService/Question/question_service.dart';
import 'package:flutter/cupertino.dart';

class QuestionProvider with ChangeNotifier {
  List<QuestionModel> _questions = [];
  List<QuestionModel> _lastQuestion = [];
  bool _isLoading = false;
  String? _error;

  List<QuestionModel> get questions => _questions;
  List<QuestionModel> get lastQuestions => _lastQuestion;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadLastQuestions() async {
    if (_isLoading) return; // Eğer zaten yükleniyor ise tekrar yükleme

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<QuestionModel> response =
          await QuestionService.fetchLastQuestions();
      _lastQuestion = response; // addAll yerine direkt atama
      _error = null;
      print('Last questions loaded successfully: ${response.length} items');
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
        errorMessage = 'Sorular yüklenirken hata oluştu: $error';
      }

      _error = errorMessage;
      print('Detailed error: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAllQuestions() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<QuestionModel> response =
          await QuestionService.fetchAllQuestions();
      _questions = response;
      _error = null;
      print('All questions loaded successfully: ${response.length} items');
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
        errorMessage = 'Sorular yüklenirken hata oluştu: $error';
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
