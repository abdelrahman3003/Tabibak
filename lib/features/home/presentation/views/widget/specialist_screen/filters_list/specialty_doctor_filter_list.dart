import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/features/home/presentation/manager/specialty_doctors_provider/doctors_specialty_provider.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/filters_list/filter_list.dart';

class SpecialtyDoctorFilterList extends ConsumerWidget {
  const SpecialtyDoctorFilterList({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return SizedBox(
        height: 40,
        child: FilterList(
          filters: [AppStrings.highestRated, AppStrings.lowestPrice],
          onFilterSelected: (index) {
            ref.read(doctorsSpecialtyProvider.notifier).getSpecialtiesDoctors(
                  sortBy: index == 0 ? "avg_rating" : "consultation_fee",
                );
          },
        ));
  }
}
