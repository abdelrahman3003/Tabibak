import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';

class SettingSection extends StatefulWidget {
  const SettingSection({super.key});

  @override
  State<SettingSection> createState() => _SettingSectionState();
}

String _selectedLanguage = "العربية";
bool _isDarkTheme = false;

class _SettingSectionState extends State<SettingSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLanguageTile(),
        _buildThemeTile(),
      ],
    );
  }

  Widget _buildLanguageTile() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.language, color: Colors.blue),
        title: Text(AppStrings.language.tr()),
        trailing: DropdownButton<String>(
          value: _selectedLanguage,
          underline: const SizedBox(),
          items: ["العربية", "English"]
              .map((lang) => DropdownMenuItem(
                    value: lang,
                    child: Text(lang),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedLanguage = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildThemeTile() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SwitchListTile(
        secondary: const Icon(Icons.brightness_6, color: Colors.orange),
        title: Text(AppStrings.darkMode.tr()),
        value: _isDarkTheme,
        onChanged: (value) {
          setState(() {
            _isDarkTheme = value;
          });
        },
      ),
    );
  }
}
