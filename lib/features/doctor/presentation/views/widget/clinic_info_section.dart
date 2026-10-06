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
        TitleText(title: 'Clinic Information'.tr()),
        16.hBox,
        ClinicItemInfo(
            icon: "assets/images/medical_services.png",
            title: AppStrings.clinicNameLabel,
            subtitle: clinic?.clinicName ?? AppStrings.unknown),
        16.hBox,
        ClinicItemInfo(
            icon: "assets/images/payments.png",
            title: AppStrings.consultationFee,
            subtitle:
                clinic?.consultationFee?.toString() ?? AppStrings.unknown),
        16.hBox,
        ClinicItemInfo(
          icon: "assets/images/location_on.png",
          title: AppStrings.address,
          subtitle: () {
            final addresses = clinic?.clinicAddresses;
            if (addresses == null || addresses.isEmpty) {
              return AppStrings.unknown;
            }
            final address = addresses.first;
            final locale = context.locale.languageCode;
            final city = locale == 'ar' ? address.city?.nameAr : address.city?.nameEn;
            final governorate = locale == 'ar' ? address.city?.parent?.nameAr : address.city?.parent?.nameEn;
            
            final parts = [governorate, city, address.street, address.department, address.floor]
                .where((part) => part?.trim().isNotEmpty == true)
                .join(', ');
                
            return parts.isNotEmpty ? parts : AppStrings.unknown;
          }(),
        ),
        16.hBox,
        ClinicItemInfo(
            icon: "assets/images/call.png",
            title: AppStrings.phone,
            subtitle: clinic?.phoneNumber ?? AppStrings.unknown),
      ],
    );
  }
}
