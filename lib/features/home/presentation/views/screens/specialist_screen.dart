import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/widgets/search_bar_widget.dart';
import 'package:tabibak/features/home/presentation/manager/specialty_doctors_provider/doctors_specialty_provider.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/title_text.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/doctors_list/doctor_specialty_list_states.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/filters_list/filter_list.dart';

class SpecialistScreen extends StatelessWidget {
  const SpecialistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: AppStrings.aboutDoctor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              10.hBox,
              SearchBarWidget(controller: TextEditingController()),
              20.hBox,
              Consumer(builder: (context, ref, _) {
                return SizedBox(
                    height: 40,
                    child: FilterList(
                      filters: [" الاعلي تقيما", "الارخص"],
                      onFilterSelected: (index) {
                        if (index == 0) {
                          ref
                              .read(doctorsSpecialtyProvider.notifier)
                              .getDoctorsHighestRating();
                        }
                      },
                    ));
              }),
              30.hBox,
              TitleText(title: "الأطباء المتاحين", subtitle: "12 طبيب"),
              10.hBox,
              DoctorSpecialtyListStates()
            ],
          ),
        ));
  }
}
