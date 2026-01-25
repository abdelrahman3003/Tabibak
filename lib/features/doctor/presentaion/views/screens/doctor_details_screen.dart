import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/features/doctor/presentaion/manager/doctor_provider.dart';
import 'package:tabibak/features/doctor/presentaion/views/widget/doctor_details_body.dart';
import 'package:tabibak/features/doctor/presentaion/views/widget/doctor_details_shimmer.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class DoctorDetailsScreen extends ConsumerWidget {
  const DoctorDetailsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(doctorNotifierProvider);
    return Scaffold(
        appBar: AppBarWidget(title: AppStrings.doctorDetails),
        body: state.isLoading || state.doctorModel == null
            ? const DoctorDetailsShimmer()
            : DoctorDetailsBody(doctorModel: state.doctorModel!));
  }
}
