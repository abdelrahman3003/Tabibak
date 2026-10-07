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

  String _name(CityModel? city, String locale) {
    if (city == null) return '';
    return (locale == 'ar' ? city.nameAr : city.nameEn) ??
        city.nameAr ??
        city.nameEn ??
        '';
  }

  String _buildAddressString(ClinicAddressModel address, String locale) {
    final parts = <String>[
      _name(address.markaz, locale),
      _name(address.village, locale),
      _name(address.city, locale),
      address.street?.trim() ?? '',
      address.department?.trim() ?? '',
      address.floor?.trim() ?? '',
    ].where((p) => p.isNotEmpty).toList();

    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(title: 'Clinic Information'.tr()),
        16.hBox,

        // Clinic Name
        ClinicItemInfo(
          icon: "assets/images/medical_services.png",
          title: AppStrings.clinicNameLabel,
          subtitle: clinic?.clinicName ?? AppStrings.unknown,
        ),
        16.hBox,

        // Consultation Fee
        ClinicItemInfo(
          icon: "assets/images/payments.png",
          title: AppStrings.consultationFee,
          subtitle: clinic?.consultationFee?.toString() ?? AppStrings.unknown,
        ),
        16.hBox,

        // Address — all fields in one row per address entry
        ...() {
          final addresses = clinic?.clinicAddresses;
          if (addresses == null || addresses.isEmpty) {
            return [
              ClinicItemInfo(
                icon: "assets/images/location_on.png",
                title: AppStrings.address,
                subtitle: AppStrings.unknown,
              ),
            ];
          }

          final List<Widget> rows = [];
          for (int i = 0; i < addresses.length; i++) {
            if (i > 0) rows.add(16.hBox);
            final subtitle = _buildAddressString(addresses[i], locale);
            rows.add(ClinicItemInfo(
              icon: "assets/images/location_on.png",
              title: AppStrings.address,
              subtitle: subtitle.isNotEmpty ? subtitle : AppStrings.unknown,
            ));
          }
          return rows;
        }(),

        16.hBox,

        // Phone
        ClinicItemInfo(
          icon: "assets/images/call.png",
          title: AppStrings.phone,
          subtitle: clinic?.phoneNumber ?? AppStrings.unknown,
        ),
      ],
    );
  }
}
