import 'package:flutter/material.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class DoctorInfoSection extends StatelessWidget {
  const DoctorInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInfoTile(Icons.monetization_on, 'سعر الكشف', "300 جنيه"),
        _buildInfoTile(
            Icons.location_on, 'العنوان', "شارع التحرير، وسط البلد، القاهرة"),
        _buildInfoTile(Icons.phone, 'رقم الهاتف', "01012345678"),
      ],
    );
  }
}

Widget _buildInfoTile(IconData icon, String title, String value) {
  return ListTile(
    leading: Icon(icon, color: AppColors.primary),
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle: Text(value),
  );
}
