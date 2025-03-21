import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/report.dart';

class ReportService {
  final String baseUrl = "http://127.0.0.1:8000/api";

  // 🔹 Ambil laporan transaksi berdasarkan rentang tanggal
  Future<ReportModel> fetchSalesReport(String startDate, String endDate) async {
    final response = await http.get(
      Uri.parse('$baseUrl/report/sales?start_date=$startDate&end_date=$endDate'),
    );

    if (response.statusCode == 200) {
      return ReportModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Gagal mengambil laporan penjualan");
    }
  }

  // 🔹 Ambil laporan refund berdasarkan rentang tanggal
  Future<ReportModel> fetchRefundReport(String startDate, String endDate) async {
    final response = await http.get(
      Uri.parse('$baseUrl/report/refund?start_date=$startDate&end_date=$endDate'),
    );

    if (response.statusCode == 200) {
      return ReportModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Gagal mengambil laporan refund");
    }
  }

  // 🔹 Ambil data untuk grafik transaksi per hari
  Future<List<Map<String, dynamic>>> fetchSalesChart(String startDate, String endDate) async {
    final response = await http.get(
      Uri.parse('$baseUrl/report/sales?start_date=$startDate&end_date=$endDate'),
    );

    if (response.statusCode == 200) {
      List<dynamic> sales = json.decode(response.body)["sales"];
      return sales.map((e) => {"date": e["date"], "total_sales": e["total_sales"]}).toList();
    } else {
      throw Exception("Gagal mengambil data grafik penjualan");
    }
  }

  // 🔹 Ambil data untuk grafik refund per hari
  Future<List<Map<String, dynamic>>> fetchRefundChart(String startDate, String endDate) async {
    final response = await http.get(
      Uri.parse('$baseUrl/report/refund?start_date=$startDate&end_date=$endDate'),
    );

    if (response.statusCode == 200) {
      List<dynamic> refunds = json.decode(response.body)["refunds"];
      return refunds.map((e) => {"date": e["date"], "total_refunded_items": e["total_refunded_items"]}).toList();
    } else {
      throw Exception("Gagal mengambil data grafik refund");
    }
  }
}
