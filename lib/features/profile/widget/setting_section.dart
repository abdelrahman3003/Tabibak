import 'package:flutter/material.dart';

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
        title: const Text("اللغة"),
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
              // هنا ممكن تضيف تغيير لغة التطبيق بالكامل حسب اختيار المستخدم
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
        title: const Text("الوضع الداكن"),
        value: _isDarkTheme,
        onChanged: (value) {
          setState(() {
            _isDarkTheme = value;
            // هنا ممكن تضيف تغيير ثيم التطبيق
          });
        },
      ),
    );
  }
}
