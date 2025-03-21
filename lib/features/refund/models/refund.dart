class RefundModel {
  final int id;
  final int transactionId;
  final int quantity;
  final String reason;
  final String status;
  final String date;

  RefundModel({
    required this.id,
    required this.transactionId,
    required this.quantity,
    required this.reason,
    required this.status,
    required this.date,
  });

  factory RefundModel.fromJson(Map<String, dynamic> json) {
    return RefundModel(
      id: json['id'],
      transactionId: json['transaction_id'],
      quantity: json['quantity'],
      reason: json['reason'],
      status: json['status'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'quantity': quantity,
      'reason': reason,
      'status': status,
      'date': date,
    };
  }
}
