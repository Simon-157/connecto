import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecto/models/message_model.dart';
import 'package:connecto/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String messagesCollection = 'messages';
  final String usersCollection = 'users';
  final String mediaCollection = 'media';

  // Singleton pattern
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  //  message with optional media
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
    String? filePath,
    String? fileType,
  }) async {
    DocumentReference? mediaRef;

    if (filePath != null && fileType != null) {
      mediaRef = await _uploadMedia(senderId, filePath, fileType);
    }

    await _firestore.collection(messagesCollection).add({
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'timestamp': Timestamp.now(),
      'media': mediaRef,
    });
  }

  Future<DocumentReference> _uploadMedia(String userId, String filePath, String fileType) async {
    String fileId = Uuid().v4();
    String storagePath = '$userId/$fileId';

    TaskSnapshot uploadTask = await _storage.ref(storagePath).putFile(File(filePath));
    String downloadUrl = await uploadTask.ref.getDownloadURL();

    DocumentReference mediaRef = await _firestore.collection(mediaCollection).add({
      'user_id': userId,
      'file_path': downloadUrl,
      'file_type': fileType,
      'timestamp': Timestamp.now(),
    });

    return mediaRef;
  }




Stream<List<Message>> getMessages(String userId1, String userId2) {
  final _firestore = FirebaseFirestore.instance;

  // Query messages sent from userId1 to userId2
  Stream<List<Message>> stream1 = _firestore
      .collection('messages')
      .where('sender_id', isEqualTo: userId1)
      .where('receiver_id', isEqualTo: userId2)
      .orderBy('timestamp')
      .snapshots()
      .map((snapshot) => _messageListFromSnapshot(snapshot));

  // Query messages sent from userId2 to userId1
  Stream<List<Message>> stream2 = _firestore
      .collection('messages')
      .where('sender_id', isEqualTo: userId2)
      .where('receiver_id', isEqualTo: userId1)
      .orderBy('timestamp')
      .snapshots()
      .map((snapshot) => _messageListFromSnapshot(snapshot));

  // Merge both streams and sort the combined list by timestamp
  return Rx.combineLatest2(stream1, stream2, (List<Message> messages1, List<Message> messages2) {
    List<Message> mergedMessages = [...messages1, ...messages2];
    mergedMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return mergedMessages;
  });
}

List<Message> _messageListFromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) => Message.fromDocument(doc)).toList();
}


  // Get user details
  Future<UserModel?> getUser(String userId) async {
    DocumentSnapshot doc = await _firestore.collection(usersCollection).doc(userId).get();
    if (doc.exists) {
      return UserModel.fromDocument(doc);
    } else {
      return null;
    }
  }

  // Update user details
  Future<void> updateUser(UserModel user) async {
    await _firestore.collection(usersCollection).doc(user.id).update(user.toJson());
  }

  // Delete message by ID
  Future<void> deleteMessage(String messageId) async {
    await _firestore.collection(messagesCollection).doc(messageId).delete();
  }

  // Delete media by ID
  Future<void> deleteMedia(String mediaId) async {
    await _firestore.collection(mediaCollection).doc(mediaId).delete();
  }
}
