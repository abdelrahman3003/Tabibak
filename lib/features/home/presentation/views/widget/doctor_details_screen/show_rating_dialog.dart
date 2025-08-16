import 'package:flutter/material.dart';

void showRatingDialog(BuildContext context) {
  double rating = 2;
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("قيّم الدكتور"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => IconButton(
                icon: Icon(
                  Icons.star,
                  color: index < rating ? Colors.amber : Colors.grey,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("إلغاء"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("إرسال"),
        ),
      ],
    ),
  );
}
