import 'package:flutter/material.dart';
import '../../model/Answer/answer_model.dart';
import '../../service/ApiService/Answer/answer_service.dart';

class AnswerProvider with ChangeNotifier {
  List<AnswerModel> _answers = [];
  bool _isLoading = false;
  bool _isAddingAnswer = false;
  String? _error;

  List<AnswerModel> get answers => _answers;
  bool get isLoading => _isLoading;
  bool get isAddingAnswer => _isAddingAnswer;
  String? get error => _error;

  Future<void> loadAnswersByQuestionId(int questionId) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<AnswerModel> response =
          await AnswerService.fetchAnswersByQuestionId(questionId);
      _answers = response;
      _error = null;
      print(
        'Answers loaded successfully: ${response.length} items for question $questionId',
      );
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
        errorMessage = 'Cevaplar yüklenirken hata oluştu: $error';
      }

      _error = errorMessage;
      print('Detailed error: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addAnswer(int questionId, String content) async {
    if (_isAddingAnswer) return false;

    _isAddingAnswer = true;
    _error = null;
    notifyListeners();

    try {
      final bool success = await AnswerService.addAnswer(questionId, content);
      if (success) {
        // Cevap eklendikten sonra listeyi yeniden yükle
        await loadAnswersByQuestionId(questionId);
      }
      return success;
    } catch (error) {
      _error = 'Cevap eklenirken hata oluştu: $error';
      print('Add answer error: $error');
      return false;
    } finally {
      _isAddingAnswer = false;
      notifyListeners();
    }
  }

  void clearAnswers() {
    _answers.clear();
    _error = null;
    notifyListeners();
  }
}
