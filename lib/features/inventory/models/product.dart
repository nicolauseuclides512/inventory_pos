class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
  });

  // Factory untuk mengubah JSON menjadi Object Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      price: double.parse(json["price"].toString()),
      stock: json["stock"],
      imageUrl: json["image_url"] ?? "", // Bisa kosong jika tidak ada gambar
    );
  }

  // Konversi Product ke Map untuk keperluan API
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "stock": stock,
      "image_url": imageUrl,
    };
  }
}
