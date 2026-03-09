import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/helper/app_snack_bar.dart';
import 'package:tabibak/core/helper/shared_pref.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/alert_widget.dart';
import 'package:tabibak/features/profile/presentation/manager/profile_provider.dart';
import 'package:tabibak/features/profile/presentation/manager/profile_states.dart';
import 'package:tabibak/features/profile/presentation/view/widget/profile_menu_tile.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return ProfileMenuTile(
      title: AppStrings.logout.tr(),
      icon: Icons.logout,
      iconColor: Colors.red,
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Consumer(builder: (context, ref, child) {
                ref.listen(profileProviderController, (previous, next) async {
                  await _navigateLogout(next, ref, context);
                });
                final isLoading = ref.watch(
                  profileProviderController.select((s) => s.isLogOutLoading),
                );
                return AlertWidget(
                  context: context,
                  title: AppStrings.confirmSignOut,
                  subtitle: AppStrings.signOutMessage,
                  confirmString: AppStrings.logout,
                  confirmColor: AppColors.red,
                  isLoading: isLoading,
                  onPressed: () {
                    ref
                        .watch(profileProviderController.notifier)
                        .logOut(context);
                  },
                );
              });
            });
      },
    );
  }

  Future<void> _navigateLogout(
      ProfileStates next, WidgetRef ref, BuildContext context) async {
    if (next.isLoggedOut) {
      context.pushNamedAndRemoveUntil(Routes.singInScreen, (route) => false);
      await SharedPrefsService.prefs.remove(SharedPrefKeys.isDark);
      ref.read(themeStateProvider.notifier).state = false;
    } else if (next.errorMessage != null) {
      showErrorSnackBar(next.errorMessage!);
    }
  }
}
