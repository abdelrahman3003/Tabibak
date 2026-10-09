import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/features/doctor/presentation/manager/doctor/doctor_provider.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/doctor_details_body.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/doctor_details_shimmer.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class DoctorDetailsScreen extends ConsumerStatefulWidget {
  final String? doctorId;
  const DoctorDetailsScreen({super.key, this.doctorId});

  @override
  ConsumerState<DoctorDetailsScreen> createState() =>
      _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends ConsumerState<DoctorDetailsScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.doctorId != null) {
      Future.microtask(() {
        if (mounted) {
          ref.read(doctorIdProvider.notifier).state = widget.doctorId;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(doctorNotifierProvider);
    return Scaffold(
        appBar: AppBarWidget(title: AppStrings.doctorDetails),
        body: state.isLoading || state.doctorModel == null
            ? const DoctorDetailsShimmer()
            : DoctorDetailsBody(doctorModel: state.doctorModel!));
  }
}
