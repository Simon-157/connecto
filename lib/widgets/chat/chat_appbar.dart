import 'package:connecto/models/user_model.dart';
import 'package:connecto/services/chat_service.dart';
import 'package:connecto/utils/constants.dart';
import 'package:flutter/material.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String receiverId;
  final ChatService chatService;

  ChatAppBar(this.receiverId, this.chatService, {super.key});

  @override
  _ChatAppBarState createState() => _ChatAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ChatAppBarState extends State<ChatAppBar> {
  late Future<UserModel?> receiverFuture;

  @override
  void initState() {
    super.initState();
    receiverFuture = widget.chatService.getUser(widget.receiverId);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: FutureBuilder<UserModel?>(
        future: receiverFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...', style: TextStyle(color: Colors.white));
          } else if (snapshot.hasError) {
            return const Text('Error', style: TextStyle(color: Colors.white));
          } else if (!snapshot.hasData) {
            return const Text('User not found', style: TextStyle(color: Colors.white));
          } else {
            final receiverName = snapshot.data?.name ?? '';
            return Text('Chat $receiverName', style: const TextStyle(color: Colors.white));
          }
        },
      ),
      backgroundColor: Constants.accentColor,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }
}
