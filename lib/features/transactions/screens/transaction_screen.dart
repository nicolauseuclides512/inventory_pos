import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';
import 'transaction_form_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final TransactionService _transactionService = TransactionService();
  List<TransactionModel> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    try {
      List<TransactionModel> transactions = await _transactionService.fetchTransactions();
      setState(() {
        _transactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TransactionFormScreen()),
    ).then((_) => _fetchTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transaksi")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _transactions.isEmpty
              ? Center(child: Text("Belum ada transaksi."))
              : ListView.builder(
                  itemCount: _transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = _transactions[index];
                    return ListTile(
                      title: Text("ID: ${transaction.id} - Total: \$${transaction.totalPrice}"),
                      subtitle: Text("Tanggal: ${transaction.date}"),
                      onTap: () {
                        // Nanti bisa diarahkan ke detail transaksi
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToForm,
        child: Icon(Icons.add),
      ),
    );
  }
}
