import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
FocusNode chatFocusNode = FocusNode();
final TextEditingController chatController = TextEditingController();
final ScrollController scrollController = ScrollController();

void showSnackbar(BuildContext context, String message) {
  final snackBar = 
    
  
    SnackBar(
      content: Text(message, style: const TextStyle(fontSize: 16, color: Colors.white)),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: const Color.fromARGB(255, 96, 201, 101),
    );
  

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
}




  void scrollDown() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastOutSlowIn,
      );
    }
  }