import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';

class TransactionService {
  final String baseUrl = "http://127.0.0.1:8000/api";

  Future<List<TransactionModel>> fetchTransactions() async {
    final response = await http.get(Uri.parse('$baseUrl/transactions'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil transaksi");
    }
  }

  Future<void> createTransaction(TransactionModel transaction) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transactions'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(transaction.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Gagal membuat transaksi");
    }
  }
}
