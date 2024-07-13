import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecto/models/notification_model.dart';
import 'package:connecto/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final CollectionReference _notificationsCollection = FirebaseFirestore.instance.collection('notifications');
  final AuthService _authService = AuthService();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await Firebase.initializeApp();
    // const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    // final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    // await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final String? token = await _firebaseMessaging.getToken();
    print('token: $token');
    await _authService.updateUserToken(token!);

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpened);
    Future<void> _handleBackgroundMessage(RemoteMessage message) async {
      _handleNotification(message);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    if (message.notification != null) {
      _showNotification(message);
    }
  }

   void _handleBackgroundMessage(RemoteMessage message) async {
    _handleNotification(message);
  }

  void _handleNotificationOpened(RemoteMessage message) {
    _handleNotification(message);
  }

  void _handleNotification(RemoteMessage message) {
    switch (message.data['type']) {
      case 'connection_request':
        // Handle connection request
        break;
      case 'connection_acceptance':
        // Handle connection acceptance
        break;
      case 'new_message':
        // Handle new message
        break;
      default:
        break;
    }
  }

  void _showNotification(RemoteMessage message) {
    _flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title,
      message.notification!.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> createNotification(NotificationModel notification) async {
    try {
      await _notificationsCollection.doc(notification.notificationId).set(notification.toJson());
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  Future<NotificationModel?> getNotificationById(String notificationId) async {
    try {
      final DocumentSnapshot doc = await _notificationsCollection.doc(notificationId).get();
      return doc.exists ? NotificationModel.fromJson(doc.data() as Map<String, dynamic>) : null;
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  Future<List<NotificationModel>> getNotificationsByUserId(String userId) async {
    try {
      final QuerySnapshot querySnapshot = await _notificationsCollection.where('user_id', isEqualTo: userId).get();
      return querySnapshot.docs.map((doc) => NotificationModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  Future<void> updateNotification(NotificationModel notification) async {
    try {
      await _notificationsCollection.doc(notification.notificationId).update(notification.toJson());
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).delete();
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).update({'is_read': true});
    } on FirebaseException catch (e) {
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
