import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/doctor_details_screen/clinic_info_section.dart';
import 'package:tabibak/features/home/presentation/views/widget/doctor_details_screen/schedule_section.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/titel_text.dart';

import 'doctor_details_header.dart';
import 'doctor_review_section.dart';

class DoctorDetailsBody extends StatelessWidget {
  const DoctorDetailsBody({super.key, required this.doctorModel});
  final DoctorModel doctorModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: DoctorDetailsHeader(
              name: doctorModel.name,
              image: doctorModel.image,
              specialty: doctorModel.specialties?.name,
              university: doctorModel.universityData?.name,
              rate: doctorModel.avgRate?.toDouble(),
            ),
          ),
          20.hBox,
          TitelText(title: AppStrings.aboutDoctor),
          const SizedBox(height: 8),
          Text(
            doctorModel.bio ??
                "${AppStrings.specialty} ${doctorModel.specialties?.name}",
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          20.hBox,
          ClinicInfoSection(clinic: doctorModel.clinicData),
          20.hBox,
          TitelText(title: AppStrings.workingHours),
          20.hBox,
          ScheduleSection(
              workingDayList: doctorModel.clinicData?.clinicWorkingDay),
          20.hBox,
          DoctorReviewSection(),
          20.hBox,
          AppButton(
            title: AppStrings.bookingInquiry,
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
