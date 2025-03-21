import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/report.dart';
import '../services/report_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ReportService _reportService = ReportService();
  DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _endDate = DateTime.now();
  ReportModel? _report;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    try {
      _report = await _reportService.fetchSalesReport(
        DateFormat('yyyy-MM-dd').format(_startDate),
        DateFormat('yyyy-MM-dd').format(_endDate),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _isLoading = true;
      });

      _fetchReports();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Laporan & Statistik")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _selectDateRange(context),
              child: Text("Pilih Rentang Tanggal"),
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _report == null
                    ? Center(child: Text("Gagal mengambil data laporan."))
                    : Text("Total Pendapatan: ${_report!.totalIncome}"),
          ],
        ),
      ),
    );
  }
}
