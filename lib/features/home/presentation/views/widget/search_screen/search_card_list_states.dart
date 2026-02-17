import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/widgets/app_circle_indicator.dart';
import 'package:tabibak/core/widgets/empty_widget.dart';
import 'package:tabibak/features/doctor/presentation/manager/doctor/doctor_provider.dart';
import 'package:tabibak/features/home/presentation/manager/search_provider/search_provider.dart';
import 'package:tabibak/features/home/presentation/views/widget/search_screen/search_card_list_view.dart';

class SearchCardListStates extends ConsumerWidget {
  const SearchCardListStates({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(searchProviderNotifier);

    return state.isLoading
        ? AppCircleIndicator()
        : state.errorMessage != null
            ? Center(child: Text(state.errorMessage!))
            : state.searchDoctorsList == null || state.searchDoctorsList!.isEmpty
                ? const EmptyWidget()
            : SearchCardListView(
                searchDoctorList: state.searchDoctorsList!,
                onItemTap: (index) {
                  ref.read(doctorIdProvider.notifier).state =
                      state.searchDoctorsList![index].doctorId;
                  ref
                      .read(searchProviderNotifier.notifier)
                      .saveDoctorSearch(state.searchDoctorsList![index]);

                  context.pushNamed(Routes.doctorDetailsScreen);
                },
              );
  }
}
