import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/image_circle.dart';
import 'package:tabibak/features/profile/presentation/manager/profile_provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.userModel});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Consumer(builder: (context, ref, _) {
            ref.watch(profileProviderController
                .select((state) => state.isUploadLoading));

            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: ImageCircle(
                    urlImage: userModel.image,
                    radius: 60,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .read(profileProviderController.notifier)
                          .uploadAndSaveProfileImage();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.camera_alt,
                          size: 20, color: Theme.of(context).primaryColor),
                    ),
                  ),
                )
              ],
            );
          }),
          const SizedBox(height: 16),
          Text(
            userModel.name ?? "",
            style: Apptextstyles.font18blackBold.copyWith(
              color: Colors.white,
              fontSize: 22.sp,
            ),
          ),
          const SizedBox(height: 8),
          _buildEditableInfo(userModel.email ?? "", Icons.email),
        ],
      ),
    );
  }

  Widget _buildEditableInfo(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            label,
            style: Apptextstyles.font14BlackReqular.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
