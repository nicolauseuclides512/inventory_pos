import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://127.0.01/api", // Ganti dengan base URL API Laravel
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    ),
  );

  ApiService() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Ambil token dari SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? token = prefs.getString("token");

          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  /// **GET Request**
  Future<Response> get(String url, {Map<String, dynamic>? queryParams}) async {
    try {
      Response response = await dio.get(url, queryParameters: queryParams);
      return response;
    } on DioException catch (e) {
      throw Exception("Error in GET request: ${e.response?.data}");
    }
  }

  /// **POST Request**
  Future<Response> post(String url, dynamic data) async {
    try {
      Response response = await dio.post(url, data: data);
      return response;
    } on DioException catch (e) {
      throw Exception("Error in POST request: ${e.response?.data}");
    }
  }

  /// **PUT Request**
  Future<Response> put(String url, dynamic data) async {
    try {
      Response response = await dio.put(url, data: data);
      return response;
    } on DioException catch (e) {
      throw Exception("Error in PUT request: ${e.response?.data}");
    }
  }

  /// **DELETE Request**
  Future<Response> delete(String url) async {
    try {
      Response response = await dio.delete(url);
      return response;
    } on DioException catch (e) {
      throw Exception("Error in DELETE request: ${e.response?.data}");
    }
  }
}
