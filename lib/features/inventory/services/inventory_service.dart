import 'package:dio/dio.dart';
import '../../../core/services/api_service.dart';
import '../models/product.dart';

class InventoryService {
  final ApiService _apiService = ApiService();

  // Mendapatkan daftar produk
  Future<List<Product>> fetchProducts() async {
    try {
      Response response = await _apiService.get("/products");
      List<dynamic> data = response.data["products"];
      return data.map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }

  // Menambah produk baru
  Future<void> addProduct(Product product) async {
    await _apiService.post("/products", product.toJson());
  }

  // Mengupdate produk
  Future<void> updateProduct(int productId, Product product) async {
    await _apiService.put("/products/$productId", product.toJson());
  }

  // Menghapus produk
  Future<void> deleteProduct(int productId) async {
    await _apiService.delete("/products/$productId");
  }
}
