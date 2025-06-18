import 'package:flutter/material.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/categories_list.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/home_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        HomeAppbar(),
        SizedBox(height: 20),
        Text("التخصص", style: Apptextstyles.font20BlackRegular),
        SizedBox(height: 15),
        CategoriesList()
      ],
    );
  }
}
