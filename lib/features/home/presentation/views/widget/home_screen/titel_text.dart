import 'package:flutter/material.dart';

class TitelText extends StatelessWidget {
  const TitelText({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.headlineSmall);
  }
}
