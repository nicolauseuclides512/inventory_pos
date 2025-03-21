import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/log.dart';

class LogService {
  final String baseUrl = "http://127.0.0.1:8000/api";

  Future<List<ActivityLog>> fetchLogs({String? searchQuery, DateTime? startDate, DateTime? endDate}) async {
    // 🔹 Tambahkan query parameters ke URL jika ada
    String url = '$baseUrl/activity-logs';
    Map<String, String> queryParams = {};

    if (searchQuery != null && searchQuery.isNotEmpty) {
      queryParams['keyword'] = searchQuery;
    }
    if (startDate != null && endDate != null) {
      queryParams['start_date'] = startDate.toIso8601String();
      queryParams['end_date'] = endDate.toIso8601String();
    }

    if (queryParams.isNotEmpty) {
      url += "?${Uri(queryParameters: queryParams).query}";
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> logs = json.decode(response.body)['data'];
      return logs.map((json) => ActivityLog.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil log aktivitas");
    }
  }
}
