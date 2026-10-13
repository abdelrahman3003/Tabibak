import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/widgets/empty_widget.dart';
import 'package:tabibak/features/home/presentation/manager/specialty_doctors_provider/doctors_specialty_provider.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/doctors_list/doctor_specialties_list_shimmer.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/doctors_list/doctor_specialty_list_view.dart';

class DoctorSpecialtyListStates extends StatelessWidget {
  const DoctorSpecialtyListStates({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final isLoading = ref.watch(
        doctorsSpecialtyProvider.select((state) => state.isLoading),
      );
      final doctorsSpecialtyList = ref.watch(
        doctorsSpecialtyProvider.select((state) => state.specialtyDoctors),
      );
      final hasLocationFilter = ref.watch(
        doctorsSpecialtyProvider.select((state) => state.hasLocationFilter),
      );

      return Expanded(
        child: isLoading || doctorsSpecialtyList == null
            ? DoctorSpecialtiesListShimmer()
            : doctorsSpecialtyList.isNotEmpty
                ? DoctorSpecialtyListView(doctorList: doctorsSpecialtyList)
                : Center(
                    child: hasLocationFilter
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_off_outlined,
                                size: 54,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Text(
                                  AppStrings.noDoctorsInLocation,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton.icon(
                                onPressed: () => ref
                                    .read(doctorsSpecialtyProvider.notifier)
                                    .clearLocationFilter(),
                                icon:
                                    const Icon(Icons.refresh_rounded, size: 18),
                                label: Text(AppStrings.viewAllDoctors),
                              ),
                            ],
                          )
                        : const EmptyWidget(),
                  ),
      );
    });
  }
}
