// lib/services/api_service.dart
import 'package:dio/dio.dart';
import '../config.dart';

class ApiService {
  ApiService._internal();
  static final ApiService instance = ApiService._internal();

  final Dio _dio = Dio(BaseOptions(
    baseUrl: API_BASE_URL,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {"Content-Type": "application/json"},
  ));

  Future<String> encryptText(String text) async {
    try {
      final response = await _dio.post("/encrypt", data: {"text": text});
      return response.data["ciphertext"].toString();
    } on DioError catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<String> decryptText(String ciphertext) async {
    try {
      final response = await _dio.post("/decrypt", data: {"ciphertext": ciphertext});
      return response.data["text"].toString();
    } on DioError catch (e) {
      throw Exception(_handleError(e));
    }
  }

  String _handleError(DioError e) {
    if (e.response != null && e.response!.data != null) {
      final data = e.response!.data;
      if (data is Map && data.containsKey("error")) {
        return data["error"].toString();
      }
      if (data is Map && data.containsKey("message")) {
        return data["message"].toString();
      }
      return data.toString();
    }
    return e.message ?? "Unknown network error";
  }
}
