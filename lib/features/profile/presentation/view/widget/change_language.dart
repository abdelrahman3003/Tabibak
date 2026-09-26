import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/helper/shared_pref.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/profile/presentation/view/widget/profile_menu_tile.dart';

class ChangeLanguage extends StatelessWidget {
  const ChangeLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return ProfileMenuTile(
      title: AppStrings.language.tr(),
      icon: Icons.language,
      iconColor: Colors.blue,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isArabic ? 'العربية' : 'English',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.subtextColor,
                ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.keyboard_arrow_down, color: AppColors.subtextColor),
        ],
      ),
      onTap: () => _showLanguagePicker(context),
    );
  }

  Future<void> _showLanguagePicker(BuildContext context) async {
    final currentLanguage = context.locale.languageCode;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'chooseLanguage'.tr(),
                style: Theme.of(sheetContext).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _LanguageOption(
                label: 'English',
                isSelected: currentLanguage == 'en',
                onTap: () => _selectLanguage(context, sheetContext, 'en'),
              ),
              const SizedBox(height: 8),
              _LanguageOption(
                label: 'العربية',
                isSelected: currentLanguage == 'ar',
                onTap: () => _selectLanguage(context, sheetContext, 'ar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectLanguage(
    BuildContext pageContext,
    BuildContext sheetContext,
    String languageCode,
  ) async {
    await pageContext.setLocale(Locale(languageCode));
    await SharedPrefsService.prefs.setString(SharedPrefKeys.lang, languageCode);
    if (sheetContext.mounted) Navigator.pop(sheetContext);
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Material(
      color: isSelected ? color.withValues(alpha: 0.09) : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                ),
              ),
              if (isSelected) Icon(Icons.check_circle, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
