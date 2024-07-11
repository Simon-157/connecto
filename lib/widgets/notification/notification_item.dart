import 'package:connecto/models/notification_model.dart';
import 'package:connecto/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onMarkAsRead;

  const NotificationItemWidget({
    super.key,
    required this.notification,
    required this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: notification.isRead ? 2.0 : 5.0,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Icon(
          notification.isRead ? Icons.notifications : Icons.notifications_active,
          color: notification.isRead ? Colors.grey :  Constants.accentColor,
        ),
        title: Text(
          notification.type,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: notification.isRead ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4.0),
            Text(
              notification.message,
              style: TextStyle(
                color: notification.isRead ? Colors.grey : Colors.black87,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              DateFormat.yMMMd().add_jm().format(notification.timestamp),
              style: TextStyle(
                color: notification.isRead ? Colors.grey : Colors.black54,
              ),
            ),
          ],
        ),
        trailing: notification.isRead
            ? null
            : IconButton(
                icon: Icon(Icons.mark_email_read),
                color: Constants.accentColor,
                onPressed: onMarkAsRead,
              ),
      ),
    );
  }
}
