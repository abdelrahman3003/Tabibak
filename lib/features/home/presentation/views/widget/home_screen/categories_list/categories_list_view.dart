import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/extenstion/naviagrion.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/home/data/model/specialty_model.dart';
import 'package:tabibak/features/home/presentation/manager/specialty_doctors_provider/doctors_specialty_provider.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/categories_list/category_item.dart';

class CategoriesListView extends StatelessWidget {
  const CategoriesListView({super.key, required this.specialtiesList});
  final List<SpecialtyModel> specialtiesList;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: specialtiesList.length,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => Consumer(builder: (context, ref, _) {
        return CategoryItem(
          icon: specialtiesList[index].icon!,
          name: specialtiesList[index].nameAr ?? "",
          onTap: () {
            ref
                .read(doctorsSpecialtyProvider.notifier)
                .getSpecialtiesDoctors(specialtiesList[index].id!);
            context.pushNamed(Routes.specialistScreen);
          },
        );
      }),
    );
  }
}
