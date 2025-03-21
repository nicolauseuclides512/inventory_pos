import 'package:flutter/material.dart';
import '../../inventory/models/product.dart';
import '../../inventory/services/inventory_service.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key});

  @override
  _TransactionFormScreenState createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final TransactionService _transactionService = TransactionService();
  final InventoryService _inventoryService = InventoryService();
  List<Product> _products = [];
  Product? _selectedProduct;
  int _quantity = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    List<Product> products = await _inventoryService.fetchProducts();
    setState(() {
      _products = products;
    });
  }

  void _submitTransaction() async {
    if (_selectedProduct == null || _quantity <= 0) return;

    setState(() {
      _isLoading = true;
    });

    final newTransaction = TransactionModel(
      id: 0,
      productId: _selectedProduct!.id,
      quantity: _quantity,
      totalPrice: _selectedProduct!.price * _quantity,
      date: DateTime.now().toString(),
    );

    await _transactionService.createTransaction(newTransaction);

    setState(() {
      _isLoading = false;
    });

    Navigator.pop(context); // Kembali ke daftar transaksi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buat Transaksi")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<Product>(
              value: _selectedProduct,
              hint: Text("Pilih Produk"),
              isExpanded: true,
              items: _products.map((product) {
                return DropdownMenuItem(
                  value: product,
                  child: Text("${product.name} - \$${product.price}"),
                );
              }).toList(),
              onChanged: (Product? product) {
                setState(() {
                  _selectedProduct = product;
                });
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Jumlah"),
              onChanged: (value) {
                setState(() {
                  _quantity = int.tryParse(value) ?? 1;
                });
              },
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitTransaction,
                    child: Text("Selesaikan Transaksi"),
                  ),
          ],
        ),
      ),
    );
  }
}
