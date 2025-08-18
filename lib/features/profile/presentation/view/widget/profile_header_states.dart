import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/home/presentation/controller/home_controller.dart';
import 'package:tabibak/features/profile/presentation/view/widget/header_profile_shimmer.dart';
import 'package:tabibak/features/profile/presentation/view/widget/profile_header.dart';

class ProfileHeaderStates extends StatelessWidget {
  const ProfileHeaderStates({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final userModel = ref.watch(
        homeControllerPrvider.select((state) => state.userModel),
      );

      return userModel != null
          ? ProfileHeader(userModel: userModel)
          : HeaderProfileShimmer();
    });
  }
}
