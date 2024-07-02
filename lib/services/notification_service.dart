import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecto/models/notification_model.dart';
import 'package:connecto/models/user_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create Notification
  Future<void> createNotification(String userId, String type, String message, DateTime timestamp) async {
    try {
      DocumentReference docRef = _firestore.collection('notifications').doc();
      String notificationId = docRef.id;

      await docRef.set({
        'notification_id': notificationId,
        'user_id': userId,
        'type': type,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
      });
    } catch (error) {
      print(error.toString());
      throw Exception('Failed to create notification');
    }
  }

  // Read Notification
  Future<Notification?> getNotification(String notificationId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('notifications').doc(notificationId).get();
      if (doc.exists) {
        return Notification.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (error) {
      print(error.toString());
      throw Exception('Failed to get notification');
    }
  }

  // Update Notification
  Future<void> updateNotification(String notificationId, String userId, String type, String message, DateTime timestamp) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'user_id': userId,
        'type': type,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
      });
    } catch (error) {
      print(error.toString());
      throw Exception('Failed to update notification');
    }
  }

  // Delete Notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).delete();
    } catch (error) {
      print(error.toString());
      throw Exception('Failed to delete notification');
    }
  }

  // Get Notifications with User Info for a Given User
  Future<List<NotificationWithUser>> getNotificationsForUserWithInfo(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('notifications')
          .where('user_id', isEqualTo: userId)
          .orderBy('timestamp', descending: true) 
          .get();

      List<NotificationWithUser> notifications = [];
      for (DocumentSnapshot doc in querySnapshot.docs) {
        Notification notification = Notification.fromJson(doc.data() as Map<String, dynamic>);
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          User user = User.fromDocument(userDoc);
          notifications.add(NotificationWithUser(notification: notification, user: user));
        }
      }

      return notifications;
    } catch (error) {
      print(error.toString());
      throw Exception('Failed to get notifications with info');
    }
  }
}

class NotificationWithUser {
  final Notification notification;
  final User user;

  NotificationWithUser({required this.notification, required this.user});
}
