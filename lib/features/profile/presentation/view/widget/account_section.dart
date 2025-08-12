import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/profile/presentation/controller/proffile_states.dart';
import 'package:tabibak/features/profile/presentation/controller/profile_controller.dart';

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
        title: const Text("تسجيل الخروج"),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("تأكيد تسجيل الخروج"),
              content: const Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("إلغاء"),
                ),
                Consumer(builder: (context, ref, child) {
                  final state = ref.watch(profileProviderController);
                  return ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      ref
                          .read(profileProviderController.notifier)
                          .logOut(context);
                    },
                    child: state is LogOutLoading
                        ? SizedBox(
                            height: 14.h,
                            width: 14.w,
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2,
                            ))
                        : const Text(
                            "خروج",
                            style: TextStyle(color: Colors.white),
                          ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
