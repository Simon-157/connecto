import 'package:connecto/utils/dummy.dart';
import 'package:connecto/widgets/profile/profile_widgets.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
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
        return Center(child: Text('Applications Tab Content'));
      case 1:
        return ListView(
          children: userProfile.skills.map((skill) => SkillCard(skill: skill)).toList(),
        );
      case 2:
        return ListView(
          children: userProfile.demos.map((demo) => DemoCard(demo: demo)).toList(),
        );
      default:
        return Center(child: Text('Unknown Tab'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
        actions: [IconButton(icon: Icon(Icons.settings), onPressed: () {})],
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
            tabs: [
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
