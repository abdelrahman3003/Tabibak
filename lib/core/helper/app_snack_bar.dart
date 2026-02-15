import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showErrorSnackBar(String message) {
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.grey,
    ),
  );
}
