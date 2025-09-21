import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppStrings.noData,
        style: Apptextstyles.font18LightRegular,
      ),
    );
  }
}
