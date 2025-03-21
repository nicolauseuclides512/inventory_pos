import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/report_service.dart';

class ReportChartScreen extends StatefulWidget {
  const ReportChartScreen({super.key});

  @override
  _ReportChartScreenState createState() => _ReportChartScreenState();
}

class _ReportChartScreenState extends State<ReportChartScreen> {
  final ReportService _reportService = ReportService();
  DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _endDate = DateTime.now();
  List<Map<String, dynamic>> _salesData = [];
  List<Map<String, dynamic>> _refundData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    try {
      List<Map<String, dynamic>> sales = await _reportService.fetchSalesChart(
        DateFormat('yyyy-MM-dd').format(_startDate),
        DateFormat('yyyy-MM-dd').format(_endDate),
      );

      List<Map<String, dynamic>> refunds = await _reportService.fetchRefundChart(
        DateFormat('yyyy-MM-dd').format(_startDate),
        DateFormat('yyyy-MM-dd').format(_endDate),
      );

      setState(() {
        _salesData = sales.isNotEmpty ? sales : [];
        _refundData = refunds.isNotEmpty ? refunds : [];
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

  List<FlSpot> _mapSalesDataToFlSpot() {
    if (_salesData.isEmpty) return [];
    return _salesData.asMap().entries.map((entry) {
      double x = entry.key.toDouble();
      double y = (entry.value["total_sales"] ?? 0).toDouble();
      return FlSpot(x, y);
    }).toList();
  }

  List<FlSpot> _mapRefundDataToFlSpot() {
    if (_refundData.isEmpty) return [];
    return _refundData.asMap().entries.map((entry) {
      double x = entry.key.toDouble();
      double y = (entry.value["total_refunded_items"] ?? 0).toDouble();
      return FlSpot(x, y);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Grafik Laporan")),
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
                : Expanded(
                    child: Column(
                      children: [
                        Text("Grafik Penjualan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: LineChart(
                            LineChartData(
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _mapSalesDataToFlSpot(),
                                  isCurved: true,
                                  barWidth: 4,
                                  color: Colors.blue,
                                  belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("Grafik Refund", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: LineChart(
                            LineChartData(
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _mapRefundDataToFlSpot(),
                                  isCurved: true,
                                  barWidth: 4,
                                  color: Colors.red,
                                  belowBarData: BarAreaData(show: true, color: Colors.red.withOpacity(0.3)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
