import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/alert_widget.dart';
import 'package:tabibak/features/profile/presentation/manager/profile_provider.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: Text(AppStrings.logout.tr()),
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
          }),
    );
  }
}
