import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecto/models/media_model.dart';
import 'package:connecto/models/message_model.dart';
import 'package:connecto/models/user_model.dart';
import 'package:connecto/services/chat_service.dart';
import 'package:connecto/widgets/chat/media_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final bool isMe;

  const MessageBubble({required this.message, required this.isMe, Key? key}) : super(key: key);

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  late Future<UserModel?> senderFuture;
  late Future<Media?> mediaFuture;

  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    senderFuture = _chatService.getUser(widget.message.senderId);
    if (widget.message.media != null) {
      mediaFuture = Media.fromDocumentReference(widget.message.media as DocumentReference<Map<String, dynamic>>);
    } else {
      mediaFuture = Future.value(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: widget.isMe ? Color.fromARGB(69, 50, 196, 233) : Colors.grey[200],
          borderRadius: widget.isMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: FutureBuilder<UserModel?>(
          future: senderFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return const Text('User not found');
            } else {
              final sender = snapshot.data!;
              return Column(
                crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (!widget.isMe)
                        CircleAvatar(
                          backgroundImage: sender.profilePicture != null
                              ? NetworkImage(sender.profilePicture)
                              : SvgPicture.asset('assets/icons/avatar.svg') as ImageProvider<Object>,
                          radius: 15.0,
                        ),
                      const SizedBox(width: 8.0),
                      Text(
                        widget.isMe ? 'You' : '@${sender.email.split('@')[0]}',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: widget.isMe ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  if (widget.message.media != null)
                    FutureBuilder<Media?>(
                      future: mediaFuture,
                      builder: (context, mediaSnapshot) {
                        if (mediaSnapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (mediaSnapshot.hasError) {
                          return Text('Error: ${mediaSnapshot.error}');
                        } else if (!mediaSnapshot.hasData) {
                          return const Text('Media not found');
                        } else {
                          final media = mediaSnapshot.data!;
                          return MediaPreview(media: media);
                        }
                      },
                    ),
                  Text(
                    widget.message.content,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: widget.isMe ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat('h:mm a').format(widget.message.timestamp.toDate()),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
