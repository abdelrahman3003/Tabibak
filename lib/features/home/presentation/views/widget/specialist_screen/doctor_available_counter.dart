import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/features/home/presentation/manager/specialty_doctors_provider/doctors_specialty_provider.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/title_text.dart';

class DoctorAvailableCounter extends ConsumerWidget {
  const DoctorAvailableCounter({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final doctorsCount = ref.watch(doctorsSpecialtyProvider
        .select((state) => state.specialtyDoctors?.length ?? 0));
    return TitleText(
        title: AppStrings.availableDoctors,
        subtitle:
            "$doctorsCount ${doctorsCount == 1 ? AppStrings.doctor : AppStrings.doctors}");
  }
}
