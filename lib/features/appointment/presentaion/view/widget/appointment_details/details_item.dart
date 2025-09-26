import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18.sp)),
      TextSpan(
          text: " : ",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: 18.sp)),
      TextSpan(
          text: value,
          style:
              Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16.sp))
    ]));
  }
}
