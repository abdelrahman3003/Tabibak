import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/doctor/presentaion/views/widget/clinic_item_info.dart';
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
            title: "اسم العيادة",
            subtitle: clinic?.clinicName ?? ""),
        12.hBox,
        ClinicItemInfo(
            icon: "assets/images/payments.png",
            title: "سعر الكشف",
            subtitle: clinic?.consultationFee?.toString() ?? ""),
        12.hBox,
        ClinicItemInfo(
            icon: "assets/images/location_on.png",
            title: "العنوان",
            subtitle: clinic?.clinicAddressModel?.address ?? ""),
        12.hBox,
        ClinicItemInfo(
            icon: "assets/images/call.png",
            title: "رقم الهاتف",
            subtitle: clinic?.phoneNumber ?? ""),
      ],
    );
  }
}
