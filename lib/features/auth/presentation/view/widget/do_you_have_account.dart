import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class DoHaveAccount extends StatelessWidget {
  const DoHaveAccount(
      {super.key, required this.title, required this.subtitle, this.onTap});
  final String title, subtitle;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: title,
        style: Apptextstyles.font16blackRegular,
        children: [
          TextSpan(
              text: subtitle,
              style: Apptextstyles.font16blackRegular
                  .copyWith(color: AppColors.primary),
              recognizer: TapGestureRecognizer()..onTap = onTap),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
