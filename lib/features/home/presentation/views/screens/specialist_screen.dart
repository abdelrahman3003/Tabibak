import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/widgets/search_bar_widget.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/doctors_list/docotr_specialty_list_states.dart';

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
              SearchBarWidget(
                controller: TextEditingController(),
              ),
              20.hBox,
              DocotrSpecialtyListStates()
            ],
          ),
        ));
  }
}
