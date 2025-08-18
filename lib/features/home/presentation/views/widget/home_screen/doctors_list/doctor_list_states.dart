import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/home/presentation/controller/home_controller.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/doctors_list/doctor_list_view.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/doctors_list/doctor_shimmer_list.dart';

class DoctorListStates extends StatelessWidget {
  const DoctorListStates({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final doctorsSummaryList = ref.watch(
        homeControllerPrvider.select((state) => state.doctorsSummaryList),
      );
      return doctorsSummaryList != null
          ? DoctorListView(doctorsSummaryList: doctorsSummaryList)
          : DoctorShimmerList();
    });
  }
}
