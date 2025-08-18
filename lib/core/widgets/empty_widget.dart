import 'package:flutter/material.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "لا يوجد بيانات",
      style: Apptextstyles.font18LightRegular,
    );
  }
}
