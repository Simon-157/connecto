import 'package:connecto/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MessageInput extends StatefulWidget {
  final String userId;
  final String receiverId;

  MessageInput({required this.userId, required this.receiverId});

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  String? _mediaPath;
  String? _mediaType;
  final picker = ImagePicker();

  void _sendMessage() {
    if (_controller.text.isEmpty && _mediaPath == null) {
      return;
    }
    _chatService.sendMessage(
      senderId: widget.userId,
      receiverId: widget.receiverId,
      content: _controller.text,
      filePath: _mediaPath,
      fileType: _mediaType,
    );
    _controller.clear();
    setState(() {
      _mediaPath = null;
      _mediaType = null;
    });
  }

  Future<void> _pickMedia() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _mediaPath = pickedFile.path;
        _mediaType = 'image';
      });
    }
  }

  void _recordAudio() {
    // TODO: audio recording functionality
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.teal),
            onPressed: _pickMedia,
          ),
          IconButton(
            icon: Icon(Icons.mic, color: Colors.teal),
            onPressed: _recordAudio,
          ),
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.teal),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
