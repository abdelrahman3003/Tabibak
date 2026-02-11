import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/helper/shared_pref.dart';
import 'package:tabibak/features/profile/presentation/manager/profile_provider.dart';
import 'package:tabibak/features/profile/presentation/view/widget/profile_menu_tile.dart';

class ThemeSwitch extends ConsumerWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProfileMenuTile(
      title: AppStrings.darkMode.tr(),
      icon: Icons.brightness_6,
      iconColor: Colors.orange,
      trailing: Switch(
        value: ref.watch(themeStateProvider),
        onChanged: (value) {
          ref.read(themeStateProvider.notifier).state = value;
          SharedPrefsService.prefs.setBool(SharedPrefKeys.isDark, value);
        },
      ),
    );
  }
}
