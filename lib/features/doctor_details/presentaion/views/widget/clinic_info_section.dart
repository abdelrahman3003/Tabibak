import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

class ClinicInfoSection extends StatelessWidget {
  const ClinicInfoSection({
    super.key,
    required this.clinic,
  });

  final Clinic? clinic;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInfoTile(Icons.monetization_on, AppStrings.consultationPrice,
            "${clinic?.consultationFee ?? ""} ${AppStrings.currency}"),
        _buildInfoTile(Icons.location_on, AppStrings.address,
            clinic?.address ?? AppStrings.unknown),
        _buildInfoTile(Icons.phone, AppStrings.phoneNumber,
            clinic?.phoneNumber?.toString() ?? AppStrings.numberNotAvailable),
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
