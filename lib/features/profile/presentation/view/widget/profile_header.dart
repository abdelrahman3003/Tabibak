import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

final String _email = "ahmed@example.com";
final String _phone = "01012345678";
XFile? _profileImage;
final ImagePicker _picker = ImagePicker();

class _ProfileHeaderState extends State<ProfileHeader> {
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
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(
                        File(_profileImage!.path),
                      ) as ImageProvider
                    : CachedNetworkImageProvider(
                        "https://www.bing.com/th/id/OIP.l96BdnBni68Vv9r_AgP7UgHaHa?w=224&h=211&c=8&rs=1&qlt=90&o=6&cb=thwsc4&pid=3.1&rm=2",
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.camera_alt,
                        size: 18, color: AppColors.primary),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Text("أحمد محمد", style: Apptextstyles.font18blackBold),
          const SizedBox(height: 4),
          _buildEditableInfo(_email, Icons.email),
          _buildEditableInfo(_phone, Icons.phone),
        ],
      ),
    );
  }

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

  // دالة لالتقاط صورة من المعرض
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }
}
