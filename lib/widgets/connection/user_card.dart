import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String userId;
  final String name;
  final String profileImageUrl;
  final bool isConnected;
  final bool canMessage;
  final VoidCallback onConnect;
  final VoidCallback onMessage;

  UserCard({
    required this.userId,
    required this.name,
    required this.profileImageUrl,
    this.isConnected = false,
    this.canMessage = false,
    required this.onConnect,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!isConnected)
                        IconButton(
                          icon: Icon(Icons.person_add),
                          onPressed: onConnect,
                        )
                      else if (canMessage)
                        IconButton(
                          icon: Icon(Icons.message),
                          onPressed: onMessage,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
