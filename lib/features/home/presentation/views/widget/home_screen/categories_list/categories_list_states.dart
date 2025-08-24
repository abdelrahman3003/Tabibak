import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/home/presentation/manager/home_controller.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/categories_list/categories_list_shimmer_item.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/categories_list/categories_list_view.dart';

class CategoriesListStates extends StatelessWidget {
  const CategoriesListStates({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final specialties = ref.watch(
        homeControllerPrvider.select((state) => state.specialties),
      );
      return specialties != null
          ? CategoriesListView(specialitesList: specialties)
          : CategoriesListShimmer();
    });
  }
}
