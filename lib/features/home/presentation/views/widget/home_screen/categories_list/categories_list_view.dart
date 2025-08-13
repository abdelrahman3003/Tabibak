import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/features/home/domain/entites/specialise_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/categories_list/category_item.dart';

class CategoriesListView extends StatelessWidget {
  const CategoriesListView({super.key, required this.specialitesList});
  final List<SpecialiseModel> specialitesList;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.h,
      child: ListView.builder(
        itemCount: specialitesList.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => CategoryItem(
          icon: specialitesList[index].icon,
          name: specialitesList[index].name,
          onTap: () {},
        ),
      ),
    );
  }
}
