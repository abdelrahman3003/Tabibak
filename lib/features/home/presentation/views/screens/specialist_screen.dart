import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/widgets/search_bar_widget.dart';
import 'package:tabibak/features/home/presentation/manager/specialty_doctors_provider/doctors_specialty_provider.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/doctor_available_counter.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/doctors_list/doctor_specialty_list_states.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/filters_list/specialty_doctor_filter_list.dart';

class SpecialistScreen extends ConsumerWidget {
  const SpecialistScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final specialtyName = locale == 'ar'
        ? ref.read(specialtyProvider)!.nameAr
        : ref.read(specialtyProvider)!.nameEn;
    return Scaffold(
        appBar: AppBarWidget(title: specialtyName),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              10.hBox,
              SearchBarWidget(
                controller: TextEditingController(),
                onChanged: (text) {
                  // ref
                  //     .read(doctorsSpecialtyProvider.notifier)
                  //     .searchSpecialtyDoctors(text);
                },
              ),
              20.hBox,
              SpecialtyDoctorFilterList(),
              30.hBox,
              DoctorAvailableCounter(),
              10.hBox,
              DoctorSpecialtyListStates()
            ],
          ),
        ));
  }
}
