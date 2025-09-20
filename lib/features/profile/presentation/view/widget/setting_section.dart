import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/profile/presentation/view/widget/change_language.dart';
import 'package:tabibak/features/profile/presentation/view/widget/theme_switch.dart';

class SettingSection extends ConsumerWidget {
  const SettingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [ChangeLanguage(), ThemeSwitch()],
    );
  }
}
