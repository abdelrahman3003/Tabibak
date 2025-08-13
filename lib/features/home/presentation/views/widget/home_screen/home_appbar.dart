import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/features/home/presentation/controller/home_controller.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Consumer(builder: (context, ref, _) {
              ref.watch(homeControllerPrvider);
              final userModel =
                  ref.read(homeControllerPrvider.notifier).userModel;
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
          child: IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
        )
      ],
    );
  }
}
