import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/profile/presentation/view/widget/account_section.dart';
import 'package:tabibak/features/profile/presentation/view/widget/profile_header_states.dart';
import 'package:tabibak/features/profile/presentation/view/widget/setting_section.dart';
import 'package:tabibak/features/profile/presentation/view/widget/doctor_profile_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/home/presentation/manager/home_provider/home_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user =
        ref.watch(homeControllerProvider.select((state) => state.userModel));
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileHeaderStates(),
          if (user?.isDoctor == true && user?.userId != null)
            DoctorProfileDetails(doctorId: user!.userId!),
          24.hBox,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.settings.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                16.hBox,
                SettingSection(),
                24.hBox,
                Text(
                  AppStrings.account.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                10.hBox,
                AccountSection(),
                30.hBox,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
