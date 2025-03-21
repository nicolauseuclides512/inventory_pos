import 'package:dio/dio.dart';
import '../../../core/services/api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> fetchUsers() async {
    try {
      Response response = await _apiService.get("/users");
      return response.data["users"];
    } catch (e) {
      throw Exception("Error fetching users: $e");
    }
  }

  Future<void> addUser(Map<String, dynamic> userData) async {
    await _apiService.post("/users", userData);
  }

  Future<void> updateUser(int userId, Map<String, dynamic> userData) async {
    await _apiService.put("/users/$userId", userData);
  }

  Future<void> deleteUser(int userId) async {
    await _apiService.delete("/users/$userId");
  }
}