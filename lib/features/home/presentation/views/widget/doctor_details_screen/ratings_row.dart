import 'package:flutter/material.dart';

class RatingsRow extends StatelessWidget {
  const RatingsRow({super.key, required this.rate});
  final double rate;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => Icon(
          Icons.star,
          color: index < (2 ?? 0).round() ? Colors.amber : Colors.grey,
          size: 20,
        ),
      ),
    );
  }
}
