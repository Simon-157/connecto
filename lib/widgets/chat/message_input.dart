import 'dart:io';

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
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _mediaPath = pickedFile.path;
        _mediaType = 'image';
      });
    }
  }

  Future<void> _takePicture() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _mediaPath = pickedFile.path;
        _mediaType = 'image';
      });
    }
  }

  Future<void> _pickVideo() async {
    final XFile? pickedFile =
        await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _mediaPath = pickedFile.path;
        _mediaType = 'video';
      });
    }
  }

  void _recordAudio() {
    // TODO: audio recording functionality
  }

  void _showMediaOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SafeArea(
              child: Wrap(
                children: [
                  ListTile(
                    leading: Icon(Icons.camera_alt, color: Colors.teal),
                    title: Text('Take Picture'),
                    onTap: () async {
                      await _takePicture();
                      _showMediaPreview(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.videocam, color: Colors.teal),
                    title: Text('Pick Video'),
                    onTap: () async {
                      await _pickVideo();
                      _showMediaPreview(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.image, color: Colors.teal),
                    title: Text('Pick Image'),
                    onTap: () async {
                      await _pickMedia();
                      _showMediaPreview(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showMediaPreview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _mediaPath != null
                  ? Row(
                      children: [
                        _buildMediaIcon(),
                        SizedBox(width: 8.0),
                        Text(
                          _getFileNameFromPath(_mediaPath!),
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(height: 16.0),
              _buildMediaPreview(),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {

                  Navigator.pop(context); // Close preview
                   _sendMessage();
                },
                child: Text('Send'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMediaIcon() {
    IconData iconData = _mediaType == 'video' ? Icons.videocam : Icons.image;
    return Icon(iconData, size: 48.0);
  }

  Widget _buildMediaPreview() {
    if (_mediaPath == null) {
      return Container();
    }

    if (_mediaType == 'video') {
      return Text('Video Preview Placeholder');
    } else {
      return Image.file(
        File(_mediaPath!),
        width: 200.0,
        height: 200.0,
        fit: BoxFit.cover,
      );
    }
  }

  String _getFileNameFromPath(String path) {
    return path.split('/').last;
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            iconSize: 18.0,
            icon: Icon(Icons.attach_file, color: Colors.teal),
            onPressed: _pickMedia,
          ),
          IconButton(
            iconSize: 18.0,
            icon: Icon(Icons.mic, color: Colors.teal),
            onPressed: _recordAudio,
          ),
          IconButton(
            iconSize: 18.0,
            icon: Icon(Icons.add, color: Colors.teal),
            onPressed: _showMediaOptions,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
