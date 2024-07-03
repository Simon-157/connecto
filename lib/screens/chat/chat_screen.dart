import 'package:connecto/models/message_model.dart';
import 'package:connecto/models/user_model.dart';
import 'package:connecto/services/chat_service.dart';
import 'package:connecto/widgets/chat/chat_appbar.dart';
import 'package:connecto/widgets/chat/message_bubble.dart';
import 'package:connecto/widgets/chat/message_input.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String userId; 
  final String receiverId; 
  

  final ChatService _chatService = ChatService();

  ChatScreen({super.key, required this.userId, required this.receiverId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(receiverId, _chatService),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _chatService.getMessages(userId, receiverId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
              
                else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)));
                }

                // else if ((!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty)) {
                //   return const Center(child: Text('Something went wrong', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)));
                // }

                else if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(child: Text('Something went wrong', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold, color: Colors.black87)));
                }
                List<Message> messages = snapshot.data!;
                return ListView.builder(
                  // reverse: true,
                  itemCount: messages.length,
                  itemBuilder:  (context, index) {
                    return MessageBubble(
                      message: messages[index],
                      isMe: messages[index].senderId == userId,
  
                    );
                  },
                );
              },
            ),
          ),
          MessageInput(
            userId: userId,
            receiverId: receiverId,
          ),
        ],
      ),
    );
  }
}