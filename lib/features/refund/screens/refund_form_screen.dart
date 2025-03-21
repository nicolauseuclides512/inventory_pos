import 'package:flutter/material.dart';
import '../../transactions/models/transaction.dart';
import '../models/refund.dart';
import '../services/refund_service.dart';

class RefundFormScreen extends StatefulWidget {
  final TransactionModel transaction;
  const RefundFormScreen({super.key, required this.transaction});

  @override
  _RefundFormScreenState createState() => _RefundFormScreenState();
}

class _RefundFormScreenState extends State<RefundFormScreen> {
  final RefundService _refundService = RefundService();
  int _refundQuantity = 1;
  String _refundReason = "";
  bool _isSubmitting = false;

  void _submitRefund() async {
    if (_refundQuantity <= 0 || _refundReason.isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    final refundRequest = RefundModel(
      id: 0,
      transactionId: widget.transaction.id,
      quantity: _refundQuantity,
      reason: _refundReason,
      status: "Pending",
      date: DateTime.now().toString(),
    );

    await _refundService.submitRefund(refundRequest);

    setState(() {
      _isSubmitting = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajukan Retur")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("ID Transaksi: ${widget.transaction.id}"),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Jumlah yang diretur"),
              onChanged: (value) {
                setState(() {
                  _refundQuantity = int.tryParse(value) ?? 1;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Alasan retur"),
              onChanged: (value) {
                setState(() {
                  _refundReason = value;
                });
              },
            ),
            SizedBox(height: 20),
            _isSubmitting
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitRefund,
                    child: Text("Kirim Permohonan Retur"),
                  ),
          ],
        ),
      ),
    );
  }
}
