import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_padding.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.labelBuilder,
    required this.hint,
    this.value,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
  });

  final List<T> items;
  final T? value;
  final String hint;
  final String Function(T item) labelBuilder;
  final void Function(T? value)? onChanged;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      validator: validator,
      padding: AppPadding.horizontal16,
      icon: suffixIcon ??
          const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: null,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        hintText: hint,
          hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 18.sp,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Theme.of(context).colorScheme.secondary,
              ),
        border: InputBorder.none,
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(labelBuilder(item)),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
