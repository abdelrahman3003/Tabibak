import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/widgets/empty_widget.dart';
import 'package:tabibak/features/home/presentation/manager/home_provider.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/doctors_list/doctor_specailty_list_shimmer.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/doctors_list/doctor_specialty_list_view.dart';

class DocotrSpecialtyListStates extends StatelessWidget {
  const DocotrSpecialtyListStates({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final isLoading = ref.watch(
        homeControllerPrvider.select((state) => state.isLoading),
      );
      final doctorsSpecialityList = ref.watch(
        homeControllerPrvider.select((state) => state.doctorsSpecialityList),
      );
      return Expanded(
        child: isLoading
            ? DoctorSpecailtyListShimmer()
            : doctorsSpecialityList != null && doctorsSpecialityList.isNotEmpty
                ? DoctorSpecialtyListView(
                    doctorsSummaryList: doctorsSpecialityList)
                : Center(child: EmptyWidget()),
      );
    });
  }
}
