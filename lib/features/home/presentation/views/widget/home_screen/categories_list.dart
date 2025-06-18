import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/home/presentation/controller/home_controller.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final categoryNames = ref.read(categoryListNameProvider);
        final categoryIcons = ref.read(categoryListIconsProvider);
        return SizedBox(
          height: 100,
          child: ListView.builder(
              itemCount: categoryNames.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Column(
                    children: [
                      Container(
                        height: 70,
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.second),
                        child: Image.asset(categoryIcons[index]),
                      ),
                      SizedBox(height: 5),
                      Text(
                        categoryNames[index],
                        style: Apptextstyles.font16blackRegular,
                      )
                    ],
                  )),
        );
      },
    );
  }
}
