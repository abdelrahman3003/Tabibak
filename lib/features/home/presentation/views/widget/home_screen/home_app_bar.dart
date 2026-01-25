import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/home/presentation/manager/home_provider/home_provider.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Consumer(builder: (context, ref, _) {
              final userModel = ref.watch(
                homeControllerProvider.select((state) => state.userModel),
              );

              return Text(userModel != null ? userModel.name ?? "" : "",
                  style: Theme.of(context).textTheme.titleLarge);
            }),
          ],
        ),
      ],
    );
  }
}
