import 'package:connecto/screens/auth/login_screen.dart';
import 'package:connecto/services/auth_service.dart';
import 'package:connecto/shared/page_navigation.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  AuthService _authService = AuthService();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void onSkip() {
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void onNext() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void onGetStarted() {
    if (_authService.getCurrentUser() != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PageNavigation()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple, Colors.blue],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: onPageChanged,
              children: [
                buildPage(
                  image: 'assets/images/onboarding1.png', 
                  title: 'Join Us & Explore Thousand',
                  subtitle: 'of Great Job',
                ),
                buildPage(
                  image: 'assets/images/onboarding1.png',
                  title: 'Find Mentors Easily',
                  subtitle: 'Connect with professionals in your field',
                ),
                buildPage(
                  image: 'assets/images/onboarding1.png', 
                  title: 'Kickstart Your Career',
                  subtitle: 'Get job offers and internships',
                  isLastPage: true,
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) => buildDot(index)),
              ),
            ),
            Positioned(
              bottom: 80,
              child: currentIndex != 2
                  ? ElevatedButton(
                      onPressed: onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent, 
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      ),
                      child: const Text('Next', style: TextStyle(color: Colors.white),),
                    )
                  : ElevatedButton(
                      onPressed: onGetStarted,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent, 
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      ),
                      child: Text(_authService.getCurrentUser()!=null ? 'Continue' : 'Get Started', style: TextStyle(color: Colors.white),),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget buildPage({required String image, required String title, required String subtitle, bool isLastPage = false}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    
        Text(
          'Welcome ${_authService.getCurrentUser()!=null ? 'back ${_authService.getCurrentUser()?.displayName }' : 'New User'}',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.greenAccent,
            fontWeight: FontWeight.bold
          ),
        ),
      
      Image.asset(image, height: 300),
      const SizedBox(height: 20),

      Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        subtitle,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    
    ],
  );
}


  Widget buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: currentIndex == index ? 12 : 8,
      height: currentIndex == index ? 12 : 8,
      decoration: BoxDecoration(
        color: currentIndex == index ? Colors.cyan : Colors.grey,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
