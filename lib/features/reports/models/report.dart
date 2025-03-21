class ReportModel {
  final int totalTransactions;
  final double totalIncome;
  final int totalRefunds;
  final int totalRefundedItems;
  final List<Map<String, dynamic>> salesData;
  final List<Map<String, dynamic>> refundData;

  ReportModel({
    required this.totalTransactions,
    required this.totalIncome,
    required this.totalRefunds,
    required this.totalRefundedItems,
    required this.salesData,
    required this.refundData,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      totalTransactions: json['total_transactions'] ?? 0,
      totalIncome: double.parse(json['total_income'].toString()),
      totalRefunds: json['total_refunds'] ?? 0,
      totalRefundedItems: json['total_refunded_items'] ?? 0,
      salesData: (json['sales'] as List<dynamic>).map((e) {
        return {"date": e["date"], "total_sales": e["total_sales"]};
      }).toList(),
      refundData: (json['refunds'] as List<dynamic>).map((e) {
        return {"date": e["date"], "total_refunded_items": e["total_refunded_items"]};
      }).toList(),
    );
  }
}
