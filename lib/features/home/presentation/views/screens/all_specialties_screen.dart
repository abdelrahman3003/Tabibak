import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/home/presentation/manager/all_specialteis_provider/all_specialties_provider.dart';
import 'package:tabibak/features/home/presentation/views/widget/all_specialties_screen/all_specialties_list.dart';
import 'package:tabibak/features/home/presentation/views/widget/all_specialties_screen/all_specialties_shimmer.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class AllSpecialtiesScreen extends ConsumerWidget {
  const AllSpecialtiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specialtiesState = ref.watch(specialtiesNotifierProvider);
    final specialtiesList = specialtiesState.specialties ?? [];

    return Scaffold(
      appBar: AppBarWidget(
        title: "All specialties",
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: specialtiesList.isEmpty
              ? AllSpecialtiesShimmer()
              : AllSpecialtiesList()),
    );
  }
}
