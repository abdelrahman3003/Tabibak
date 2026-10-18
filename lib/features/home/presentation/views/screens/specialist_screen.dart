import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/home/presentation/manager/specialty_doctors_provider/doctors_specialty_provider.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/doctor_available_counter.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/doctors_list/doctor_specialty_list_states.dart';

class SpecialistScreen extends ConsumerWidget {
  const SpecialistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final specialty = ref.watch(specialtyProvider);
    final specialtyName = specialty?.getName(locale) ?? '';

    return Scaffold(
      appBar: AppBarWidget(title: specialtyName),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            10.hBox,
            const DoctorAvailableCounter(),
            10.hBox,
            const DoctorSpecialtyListStates()
          ],
        ),
      ),
    );
  }
}
