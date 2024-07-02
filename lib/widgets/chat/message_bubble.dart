import 'package:connecto/models/media_model.dart';
import 'package:connecto/models/message_model.dart';
import 'package:connecto/utils/chat_styles.dart';
import 'package:connecto/widgets/chat/media_preview.dart';
import 'package:flutter/material.dart';


class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: Styles.messageMargin,
        padding: Styles.messagePadding,
        decoration: BoxDecoration(
          color: isMe ? Colors.teal[200] : Colors.grey[300],
          borderRadius: isMe ? Styles.messageBubbleRadiusMe : Styles.messageBubbleRadiusOther,
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message.media != null)
              MediaPreview(media: Media.fromDocumentReference(message.media!)),
            Text(
              message.content,
              style: Styles.messageTextStyle.copyWith(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
