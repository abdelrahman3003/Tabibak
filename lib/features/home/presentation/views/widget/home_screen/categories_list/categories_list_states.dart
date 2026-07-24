import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/widgets/empty_widget.dart';
import 'package:tabibak/features/home/presentation/manager/home_provider/home_provider.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/categories_list/categories_list_shimmer_item.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/categories_list/categories_list_view.dart';

class CategoriesListStates extends StatelessWidget {
  const CategoriesListStates({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final specialties = ref.watch(
          homeControllerProvider.select((state) => state.specialties),
        );

        if (specialties == null) {
          return const CategoriesListShimmer();
        }

        if (specialties.isEmpty) {
          return const EmptyWidget();
        }

        return CategoriesListView(
          specialtiesList: specialties,
        );
      },
    );
  }
}
