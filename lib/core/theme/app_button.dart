import 'package:flutter/material.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';

import 'app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {super.key,
      this.color,
      required this.title,
      this.onPressed,
      this.isLoading = false});
  final Color? color;
  final String title;
  final bool isLoading;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ).copyWith(
        backgroundColor: WidgetStateProperty.all(color ?? AppColors.primary),
      ),
      onPressed: onPressed,
      child: Stack(
        children: [
          Center(
            child: Text(
              title,
              style: Apptextstyles.font16whitebold,
            ),
          ),
          !isLoading
              ? const SizedBox()
              : const Positioned(
                  right: 1,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
