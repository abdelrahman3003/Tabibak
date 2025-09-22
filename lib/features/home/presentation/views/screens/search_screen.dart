import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/widgets/empty_widget.dart';
import 'package:tabibak/core/widgets/search_bar_widget.dart';
import 'package:tabibak/features/home/presentation/manager/search_provider/search_provider.dart';
import 'package:tabibak/features/home/presentation/manager/search_provider/search_states.dart';
import 'package:tabibak/features/home/presentation/views/widget/search_screen/search_card_list_view.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchProviderNotifer);
    final controller = ref.read(searchProviderNotifer.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.hBox,
          SearchBarWidget(
            controller: controller.searchTextController,
            onChanged: controller.search,
          ),
          16.hBox,
          if (!state.isLoading)
            Text(
              state.searchDoctorsList != null
                  ? "نتائج البحث"
                  : AppStrings.recentSearches,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          Expanded(
            child: _buildContent(context, state, controller),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SearchStates state,
    SearchProvider controller,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final doctors = state.searchDoctorsList ?? controller.cachedList;

    if (doctors == null || doctors.isEmpty) {
      return const EmptyWidget();
    }

    return SearchCardListView(
      searchDoctorList: doctors,
      onItemTap: (index) => controller.goToDoctorDetails(context, index),
    );
  }
}
