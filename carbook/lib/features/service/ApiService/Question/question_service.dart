import 'package:carbook/features/model/Question/question_model.dart';
import 'package:carbook/core/constant/app_constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/io.dart';
import 'dart:io';

class QuestionService {
  static Dio _getDio() {
    final dio = Dio();

    // Platform kontrolü ile HTTPS sertifika ayarları (sadece mobil için)
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    // Timeout ayarları
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.sendTimeout = const Duration(seconds: 10);

    return dio;
  }

  static Future<List<QuestionModel>> fetchLastQuestions() async {
    try {
      final dio = _getDio();

      // Platform bilgisi
      print('Platform: ${kIsWeb ? "Web" : "Mobile"}');
      print('API Request URL: $QuestionBaseUrl/GetLastThreeQuestions');

      final response = await dio.get("$QuestionBaseUrl/GetLastThreeQuestions");

      print('API Response Status: ${response.statusCode}');
      print('API Response Data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data is List) {
          return List<QuestionModel>.from(
            response.data.map((item) => QuestionModel.fromJson(item)),
          );
        } else {
          throw Exception('API response is not a list: ${response.data}');
        }
      } else {
        throw Exception('API returned status code: ${response.statusCode}');
      }
    } catch (e) {
      print('QuestionService Error: $e');
      throw Exception('Failed to load questions: $e');
    }
  }

  static Future<List<QuestionModel>> fetchAllQuestions() async {
    try {
      final dio = _getDio();

      print('Platform: ${kIsWeb ? "Web" : "Mobile"}');
      print('API Request URL: $QuestionBaseUrl/GetQuestion');

      final response = await dio.get("$QuestionBaseUrl/GetQuestion");

      print('API Response Status: ${response.statusCode}');
      print('API Response Data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data is List) {
          return List<QuestionModel>.from(
            response.data.map((item) => QuestionModel.fromJson(item)),
          );
        } else {
          throw Exception('API response is not a list: ${response.data}');
        }
      } else {
        throw Exception('API returned status code: ${response.statusCode}');
      }
    } catch (e) {
      print('QuestionService Error: $e');
      throw Exception('Failed to load questions: $e');
    }
  }
}
