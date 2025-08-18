import 'package:flutter/material.dart';

class RatingsRow extends StatelessWidget {
  const RatingsRow({super.key, required this.rate});
  final double? rate;
  @override
  Widget build(BuildContext context) {
    return rate == null
        ? SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                color: index < rate! ? Colors.amber : Colors.grey,
                size: 20,
              ),
            ),
          );
  }
}
