import 'package:carbook/core/constant/app_constant.dart';
import 'package:carbook/features/model/Category/CategoryModel.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'dart:io';

class Categoryservice {
  static Future<List<Categorymodel>> fetchCategory() async {
    try {
      // Dio instance oluştur ve yapılandır
      final dio = Dio();

      // Development için HTTPS sertifika kontrolünü atla
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };

      // Timeout ayarları
      dio.options.connectTimeout = const Duration(seconds: 10);
      dio.options.receiveTimeout = const Duration(seconds: 10);
      dio.options.sendTimeout = const Duration(seconds: 10);

      print('API Request URL: $CategorybaseUrl/GetCategory');

      final response = await dio.get("$CategorybaseUrl/GetCategory");

      print('API Response Status: ${response.statusCode}');
      print('API Response Data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data is List) {
          return List<Categorymodel>.from(
            response.data.map((item) => Categorymodel.fromJson(item)),
          );
        } else {
          throw Exception('API response is not a list: ${response.data}');
        }
      } else {
        throw Exception('API returned status code: ${response.statusCode}');
      }
    } catch (e) {
      print('CategoryService Error: $e');
      throw Exception('Failed to load category: $e');
    }
  }
}
