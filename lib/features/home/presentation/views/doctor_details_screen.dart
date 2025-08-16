import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/home/presentation/controller/home_controller.dart';
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
          ref.watch(homeControllerPrvider);
          final doctorModel =
              ref.read(homeControllerPrvider.notifier).doctorModel;

          return doctorModel != null
              ? DoctorDetailsBody(doctorModel: doctorModel)
              : DoctorDetailsShimmer();
        }));
  }
}
