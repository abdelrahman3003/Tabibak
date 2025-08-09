import 'package:flutter/widgets.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';

class TitelText extends StatelessWidget {
  const TitelText({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Apptextstyles.font18blackRegular
          .copyWith(fontWeight: FontWeight.w600),
    );
  }
}
