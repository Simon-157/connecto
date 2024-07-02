import 'package:flutter/material.dart';

class Styles {
  static const TextStyle messageTextStyle = TextStyle(
    fontSize: 16.0,
  );

  static const BoxDecoration messageBubbleDecoration = BoxDecoration(
    color: Colors.teal,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  );

  static const EdgeInsets messagePadding = EdgeInsets.all(10.0);

  static const EdgeInsets messageMargin = EdgeInsets.symmetric(
    vertical: 5.0,
    horizontal: 10.0,
  );

  static const BorderRadius messageBubbleRadiusMe = BorderRadius.only(
    topLeft: Radius.circular(12.0),
    topRight: Radius.circular(12.0),
    bottomLeft: Radius.circular(12.0),
  );

  static const BorderRadius messageBubbleRadiusOther = BorderRadius.only(
    topLeft: Radius.circular(12.0),
    topRight: Radius.circular(12.0),
    bottomRight: Radius.circular(12.0),
  );
}
