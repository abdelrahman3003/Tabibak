import 'package:flutter/material.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/doctors_list/docotr_specialty_list_states.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/search_bar_widget.dart';

class SpecialistScreen extends StatelessWidget {
  const SpecialistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: "أطباء قسم عام",
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              10.hBox,
              SearchBarWidget(),
              20.hBox,
              DocotrSpecialtyListStates()
            ],
          ),
        ));
  }
}
