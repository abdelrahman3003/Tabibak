import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/home/presentation/controller/home_controller.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/doctors_list/doctor_specailty_list_shimmer.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/doctors_list/doctor_specialty_list_view.dart';

class DocotrSpecialtyListStates extends StatelessWidget {
  const DocotrSpecialtyListStates({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      ref.watch(homeControllerPrvider);
      final doctorsSummaryList =
          ref.read(homeControllerPrvider.notifier).doctorsSpeicalityList;
      return Expanded(
          child: doctorsSummaryList != null
              ? DoctorSpecialtyListView(doctorsSummaryList: doctorsSummaryList)
              : DoctorSpecailtyListShimmer());
    });
  }
}
