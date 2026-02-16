import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';

class RatingsRow extends StatelessWidget {
  const RatingsRow({super.key, required this.rate, this.ratingCount});
  final double? rate;
  final int? ratingCount;
  @override
  Widget build(BuildContext context) {
    return rate == null
        ? SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    color: index < rate! ? Colors.amber : Colors.grey,
                    size: 20,
                  ),
                ),
              ),
              5.wBox,
              Text(
                "( $ratingCount ${ratingCount == 1 ? AppStrings.rating : AppStrings.ratings} ) ",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(),
              )
            ],
          );
  }
}
