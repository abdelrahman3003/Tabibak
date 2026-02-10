import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/alert_widget.dart';
import 'package:tabibak/features/profile/presentation/manager/profile_provider.dart';
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
                final state = ref.watch(
                  profileProviderController
                      .select((state) => state.isLogOutLoading),
                );
                return AlertWidget(
                  context: context,
                  title: AppStrings.confirmSignOut,
                  subtitle: AppStrings.signOutMessage,
                  confirmString: AppStrings.logout,
                  confirmColor: AppColors.red,
                  isLoading: state,
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
}
