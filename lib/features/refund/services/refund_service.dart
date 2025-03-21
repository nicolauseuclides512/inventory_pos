import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/refund.dart';

class RefundService {
  final String baseUrl = "http://127.0.0.1:8000/api";

  Future<List<RefundModel>> fetchRefunds() async {
    final response = await http.get(Uri.parse('$baseUrl/refunds'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => RefundModel.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil daftar retur");
    }
  }

  Future<void> submitRefund(RefundModel refund) async {
    final response = await http.post(
      Uri.parse('$baseUrl/refunds'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(refund.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Gagal mengajukan retur");
    }
  }
}
