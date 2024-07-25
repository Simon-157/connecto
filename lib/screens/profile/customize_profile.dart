import 'package:connecto/models/user_model.dart';
import 'package:connecto/services/auth_service.dart';
import 'package:connecto/widgets/profile/update_demo.dart';
import 'package:connecto/widgets/profile/update_general_info.dart';
import 'package:connecto/widgets/profile/update_skills.dart';
import 'package:flutter/material.dart';


class ProfileCustomizationScreen extends StatefulWidget {
  final String userId;
  const ProfileCustomizationScreen({super.key, required this.userId});

  @override
  _ProfileCustomizationScreenState createState() => _ProfileCustomizationScreenState();
}

class _ProfileCustomizationScreenState extends State<ProfileCustomizationScreen> {
  int _currentStep = 0;
  final AuthService _authService = AuthService();
  UserModel? userProfile;
  
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }
  
  Future<void> _loadUserProfile() async {
    try {
      UserModel user = await _authService.getUserById(widget.userId);
      if (mounted) {
        setState(() {
          userProfile = user;
        });
      }
    } catch (e) {
      print("Error loading user profile: $e");
    }
  }

  void _onStepContinue() {
    if (_currentStep < 2 && _isCurrentStepValid()) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      _uploadProfileData();
    }
  }

  bool _isCurrentStepValid() {
    switch (_currentStep) {
      case 0:
        return userProfile?.bio?.isNotEmpty ?? false;
      case 1:
        return userProfile?.skills?.isNotEmpty ?? false;
      case 2:
        return userProfile?.demos?.isNotEmpty ?? false;
      default:
        return false;
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  Future<void> _uploadProfileData() async {
    try {
      if (userProfile != null) {
       

        await _authService.updateUserDetails(widget.userId, {
          'address': userProfile!.address,
          'bio': userProfile!.bio,
          'profilePicture': userProfile!.profilePicture,
          'skills': userProfile!.skills?.map((skill) => {
            'name': skill.name,
            'level': skill.level,
            'proficiency': skill.proficiency,
          }).toList(),
          'demos': userProfile!.demos?.map((demo) => {
            'title': demo.title,
            'description': demo.description,
            'videoUrl': demo.videoUrl,
            'thumbnailUrl': demo.thumbnailUrl,
            'views': demo.views,
            'timeAgo': demo.timeAgo,
          }).toList(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading profile data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Profile Customization', style: TextStyle(color: Colors.black)),
      ),
      body: userProfile == null
          ? const Center(child: CircularProgressIndicator())
          : Stepper(
              currentStep: _currentStep,
              onStepContinue: _onStepContinue,
              onStepCancel: _onStepCancel,
              steps: [
                Step(
                  title: const Text('General Info', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 16),),
                  isActive: _currentStep >= 0,
                  state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                  content: UpdateGeneralInfoScreen(userProfile: userProfile!),
                ),
                Step(
                  title: const Text('Skills', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 16),),
                  isActive: _currentStep >= 1,
                  state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                  content: UpdateSkillsScreen(userProfile: userProfile!),
                ),
                Step(
                  title: const Text('Demo', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 16),),
                  isActive: _currentStep >= 2,
                  state: _currentStep >= 2 ? StepState.complete : StepState.indexed,
                  content: UpdateDemoScreen(userProfile: userProfile!),
                ),
              ],
            ),
    );
  }
}
