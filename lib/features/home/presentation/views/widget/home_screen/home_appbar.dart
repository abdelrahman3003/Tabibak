import 'package:flutter/material.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text(
              "Abdelrahman !",
              style: Apptextstyles.font18blackRegular
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Spacer(),
        Container(
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Color(0xffF5F5F5)),
          child: IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
        )
      ],
    );
  }
}
