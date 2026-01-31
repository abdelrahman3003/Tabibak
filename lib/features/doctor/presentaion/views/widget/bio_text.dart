import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_padding.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class BioText extends StatelessWidget {
  const BioText({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppPadding.all8,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: AppColors.subtextColor),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
