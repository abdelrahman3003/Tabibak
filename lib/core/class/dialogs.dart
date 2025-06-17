import 'package:flutter/material.dart';

class Dialogs {
  static authErrorDialog(BuildContext context, String? error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("خطأ"),
          content: Text(error ?? "حدث خطأ غير معروف"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("حسنًا"),
            ),
          ],
        );
      },
    );
  }
}
