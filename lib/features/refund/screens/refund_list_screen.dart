import 'package:flutter/material.dart';
import '../models/refund.dart';
import '../services/refund_service.dart';

class RefundListScreen extends StatefulWidget {
  const RefundListScreen({super.key});

  @override
  _RefundListScreenState createState() => _RefundListScreenState();
}

class _RefundListScreenState extends State<RefundListScreen> {
  final RefundService _refundService = RefundService();
  List<RefundModel> _refunds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRefunds();
  }

  Future<void> _fetchRefunds() async {
    try {
      List<RefundModel> refunds = await _refundService.fetchRefunds();
      setState(() {
        _refunds = refunds;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Retur")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _refunds.isEmpty
              ? Center(child: Text("Belum ada retur."))
              : ListView.builder(
                  itemCount: _refunds.length,
                  itemBuilder: (context, index) {
                    final refund = _refunds[index];
                    return ListTile(
                      title: Text("Transaksi ID: ${refund.transactionId}"),
                      subtitle: Text("Jumlah: ${refund.quantity} | Status: ${refund.status}"),
                      trailing: refund.status == "Approved"
                          ? Icon(Icons.check_circle, color: Colors.green)
                          : Icon(Icons.pending, color: Colors.orange),
                    );
                  },
                ),
    );
  }
}
