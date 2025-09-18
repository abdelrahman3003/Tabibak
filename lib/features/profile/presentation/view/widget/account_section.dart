import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/features/profile/presentation/view/widget/log_out_button_states.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLogoutTile(context),
      ],
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: Text(AppStrings.logout.tr()),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(AppStrings.confirmSignOut.tr()),
              content: Text(AppStrings.signOutMessage.tr()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppStrings.cancel.tr()),
                ),
                LogOutButtonStates()
              ],
            ),
          );
        },
      ),
    );
  }
}
