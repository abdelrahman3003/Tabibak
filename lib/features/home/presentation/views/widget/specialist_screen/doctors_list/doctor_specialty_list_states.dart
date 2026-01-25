import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/widgets/empty_widget.dart';
import 'package:tabibak/features/home/presentation/manager/home_provider/home_provider.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/doctors_list/doctor_specialties_list_shimmer.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/doctors_list/doctor_specialty_list_view.dart';

class DoctorSpecialtyListStates extends StatelessWidget {
  const DoctorSpecialtyListStates({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final isLoading = ref.watch(
        homeControllerProvider.select((state) => state.isLoading),
      );
      final doctorsSpecialtyList = ref.watch(
        homeControllerProvider.select((state) => state.topDoctorsList),
      );
      return Expanded(
        child: isLoading || doctorsSpecialtyList == null
            ? DoctorSpecialtiesListShimmer()
            : doctorsSpecialtyList.isNotEmpty
                ? DoctorSpecialtyListView(
                    doctorsSummaryList: doctorsSpecialtyList)
                : Center(child: EmptyWidget()),
      );
    });
  }
}
