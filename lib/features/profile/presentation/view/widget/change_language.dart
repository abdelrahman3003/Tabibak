import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/helper/shared_pref.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/profile/presentation/view/widget/profile_menu_tile.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

late String? _selectedLanguage;

class _ChangeLanguageState extends State<ChangeLanguage> {
  @override
  void initState() {
    super.initState();
    _selectedLanguage =
        SharedPrefsService.prefs.getString(SharedPrefKeys.lang) ?? "العربية";
  }

  @override
  Widget build(BuildContext context) {
    return ProfileMenuTile(
      title: AppStrings.language.tr(),
      icon: Icons.language,
      iconColor: Colors.blue,
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLanguage,
          icon: Icon(Icons.arrow_forward_ios,
              size: 16, color: AppColors.subtextColor),
          items: ["العربية", "English"]
              .map((lang) => DropdownMenuItem(
                    value: lang,
                    child: Text(
                      lang,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ))
              .toList(),
          onChanged: (value) async {
            _selectedLanguage = value!;
            context.setLocale(
              _selectedLanguage == "English"
                  ? const Locale("en")
                  : const Locale("ar"),
            );
            await SharedPrefsService.prefs
                .setString(SharedPrefKeys.lang, _selectedLanguage!);

            setState(() {});
          },
        ),
      ),
    );
  }
}
