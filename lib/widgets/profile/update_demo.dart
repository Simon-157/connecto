import 'package:connecto/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UpdateDemoScreen extends StatefulWidget {
  final UserModel userProfile;

  const UpdateDemoScreen({super.key, required this.userProfile});

  @override
  _UpdateDemoScreenState createState() => _UpdateDemoScreenState();
}

class _UpdateDemoScreenState extends State<UpdateDemoScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _video;
  XFile? _thumbnail;

  Future<void> _pickVideo() async {
    final pickedVideo = await _picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      _video = pickedVideo;
    });
  }

  Future<void> _pickThumbnail() async {
    final pickedThumbnail = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _thumbnail = pickedThumbnail;
    });
  }

  Future<void> _uploadDemo() async {
    if (_video == null || _thumbnail == null) return;

    final videoUrl = await _uploadFile(_video!);
    final thumbnailUrl = await _uploadFile(_thumbnail!);

    setState(() {
      widget.userProfile.demos?.add(Demo(
        _titleController.text,
        _descriptionController.text,
        videoUrl,
        thumbnailUrl,
        0,
        'Just now',
      ));
    });

    _titleController.clear();
    _descriptionController.clear();
  }

  Future<String> _uploadFile(XFile file) async {
    final ref = FirebaseStorage.instance.ref().child('uploads/${file.name}');
    await ref.putFile(File(file.path));
    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              labelStyle: const TextStyle(color: Colors.black54),
              floatingLabelStyle: TextStyle(color: Colors.greenAccent[200], ),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            style: const TextStyle(color: Colors.black54, fontSize: 16),
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              labelStyle: const TextStyle(color: Colors.black54),
              floatingLabelStyle: TextStyle(color: Colors.greenAccent[200], ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _pickVideo,
            child: const Text('Pick Video'),
          ),
          const SizedBox(height: 10),
          _video == null ? Container() : const Text('Video selected', style: TextStyle(color: Colors.black54, fontSize: 16)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _pickThumbnail,
            child: const Text('Pick Thumbnail'),
          ),
          const SizedBox(height: 10),
          _thumbnail == null ? Container() : const Text('Thumbnail selected', style: TextStyle(color: Colors.black54, fontSize: 16)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _uploadDemo,
            child: const Text('Upload Demo'),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(), 
            itemCount: widget.userProfile.demos?.length ?? 0,
            itemBuilder: (context, index) {
              final demo = widget.userProfile.demos![index];
              return ListTile(
                leading: CircleAvatar(child: Icon(Icons.videocam, color: Colors.blueAccent, size: 24,)),
                title: Text(demo.title, style: TextStyle(color: Colors.black87, fontSize: 18)),
                subtitle: Text(demo.description, style: TextStyle(color: Colors.black54, fontSize: 16)),
              );
            },
          ),
        ],
      ),
    );
  }
}