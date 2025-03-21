import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/log_service.dart';
import '../models/log.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  _LogScreenState createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final LogService _logService = LogService();
  List<ActivityLog> _logs = [];
  bool _isLoading = true;
  String _searchQuery = "";
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    try {
      List<ActivityLog> logs = await _logService.fetchLogs(
        searchQuery: _searchQuery,
        startDate: _startDate,
        endDate: _endDate,
      );
      setState(() {
        _logs = logs;
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
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _isLoading = true;
      });

      _fetchLogs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Log Aktivitas")),
      body: Column(
        children: [
          // 🔹 Input pencarian log
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _fetchLogs();
              },
              decoration: InputDecoration(
                hintText: "Cari log...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // 🔹 Tombol filter tanggal
          ElevatedButton(
            onPressed: () => _selectDateRange(context),
            child: Text("Pilih Rentang Tanggal"),
          ),

          // 🔹 List Log Aktivitas
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _logs.isEmpty
                    ? Center(child: Text("Tidak ada log aktivitas."))
                    : ListView.builder(
                        itemCount: _logs.length,
                        itemBuilder: (context, index) {
                          final log = _logs[index];
                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: ListTile(
                              leading: Icon(Icons.history, color: Colors.blue),
                              title: Text("${log.userName} - ${log.action}"),
                              subtitle: Text("Modul: ${log.module} | IP: ${log.ipAddress}"),
                              trailing: Text(
                                DateFormat("dd MMM yyyy, HH:mm").format(DateTime.parse(log.createdAt)),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
