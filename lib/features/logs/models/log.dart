class ActivityLog {
  final String userName;
  final String action;
  final String module;
  final String ipAddress;
  final String createdAt;

  ActivityLog({
    required this.userName,
    required this.action,
    required this.module,
    required this.ipAddress,
    required this.createdAt,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      userName: json['user']['name'],
      action: json['action'],
      module: json['module'],
      ipAddress: json['ip_address'],
      createdAt: json['created_at'],
    );
  }
}
