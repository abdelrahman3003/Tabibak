import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/widgets/empty_widget.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/appointment/appointment_list_view.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/appointment/appointment_shimmer.dart';
import 'package:tabibak/features/home/presentation/manager/home_provider/home_provider.dart';

class AppointmentListStates extends ConsumerWidget {
  const AppointmentListStates({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: state.isLoading
          ? AppointmentShimmer()
          : false
              ? EmptyWidget()
              : AppointmentListView(appointmentList: []),
    );
  }
}
