import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id; 
  String senderId;
  String receiverId;
  String content;
  Timestamp timestamp;
  DocumentReference? media; 

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
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      content: json['content'],
      timestamp: json['timestamp'],
      media: json['media'],
    );
  }

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message.fromJson(doc.data()! as Map<String, dynamic>)..id = doc.id;
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
