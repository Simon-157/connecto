import 'package:connecto/models/message_model.dart';
import 'package:connecto/services/chat_service.dart';
import 'package:connecto/utils/ui.dart';
import 'package:connecto/widgets/chat/chat_appbar.dart';
import 'package:connecto/widgets/chat/message_bubble.dart';
import 'package:connecto/widgets/chat/message_input.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String receiverId;

  const ChatScreen({super.key, required this.userId, required this.receiverId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    chatFocusNode.addListener(() {
      if (chatFocusNode.hasFocus) {
        //TODO:  mark message as read

        // cause delay for mounting
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    // scroll down on initial listview 
    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());

  }

  @override
  void dispose() {
    // chatFocusNode.dispose();
    chatController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(widget.receiverId, _chatService),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream:
                  _chatService.getMessages(widget.userId, widget.receiverId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No messages yet',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)));
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(
                      child: Text('Something went wrong',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)));
                }
                List<Message> messages = snapshot.data!;
                return ListView.builder(
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      message: messages[index],
                      isMe: messages[index].senderId == widget.userId,
                    );
                  },
                );
              },
            ),
          ),
          MessageInput(
            userId: widget.userId,
            receiverId: widget.receiverId,
            chatFocusNode: chatFocusNode,
          ),
        ],
      ),
    );
  }
}
