import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecto/models/user_model.dart';

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


factory Connection.fromSnapshot(DocumentSnapshot snapshot) {
    return Connection(
      connectionId: snapshot.id,
      userId: snapshot['user_id'] ?? '',
      connectedUserId: snapshot['connected_user_id'] ?? '',
      status: snapshot['status'] ?? '',
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

  static Connection fromDocument(QueryDocumentSnapshot<Object?> doc) {

    return Connection.fromJson(doc.data()! as Map<String, dynamic>)..connectionId = doc.id;
  }
}



class ConnectionWithUser {
  final Connection connection;
  final UserModel user;

  ConnectionWithUser({
    required this.connection,
    required this.user,
  });
}


 