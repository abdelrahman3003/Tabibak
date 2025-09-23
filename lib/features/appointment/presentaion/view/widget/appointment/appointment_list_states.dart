import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/widgets/empty_widget.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_provider.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/appointment/appointment_list_view.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/appointment/appointment_shimmer.dart';

class AppointmentListStates extends ConsumerWidget {
  const AppointmentListStates({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appointmentProviderNotifer);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: state.isLoading
          ? AppointmentShimmer()
          : state.appointmentList == null || state.appointmentList!.isEmpty
              ? EmptyWidget()
              : AppointmentListView(appointmentList: state.appointmentList!),
    );
  }
}
