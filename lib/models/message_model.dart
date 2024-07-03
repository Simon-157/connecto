import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id; 
  String senderId;
  String receiverId;
  String content;
  Timestamp timestamp;
  dynamic media; 

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.media,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      senderId: json['sender_id'] ?? '',
      receiverId: json['receiver_id'] ?? '',
      content: json['content'] ?? '',
      timestamp: json['timestamp'] ?? Timestamp.now(),
      media: json['media'],
    );
  }

  factory Message.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception("Document data was null");
    }
    return Message.fromJson(data);

  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'timestamp': timestamp,
      'media': media,
    };
  }
}
