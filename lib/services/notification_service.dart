import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecto/models/notification_model.dart';

class NotificationService {
  final CollectionReference _notificationsCollection = FirebaseFirestore.instance.collection('notifications');

  // Create a new notification
  Future<void> createNotification(NotificationModel notification) async {
    try {
      await _notificationsCollection.doc(notification.notificationId).set(notification.toJson());
    } catch (e) {
      print('Error creating notification: $e');
      throw e;
    }
  }

  // Retrieve a notification by ID
  Future<NotificationModel?> getNotificationById(String notificationId) async {
    try {
      DocumentSnapshot doc = await _notificationsCollection.doc(notificationId).get();
      if (doc.exists) {
        return NotificationModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error retrieving notification: $e');
      throw e;
    }
  }

  // Retrieve all notifications for a specific user
  Future<List<NotificationModel>> getNotificationsByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _notificationsCollection.where('user_id', isEqualTo: userId).get();
      return querySnapshot.docs.map((doc) => NotificationModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error retrieving notifications: $e');
      throw e;
    }
  }

  // Update a notification
  Future<void> updateNotification(NotificationModel notification) async {
    try {
      await _notificationsCollection.doc(notification.notificationId).update(notification.toJson());
    } catch (e) {
      print('Error updating notification: $e');
      throw e;
    }
  }

  // Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).delete();
    } catch (e) {
      print('Error deleting notification: $e');
      throw e;
    }
  }

  // Mark a notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).update({'is_read': true});
    } catch (e) {
      print('Error marking notification as read: $e');
      throw e;
    }
  }

  // Mark all notifications for a user as read
  Future<void> markAllNotificationsAsRead(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _notificationsCollection.where('user_id', isEqualTo: userId).get();
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        batch.update(doc.reference, {'is_read': true});
      }

      await batch.commit();
    } catch (e) {
      print('Error marking all notifications as read: $e');
      throw e;
    }
  }
}
