import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/clinic_item_info.dart';
import 'package:tabibak/features/home/data/model/clinic_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/title_text.dart';

class ClinicInfoSection extends StatelessWidget {
  const ClinicInfoSection({super.key, required this.clinic});

  final ClinicModel? clinic;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(title: AppStrings.clinicDetails),
        10.hBox,
        ClinicItemInfo(
            icon: "assets/images/medical_services.png",
            title: AppStrings.clinicNameLabel,
            subtitle: clinic?.clinicName ?? AppStrings.unknown),
        12.hBox,
        ClinicItemInfo(
            icon: "assets/images/payments.png",
            title: AppStrings.consultationFee,
            subtitle:
                clinic?.consultationFee?.toString() ?? AppStrings.unknown),
        12.hBox,
        if (clinic?.clinicAddresses?.isNotEmpty == true) ...[
          ClinicItemInfo(
            icon: "assets/images/location_on.png",
            title: AppStrings.address,
            subtitle: _address(context, clinic!.clinicAddresses!.first),
          ),
          12.hBox,
        ],
        ClinicItemInfo(
            icon: "assets/images/call.png",
            title: AppStrings.phone,
            subtitle: clinic?.phoneNumber ?? AppStrings.unknown),
      ],
    );
  }

  String _address(BuildContext context, ClinicAddressModel address) {
    final languageCode = context.locale.languageCode;
    final localizedCity = languageCode == 'ar'
        ? address.city?.nameAr?.trim()
        : address.city?.nameEn?.trim();
    final street = address.street?.trim();
    final parts = [
      if (localizedCity?.isNotEmpty == true) localizedCity,
      if (street?.isNotEmpty == true) street,
    ];
    return parts.isEmpty ? AppStrings.unknown : parts.join(', ');
  }
}
