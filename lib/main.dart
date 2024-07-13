import 'package:connecto/screens/auth/login_screen.dart';
import 'package:connecto/screens/auth/register_screen.dart';
import 'package:connecto/screens/onboarding/splash_screen.dart';
import 'package:connecto/screens/sessions/create_schedule_screen.dart';
import 'package:connecto/services/notification_service.dart';
import 'package:connecto/shared/page_navigation.dart';
import 'package:connecto/utils/ui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();

  runApp(ConnectoApp());
}

class ConnectoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connecto',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 40, 218, 164),
        hintColor: Colors.grey,
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            error: Colors.red,
            onError: Colors.red,
            onPrimary: Colors.white,
            onSecondary: Color.fromARGB(255, 40, 218, 164),
            onSurface: Colors.white,
            primary: Color.fromARGB(255, 40, 218, 164),
            secondary: Colors.white,
            surface: Colors.white),
      ),
      home: SplashScreen(),
      routes: {
        '/home':(context) => PageNavigation(),
        '/login': (context) => LoginScreen(),
        '/register': (context) =>  RegisterScreen(),
        '/create-session': (context) =>  CreateSessionScreen(),
      },
    );
  }
}
