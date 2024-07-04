import 'package:cloud_firestore/cloud_firestore.dart';

class Media {
  String id;
  String userId;
  String filePath;
  String fileType; // "audio", "picture", "video"
  Timestamp timestamp;

  Media({
    required this.id,
    required this.userId,
    required this.filePath,
    required this.fileType,
    required this.timestamp,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      filePath: json['file_path'] ?? '',
      fileType: json['file_type']?? '',
      timestamp: json['timestamp'],
    );
  }

  factory Media.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Media.fromJson(doc.data()!)..id = doc.id;
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'file_path': filePath,
      'file_type': fileType,
      'timestamp': timestamp,
    };
  }

  static Future<Media> fromDocumentReference(DocumentReference<Map<String, dynamic>> documentReference) async {
    DocumentSnapshot<Map<String, dynamic>> doc = await documentReference.get();
    return Media.fromDocument(doc);
  }
}
