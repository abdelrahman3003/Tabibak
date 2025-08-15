import 'package:flutter/material.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';
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
              Expanded(
                child: ListView.builder(
                  itemCount: 12,
                  itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container()),
                ),
              )
            ],
          ),
        ));
  }
}
