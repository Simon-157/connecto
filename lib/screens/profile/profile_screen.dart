import 'package:connecto/screens/profile/customize_profile.dart';
import 'package:connecto/utils/dummy.dart';
import 'package:connecto/widgets/profile/demo_widget.dart';
import 'package:connecto/widgets/profile/profile_widgets.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({super.key, required this.userId});
  
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return const Center(
          child: Text(
            'Applications Tab Content',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
        );
      case 1:
        return ListView(
          children: userProfile.skills.map((skill) => SkillCard(skill: skill)).toList(),
        );
      case 2:
        return ListView(
          children: userProfile.demos.map((demo) => DemoCard(demo: demo)).toList(),
        );
      default:
        return const Center(
          child: Text(
            'Unknown Tab',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
        );
    }
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'profile':
        // Navigate to profile settings 
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileCustomizationScreen(userId: widget.userId,)));
        break;
      case 'logout':
        // Handle logout action
        break;
      case 'privacy':
        // Navigate to privacy settings screen or handle accordingly
        break;
      case 'other':
        // Navigate to other settings screen or handle accordingly
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {
          Navigator.pop(context);
        }),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            onSelected: _onMenuSelected,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'profile',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4.0)],
                    ),
                    child: const ListTile(
                      leading: Icon(Icons.person, color: Colors.black54),
                      title: Text('Customize Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4.0)],
                    ),
                    child: const ListTile(
                      leading: Icon(Icons.logout, color: Colors.black54),
                      title: Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'privacy',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4.0)],
                    ),
                    child: const ListTile(
                      leading: Icon(Icons.privacy_tip, color: Colors.black54),
                      title: Text('Privacy Settings', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'other',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4.0)],
                    ),
                    child: const ListTile(
                      leading: Icon(Icons.settings, color: Colors.black54),
                      title: Text('Other Settings', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                    ),
                  ),
                ),
              ];
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4,
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          UserProfileHeader(profile: userProfile),
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: const [
              Tab(text: 'Applications'),
              Tab(text: 'Skills'),
              Tab(text: 'Demos'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent(0),
                _buildTabContent(1),
                _buildTabContent(2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
