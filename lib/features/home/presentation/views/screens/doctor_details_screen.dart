import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/widgets/empty_widget.dart';
import 'package:tabibak/features/home/presentation/manager/home_controller.dart';
import 'package:tabibak/features/home/presentation/views/widget/doctor_details_screen/doctor_details_body.dart';
import 'package:tabibak/features/home/presentation/views/widget/doctor_details_screen/doctor_details_shimmer.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'تفاصيل الطبيب',
      ),
      body: Consumer(builder: (context, ref, _) {
        final isLoading = ref.watch(
          homeControllerPrvider.select((state) => state.isLoading),
        );
        final doctorModel = ref.watch(
          homeControllerPrvider.select((state) => state.doctorModel),
        );
        return isLoading
            ? DoctorDetailsShimmer()
            : doctorModel != null
                ? DoctorDetailsBody(doctorModel: doctorModel)
                : EmptyWidget();
      }),
    );
  }
}
