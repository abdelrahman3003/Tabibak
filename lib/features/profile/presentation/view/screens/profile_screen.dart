import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/features/profile/presentation/view/widget/account_section.dart';
import 'package:tabibak/features/profile/presentation/view/widget/profile_header_states.dart';
import 'package:tabibak/features/profile/presentation/view/widget/setting_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeaderStates(),
          20.hBox,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(AppStrings.settings.tr(),
                style: Apptextstyles.font14Blackbold),
          ),
          SettingSection(),
          20.hBox,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(AppStrings.account.tr(),
                style: Apptextstyles.font14Blackbold),
          ),
          AccountSection(),
        ],
      ),
    );
  }
}
