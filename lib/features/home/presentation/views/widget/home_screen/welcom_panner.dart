import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/string_constants.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/home/presentation/controller/home_controller.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/image_circle.dart';

class WelcomPanner extends StatelessWidget {
  const WelcomPanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Consumer(builder: (context, ref, _) {
        final userModel = ref.watch(
          homeControllerPrvider.select((state) => state.userModel),
        );

        return Row(
          children: [
            ImageCircle(urlImage: userModel?.image),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${StringConstants.welcome.tr()}, ${userModel != null ? userModel.name : ""} 👋",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    StringConstants.findBestDoctor.tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
