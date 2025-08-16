import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/core/helper/routes.dart';
import 'package:tabibak/features/home/data/model/specialise_model.dart';
import 'package:tabibak/features/home/presentation/controller/home_controller.dart';
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
        itemBuilder: (context, index) => Consumer(builder: (context, ref, _) {
          return CategoryItem(
            icon: specialitesList[index].icon,
            name: specialitesList[index].name,
            onTap: () {
              context.pushNamed(Routes.specialistScreen);
              ref
                  .read(homeControllerPrvider.notifier)
                  .getAllDoctorsSpecialties(specialitesList[index].id);
            },
          );
        }),
      ),
    );
  }
}
