import 'package:flutter/material.dart';

class Constants {
  // API Endpoints
  static const String baseUrl = 'https://api.app.com';
  static const String loginEndpoint = '$baseUrl/auth/login';
  static const String registerEndpoint = '$baseUrl/auth/register';
  static const String jobsEndpoint = '$baseUrl/jobs';
  static const String favoritesEndpoint = '$baseUrl/favorites';

  // App Colors
  static const Color primaryColor = Color.fromARGB(255, 34, 35, 36);
  static const Color accentColor = Color.fromARGB(255,62, 234, 224);
  static const Color backgroundColor = Color(0xFFF6F6F6);
  static const Color textColor = Color.fromARGB(255, 32, 32, 32);
  static const Color secondaryBodyTextColor = Color.fromARGB(255, 255, 255, 255);
  static const Color hintColor = Color.fromARGB(255, 98, 98, 99);
  static const Color secondaryTextColor = Color(0xFF757575);
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color errorColor = Color(0xFFB00020);
  static const Color greyColor = Color.fromARGB(213, 82, 82, 82);
  static const Color appTextBlue =  Color.fromARGB(255, 0, 63, 238);
  static const Color highlight =   Color.fromARGB(26, 0, 63, 238);



  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

   static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  
  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textColor,
  );

  static const TextStyle secondaryBodyText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: secondaryBodyTextColor,
  );

  static const TextStyle captionText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: secondaryTextColor,
  );

  // Padding and Margin
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  static const double marginSmall = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;

  // Other Constants
  static const String appName = 'Ticketron';
  static const String defaultProfilePicture = 'assets/images/default_profile_picture.png';
  static const double borderRadius = 8.0;

  // Error Messages
  static const String networkError = 'Network error. Please try again later.';
  static const String unknownError = 'An unknown error occurred. Please try again.';

  // button text
    static const TextStyle buttonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
}


class CustomIcons {
  static const String logo = 'icons/logo.svg';
  static const String apple = 'icons/apple.svg';
  static const String barcode = 'icons/barcode.svg';
  static const String calendarDays = 'icons/calendar-days.svg';
  static const String calendarPlus = 'icons/calendar-plus.svg';
  static const String check = 'icons/check.svg';
  static const String chevronRight = 'icons/chevron-right.svg';
  static const String circleAlert = 'icons/circle-alert.svg';
  static const String circleUser = 'icons/circle-user.svg';
  static const String clock = 'icons/clock.svg';
  static const String download = 'icons/download.svg';
  static const String edit = 'icons/edit.svg';
  static const String eyeOff = 'icons/eye-off.svg';
  static const String eyeOpen = 'icons/eye-open.svg';
  static const String globe = 'icons/globe.svg';
  static const String google = 'icons/google.svg';
  static const String heart = 'icons/heart.svg';
  static const String home = 'icons/home.svg';
  static const String instagram = 'icons/instagram.svg';
  static const String lightbulb = 'icons/lightbulb.svg';
  static const String location = 'icons/location.svg';
  static const String mail = 'icons/mail.svg';
  static const String menuBars = 'icons/menu-bars.svg';
  static const String menuHorizontal = 'icons/menu-horizontal.svg';
  static const String menuVertical = 'icons/menu-vertical.svg';
  static const String password = 'icons/password.svg';
  static const String phone = 'icons/phone.svg';
  static const String qrCode = 'icons/qr-code.svg';
  static const String search = 'icons/search.svg';
  static const String settings = 'icons/settings.svg';
  static const String share2 = 'icons/share-2.svg';
  static const String share = 'icons/share.svg';
  static const String ticket = 'icons/ticket.svg';
  static const String twitter = 'icons/twitter.svg';
  static const String video = 'icons/video.svg';
  static const String notification = 'icons/notification.svg';

  static const String paypal = 'icons/paypal.svg';



}