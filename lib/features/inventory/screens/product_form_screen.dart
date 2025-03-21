import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/inventory_service.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;
  const ProductFormScreen({super.key, this.product});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final InventoryService _inventoryService = InventoryService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  String _imageUrl = "";

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? "");
    _descController = TextEditingController(text: widget.product?.description ?? "");
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? "");
    _stockController = TextEditingController(text: widget.product?.stock.toString() ?? "");
    _imageUrl = widget.product?.imageUrl ?? "";
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product?.id ?? 0,
        name: _nameController.text,
        description: _descController.text,
        price: double.parse(_priceController.text),
        stock: int.parse(_stockController.text),
        imageUrl: _imageUrl,
      );

      if (widget.product == null) {
        await _inventoryService.addProduct(product);
      } else {
        await _inventoryService.updateProduct(product.id, product);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product == null ? "Tambah Produk" : "Edit Produk")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nameController, decoration: InputDecoration(labelText: "Nama Produk")),
              TextFormField(controller: _descController, decoration: InputDecoration(labelText: "Deskripsi")),
              TextFormField(controller: _priceController, decoration: InputDecoration(labelText: "Harga")),
              TextFormField(controller: _stockController, decoration: InputDecoration(labelText: "Stok")),
              ElevatedButton(onPressed: _saveProduct, child: Text("Simpan")),
            ],
          ),
        ),
      ),
    );
  }
}
