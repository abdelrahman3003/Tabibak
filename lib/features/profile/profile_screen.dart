import 'package:flutter/material.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/features/profile/widget/account_section.dart';
import 'package:tabibak/features/profile/widget/profile_header.dart';
import 'package:tabibak/features/profile/widget/setting_section.dart';

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
          ProfileHeader(),
          20.hBox,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("الاعدادت", style: Apptextstyles.font14Blackbold),
          ),
          SettingSection(),
          20.hBox,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("الحساب", style: Apptextstyles.font14Blackbold),
          ),
          AccountSection(),
        ],
      ),
    );
  }
}
