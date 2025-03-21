import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<bool> login(String email, String password) async {
    try {
      Response response = await _apiService.post("/login", {
        "email": email,
        "password": password,
      });

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", response.data["token"]);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }
}