import 'dart:async';
import 'dart:io';
import 'package:connecto/models/notification_model.dart';
import 'package:connecto/services/chat_service.dart';
import 'package:connecto/services/notification_service.dart';
import 'package:connecto/utils/ui.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class MessageInput extends StatefulWidget {
  final String userId;
  final String receiverId;
final FocusNode? chatFocusNode;

  const MessageInput({super.key, required this.userId, required this.receiverId, this.chatFocusNode});

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  final NotificationService _notificationService = NotificationService();
  String? _mediaPath;
  String? _mediaType;
  final picker = ImagePicker();

  FlutterSoundRecorder? _audioRecorder;
  bool _isRecording = false;
  String? _audioPath;
  late DateTime _recordingStart;
  late Timer _timer;
  String _recordingDuration = '00:00';

  @override
  void initState() {
    super.initState();
    _audioRecorder = FlutterSoundRecorder();
    _initializeRecorder();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioRecorder?.closeRecorder();
    super.dispose();
  }

  Future<void> _initializeRecorder() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) {
        throw Exception('Microphone permission not granted');
      }
    }
    await _audioRecorder!.openRecorder();
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty && _mediaPath == null && _audioPath == null) {
      return;
    }
    _chatService.sendMessage(
      senderId: widget.userId,
      receiverId: widget.receiverId,
      content: _controller.text,
      filePath: _mediaPath ?? _audioPath,
      fileType: _mediaType ?? 'audio',
    );
    // if successful
    // create notification
    await _notificationService.createNotification(
      NotificationModel(userId: widget.receiverId,
      senderId: widget.userId,
      type: 'new_message',
      message: _controller.text, notificationId: '${DateTime.now().millisecondsSinceEpoch}', timestamp: DateTime.now(),)
    );

    _controller.clear();
    setState(() {
      _mediaPath = null;
      _mediaType = null;
      _audioPath = null;
    });

    scrollDown();
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

  Future<void> _takePicture() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _mediaPath = pickedFile.path;
        _mediaType = 'image';
      });
    }
  }

  Future<void> _pickVideo() async {
    final XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _mediaPath = pickedFile.path;
        _mediaType = 'video';
      });
    }
  }

  Future<void> _startRecording() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) {
        print('Microphone permission not granted');
        return;
      }
    }
    try {
      final directory = await getApplicationDocumentsDirectory();
      _audioPath = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
      await _audioRecorder!.startRecorder(
        toFile: _audioPath,
        codec: Codec.aacADTS,
      );
      _recordingStart = DateTime.now();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final duration = DateTime.now().difference(_recordingStart);
        setState(() {
          _recordingDuration = DateFormat('mm:ss').format(DateTime(0).add(duration));
        });
      });
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print('Error starting recorder: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _audioRecorder!.stopRecorder();
      _timer.cancel();
      setState(() {
        _isRecording = false;
        _recordingDuration = '00:00';
      });
    } catch (e) {
      print('Error stopping recorder: $e');
    }
  }

  void _recordAudio() {
    if (_isRecording) {
      _stopRecording();
      _showMediaPreview(context);
    } else {
      _startRecording();
    }
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
                    leading: const Icon(Icons.camera_alt, color: Colors.teal),
                    title: const Text('Take Picture'),
                    onTap: () async {
                      await _takePicture();
                      _showMediaPreview(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.videocam, color: Colors.teal),
                    title: const Text('Pick Video'),
                    onTap: () async {
                      await _pickVideo();
                      _showMediaPreview(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.image, color: Colors.teal),
                    title: const Text('Pick Image'),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _mediaPath != null || _audioPath != null
                  ? Row(
                      children: [
                        _buildMediaIcon(),
                        const SizedBox(width: 8.0),
                        Text(
                          _getFileNameFromPath(_mediaPath ?? _audioPath!),
                          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    )
                  : Container(),
              const SizedBox(height: 16.0),
              _buildMediaPreview(),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context); // Close preview
                  await _sendMessage();
                },
                child: const Text('Send'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMediaIcon() {
    IconData iconData;
    if (_mediaType == 'video') {
      iconData = Icons.videocam;
    } else if (_mediaType == 'audio') {
      iconData = Icons.audiotrack;
    } else {
      iconData = Icons.image;
    }
    return Icon(iconData, size: 48.0);
  }

  Widget _buildMediaPreview() {
    if (_mediaPath == null && _audioPath == null) {
      return Container();
    }

    if (_mediaType == 'video') {
      return const Text('Video Preview Placeholder');
    } else if (_mediaType == 'audio') {
      return const Text('Audio Preview Placeholder');
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            iconSize: 18.0,
            icon: const Icon(Icons.attach_file, color: Colors.teal),
            onPressed: _pickMedia,
          ),
          IconButton(
            iconSize: 18.0,
            icon: Icon(_isRecording ? Icons.stop : Icons.mic, color: Colors.teal),
            onPressed: _recordAudio,
          ),
          if (_isRecording)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                _recordingDuration,
                style: const TextStyle(color: Colors.red, fontSize: 16.0),
              ),
            ),
          IconButton(
            iconSize: 18.0,
            icon: const Icon(Icons.add, color: Colors.teal),
            onPressed: _showMediaOptions,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                focusNode: chatFocusNode,
                style: const TextStyle(color: Colors.black, fontSize: 16.0),
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) async => await _sendMessage(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.teal),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
