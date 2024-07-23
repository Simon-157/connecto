import 'package:connecto/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UpdateGeneralInfoScreen extends StatefulWidget {
  final UserModel userProfile;

  UpdateGeneralInfoScreen({required this.userProfile});

  @override
  _UpdateGeneralInfoScreenState createState() => _UpdateGeneralInfoScreenState();
}

class _UpdateGeneralInfoScreenState extends State<UpdateGeneralInfoScreen> {
  final _bioController = TextEditingController();
  final _addressController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;

  @override
  void initState() {
    super.initState();
    _bioController.text = widget.userProfile.bio ?? '';
    _addressController.text = widget.userProfile.address;
  }

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = pickedImage;
      widget.userProfile.profilePicture = pickedImage?.path ?? '';
    });
  }

  @override
  void dispose() {
    _bioController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      SizedBox(
        height: 50,
        child: TextField(
        controller: _bioController,
        style: const TextStyle(color: Colors.black54, fontSize: 16),
        decoration: InputDecoration(
          labelText: 'Bio',
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelStyle: TextStyle(color: Colors.greenAccent[200], ),
          labelStyle: TextStyle(color: Colors.grey[700]),
          border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        onChanged: (value) => widget.userProfile.bio = value,
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 50,
        child: TextField(
        controller: _addressController,
        style: const TextStyle(color: Colors.black54, fontSize: 16),
        decoration: InputDecoration(
          labelText: 'Address',
          labelStyle: TextStyle(color: Colors.grey[700]),
                    floatingLabelStyle: TextStyle(color: Colors.greenAccent[200], ),

          border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        onChanged: (value) => widget.userProfile.address = value,
        ),
      ),
        const SizedBox(height: 10),
        _profileImage == null
            ? const Text('No image selected.', style: TextStyle(color: Color.fromARGB(255, 92, 90, 90)))
            : Image.file(File(_profileImage!.path)),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _pickImage,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Pick Profile Image'),
        ),
      ],
    );
  }
}
