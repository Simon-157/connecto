class NotificationModel {
  String notificationId;
  String userId;
  String senderId;
  String
      type; // connection request,  connection request accpetance or decline, message received, job posted, session reminder
  String message;
  bool isRead;
  DateTime timestamp;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.senderId,
    required this.type,
    required this.message,
    this.isRead = false,
    required this.timestamp,
  });

  NotificationModel copyWith({
    String? notificationId,
    String? userId,
    String? senderId,
    String? type,
    String? message,
    bool? isRead,
    DateTime? timestamp,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      senderId: json['sender_id'],
      notificationId: json['notification_id'],
      userId: json['user_id'],
      type: json['type'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['is_read'] ?? false, // Handle missing field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'notification_id': notificationId,
      'user_id': userId,
      'type': type,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notificationId': notificationId,
      'userId': userId,
      'senderId': senderId,
      'type': type,
      'message': message,
      'isRead': isRead,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notificationId: map['notificationId'] as String,
      userId: map['userId'] as String,
      senderId: map['senderId'] as String,
      type: map['type'] as String,
      message: map['message'] as String,
      isRead: map['isRead'] as bool,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }

  @override
  String toString() {
    return 'Notification(notificationId: $notificationId, userId: $userId, senderId: $senderId, type: $type, message: $message, isRead: $isRead, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.notificationId == notificationId &&
        other.userId == userId &&
        other.senderId == senderId &&
        other.type == type &&
        other.message == message &&
        other.isRead == isRead &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return notificationId.hashCode ^
        userId.hashCode ^
        senderId.hashCode ^
        type.hashCode ^
        message.hashCode ^
        isRead.hashCode ^
        timestamp.hashCode;
  }
}
