import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/image_circle.dart';
import 'package:tabibak/features/profile/presentation/manager/profile_controller.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.userModel});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: const BoxDecoration(
        color: AppColors.second,
        borderRadius: BorderRadius.only(
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
                ImageCircle(
                  urlImage: userModel.image,
                  radius: 60,
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
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.camera_alt,
                          size: 18, color: AppColors.primary),
                    ),
                  ),
                )
              ],
            );
          }),
          const SizedBox(height: 10),
          Text(userModel.name ?? "", style: Apptextstyles.font18blackBold),
          const SizedBox(height: 4),
          _buildEditableInfo(userModel.email ?? "", Icons.email),
        ],
      ),
    );
  }

  // Stack imageUser(String image) {
  Widget _buildEditableInfo(String label, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 6),
        Text(label, style: Apptextstyles.font14BlackReqular),
        const SizedBox(width: 6),
      ],
    );
  }
}
