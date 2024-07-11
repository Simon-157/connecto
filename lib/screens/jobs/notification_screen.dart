import 'package:connecto/models/notification_model.dart';
import 'package:connecto/services/notification_service.dart';
import 'package:connecto/widgets/notification/notification_item.dart';
import 'package:flutter/material.dart';


class NotificationListWidget extends StatefulWidget {
  final String userId;

  const NotificationListWidget({Key? key, required this.userId}) : super(key: key);

  @override
  _NotificationListWidgetState createState() => _NotificationListWidgetState();
}

class _NotificationListWidgetState extends State<NotificationListWidget> {
  late Future<List<NotificationModel>> _notificationsFuture;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _notificationService.getNotificationsByUserId(widget.userId);
  }

  void _markAsRead(String notificationId) async {
    await _notificationService.markNotificationAsRead(notificationId);
    setState(() {
      _notificationsFuture = _notificationService.getNotificationsByUserId(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        
        ),
        title: Text('Notifications', style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Color.fromARGB(34, 154, 224, 224)
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading notifications', style: TextStyle(color: Colors.black54),));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No notifications available', style: TextStyle(color: Colors.black54),  ));
          }

          final notifications = snapshot.data!;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationItemWidget(
                notification: notification,
                onMarkAsRead: () => _markAsRead(notification.notificationId),
              );
            },
          );
        },
      ),
    );
  }
}

