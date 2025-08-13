import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/home/presentation/controller/home_controller.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/categories_list/categories_list_shimmer_item.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/categories_list/categories_list_view.dart';

class CategoriesListStates extends StatelessWidget {
  const CategoriesListStates({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(homeControllerPrvider);
      final specialiseModelList =
          ref.read(homeControllerPrvider.notifier).specialiseModelList;
      return specialiseModelList != null
          ? CategoriesListView(specialitesList: specialiseModelList)
          : CategoriesListShimmer();
    });
  }
}
