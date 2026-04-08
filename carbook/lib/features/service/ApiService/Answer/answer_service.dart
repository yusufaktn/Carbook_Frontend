import 'package:carbook/features/model/Answer/answer_model.dart';
import 'package:carbook/core/constant/app_constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/io.dart';
import 'dart:io';

class AnswerService {
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

  static Future<List<AnswerModel>> fetchAnswersByQuestionId(
    int questionId,
  ) async {
    try {
      final dio = _getDio();

      // Platform bilgisi
      print('Platform: ${kIsWeb ? "Web" : "Mobile"}');
      print(
        'API Request URL: ${AppConstant.baseUrl}/Answer/GetAnswerByQuestionId?questionId=$questionId',
      );

      final response = await dio.get(
        '${AppConstant.baseUrl}/Answer/GetAnswerByQuestionId',
        queryParameters: {'questionId': questionId},
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data is List) {
          return List<AnswerModel>.from(
            response.data.map((item) => AnswerModel.fromJson(item)),
          );
        } else {
          throw Exception('API response is not a list: ${response.data}');
        }
      } else {
        throw Exception('API returned status code: ${response.statusCode}');
      }
    } catch (e) {
      print('AnswerService.fetchAnswersByQuestionId error: $e');
      throw Exception('Failed to load answers: $e');
    }
  }

  static Future<bool> addAnswer(int questionId, String content) async {
    try {
      final dio = _getDio();

      print('Platform: ${kIsWeb ? "Web" : "Mobile"}');
      print('API Request URL: ${AppConstant.baseUrl}/Answer/CreateAnswer');

      final requestData = {
        'questionId': questionId,
        'content': content,
        'userId':
            1, // Şu an için sabit, ileride authentication ile değiştirilecek
      };

      final response = await dio.post(
        '${AppConstant.baseUrl}/Answer/CreateAnswer',
        data: requestData,
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Data: ${response.data}');

      if (response.statusCode == 200) {
        // .NET API CreateAnswer endpoint'i başarılı olduğunda sadece success message döndürür
        return true;
      } else {
        throw Exception('API returned status code: ${response.statusCode}');
      }
    } catch (e) {
      print('AnswerService.addAnswer error: $e');
      throw Exception('Failed to add answer: $e');
    }
  }
}
