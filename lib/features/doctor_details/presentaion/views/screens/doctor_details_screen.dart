import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/widgets/empty_widget.dart';
import 'package:tabibak/features/doctor_details/presentaion/manager/doctor_details_provider.dart';
import 'package:tabibak/features/doctor_details/presentaion/views/widget/doctor_details_body.dart';
import 'package:tabibak/features/doctor_details/presentaion/views/widget/doctor_details_shimmer.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class DoctorDetailsScreen extends ConsumerWidget {
  const DoctorDetailsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(doctorDetailsNotifierProvider);

    return Scaffold(
      appBar: AppBarWidget(title: AppStrings.doctorDetails),
      body: state.isLoading
          ? const DoctorDetailsShimmer()
          : state.doctorModel != null
              ? DoctorDetailsBody(doctorModel: state.doctorModel!)
              : const EmptyWidget(),
    );
  }
}
