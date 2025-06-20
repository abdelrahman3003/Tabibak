import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/gen/assets.gen.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text(
              "اهلا, Omar!",
              style: Apptextstyles.font18blackRegular
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Spacer(),
        Container(
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Color(0xffF5F5F5)),
          child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(Assets.asssets.icons.alert)),
        )
      ],
    );
  }
}
