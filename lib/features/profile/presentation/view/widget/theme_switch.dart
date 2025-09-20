import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/helper/shared_pref.dart';
import 'package:tabibak/core/theme/app_theme_controller.dart';

class ThemeSwitch extends ConsumerWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SwitchListTile(
        secondary: const Icon(Icons.brightness_6, color: Colors.orange),
        title: Text(AppStrings.darkMode),
        value: ref.read(themeStateProvider),
        onChanged: (value) {
          ref.read(themeStateProvider.notifier).state = value;
          SharedPrefsService.prefs.setBool(SharedPrefKeys.isDark, value);
        },
      ),
    );
  }
}
