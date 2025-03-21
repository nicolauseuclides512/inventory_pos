class TransactionModel {
  final int id;
  final int productId;
  final int quantity;
  final double totalPrice;
  final String date;

  TransactionModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.totalPrice,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      totalPrice: double.parse(json['total_price'].toString()),
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'total_price': totalPrice,
      'date': date,
    };
  }
}
