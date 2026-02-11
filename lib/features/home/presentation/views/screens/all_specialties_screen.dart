import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/extenstion/naviagrion.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/home/presentation/manager/all_specialteis_provider/all_specialties_provider.dart';
import 'package:tabibak/features/home/presentation/manager/specialty_doctors_provider/doctors_specialty_provider.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/categories_list/category_item.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class AllSpecialtiesScreen extends ConsumerWidget {
  const AllSpecialtiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specialtiesState = ref.watch(specialtiesNotifierProvider);
    final specialtiesList = specialtiesState.specialties ?? [];

    return Scaffold(
      appBar: AppBarWidget(
        title: "All specialties",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: specialtiesList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: specialtiesList.length,
                itemBuilder: (context, index) {
                  final specialty = specialtiesList[index];
                  return CategoryItem(
                    icon: specialty.icon ?? '',
                    name: context.locale.languageCode == 'ar'
                        ? specialty.nameAr ?? ""
                        : specialty.nameEn ?? "",
                    onTap: () {
                      ref
                          .read(doctorsSpecialtyProvider.notifier)
                          .getSpecialtiesDoctors(specialty.id!);
                      context.pushNamed(Routes.specialistScreen);
                    },
                  );
                },
              ),
      ),
    );
  }
}
