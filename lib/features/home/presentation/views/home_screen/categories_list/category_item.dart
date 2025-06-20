import 'package:flutter/material.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key, required this.icon, required this.name});
  final String icon;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 70,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: AppColors.second),
          child: Image.asset(icon),
        ),
        SizedBox(height: 5),
        Text(
          name,
          style: Apptextstyles.font16blackRegular,
        )
      ],
    );
  }
}
