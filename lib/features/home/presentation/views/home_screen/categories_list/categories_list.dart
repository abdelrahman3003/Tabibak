import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/home/presentation/controller/home_controller.dart';
import 'package:tabibak/features/home/presentation/views/home_screen/categories_list/category_item.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

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
              itemBuilder: (context, index) => CategoryItem(
                  icon: categoryIcons[index], name: categoryNames[index])),
        );
      },
    );
  }
}
