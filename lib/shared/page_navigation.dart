import 'package:connecto/screens/chat/chat_screen.dart';
import 'package:connecto/screens/explore/location_explore.dart';
import 'package:connecto/screens/jobs/jobs_feed.dart';
import 'package:connecto/screens/sessions/schedule_screen.dart';
import 'package:connecto/shared/bottom_snake_bar.dart';
import 'package:flutter/material.dart';

class PageNavigation extends StatefulWidget {
  @override
  _PageNavigationState createState() => _PageNavigationState();
}

class _PageNavigationState extends State<PageNavigation> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children:  <Widget>[
          JobFeedScreen(),
          LocationExploreScreen(),
          Center(child: Text('Add New Page')),
          CalendarScreen(),
          ChatScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
