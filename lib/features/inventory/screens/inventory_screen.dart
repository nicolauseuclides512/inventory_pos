import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/inventory_service.dart';
import 'product_form_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final InventoryService _inventoryService = InventoryService();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String _searchQuery = "";
  String _filterOption = "All";

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      List<Product> products = await _inventoryService.fetchProducts();
      setState(() {
        _products = products;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredProducts = _products.where((product) {
        bool matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase());
        bool matchesFilter = (_filterOption == "All") ||
            (_filterOption == "In Stock" && product.stock > 0) ||
            (_filterOption == "Out of Stock" && product.stock == 0) ||
            (_filterOption == "Expensive" && product.price > 100); // contoh filter harga

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _onFilterChanged(String? selectedOption) {
    if (selectedOption != null) {
      setState(() {
        _filterOption = selectedOption;
        _applyFilters();
      });
    }
  }

  void _navigateToForm({Product? product}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(product: product),
      ),
    ).then((_) => _fetchProducts());
  }

  void _deleteProduct(int productId) async {
    await _inventoryService.deleteProduct(productId);
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inventory")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Cari produk...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: _filterOption,
              isExpanded: true,
              items: ["All", "In Stock", "Out of Stock", "Expensive"]
                  .map((filter) => DropdownMenuItem(value: filter, child: Text(filter)))
                  .toList(),
              onChanged: _onFilterChanged,
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                    ? Center(child: Text("Tidak ada produk ditemukan."))
                    : ListView.builder(
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return ListTile(
                            leading: product.imageUrl.isNotEmpty
                                ? Image.network(product.imageUrl, width: 50, height: 50)
                                : Icon(Icons.inventory),
                            title: Text(product.name),
                            subtitle: Text("Stock: ${product.stock} - \$${product.price}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _navigateToForm(product: product),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteProduct(product.id),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
