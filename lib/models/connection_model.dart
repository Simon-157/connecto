class Connection {
  String connectionId;
  String userId;
  String connectedUserId;
  String status;

  Connection({
    required this.connectionId,
    required this.userId,
    required this.connectedUserId,
    required this.status,
  });

  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
      connectionId: json['connection_id'],
      userId: json['user_id'],
      connectedUserId: json['connected_user_id'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'connection_id': connectionId,
      'user_id': userId,
      'connected_user_id': connectedUserId,
      'status': status,
    };
  }
}
