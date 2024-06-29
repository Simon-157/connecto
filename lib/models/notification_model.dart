class Notification {
  String notificationId;
  String userId;
  String type;
  String message;
  DateTime timestamp;

  Notification({
    required this.notificationId,
    required this.userId,
    required this.type,
    required this.message,
    required this.timestamp,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      notificationId: json['notification_id'],
      userId: json['user_id'],
      type: json['type'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_id': notificationId,
      'user_id': userId,
      'type': type,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
