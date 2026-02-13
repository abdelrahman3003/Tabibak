import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/home/presentation/manager/all_specialteis_provider/all_specialties_provider.dart';
import 'package:tabibak/features/home/presentation/manager/specialty_doctors_provider/doctors_specialty_provider.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/categories_list/category_item.dart';

class AllSpecialtiesList extends ConsumerWidget {
  const AllSpecialtiesList({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final specialtiesState = ref.watch(specialtiesNotifierProvider);
    final specialtiesList = specialtiesState.specialties ?? [];
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: specialtiesList.length,
      itemBuilder: (context, index) {
        final specialty = specialtiesList[index];
        return CategoryItem(
          isAllCategories: true,
          icon: specialty.icon ?? '',
          name: context.locale.languageCode == 'ar'
              ? specialty.nameAr ?? ""
              : specialty.nameEn ?? "",
          onTap: () {
            ref
                .read(doctorsSpecialtyProvider.notifier)
                .getSpecialtiesDoctors(specialtyId: specialtiesList[index].id);
            ref.read(specialtyProvider.notifier).state = specialtiesList[index];
            context.pushNamed(Routes.specialistScreen);
          },
        );
      },
    );
  }
}
