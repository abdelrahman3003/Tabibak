import 'package:flutter/material.dart';

class DetailsItem extends StatelessWidget {
  const DetailsItem({super.key, required this.title, required this.value});
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold)),
      TextSpan(text: " : ", style: Theme.of(context).textTheme.titleLarge),
      TextSpan(text: value, style: Theme.of(context).textTheme.titleLarge)
    ]));
  }
}
