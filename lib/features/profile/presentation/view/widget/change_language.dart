import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/helper/shared_pref.dart';

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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.language, color: Colors.blue),
        title: Text(AppStrings.language),
        trailing: DropdownButton<String>(
          value: _selectedLanguage,
          underline: const SizedBox(),
          items: ["العربية", "English"]
              .map((lang) => DropdownMenuItem(
                    value: lang,
                    child: Text(lang),
                  ))
              .toList(),
          onChanged: (value) async {
            _selectedLanguage = value!;
            context.setLocale(
              _selectedLanguage == "English" ? Locale("en") : Locale("ar"),
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
