import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/extenstion/naviagrion.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/features/home/presentation/manager/home_controller.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Consumer(builder: (context, ref, _) {
              final userModel = ref.watch(
                homeControllerPrvider.select((state) => state.userModel),
              );

              return Text(
                userModel != null ? userModel.name ?? "" : "",
                style: Apptextstyles.font18blackRegular
                    .copyWith(fontWeight: FontWeight.bold),
              );
            }),
          ],
        ),
        Spacer(),
        Container(
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Color(0xffF5F5F5)),
          child: IconButton(
              onPressed: () {
                context.pushNamed(Routes.notifcationScreen);
              },
              icon: Icon(Icons.notifications)),
        )
      ],
    );
  }
}
