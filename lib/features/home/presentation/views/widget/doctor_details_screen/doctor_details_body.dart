import 'package:flutter/material.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/utls/extention.dart';
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
          TitelText(title: "'نبذة عن الطبيب'"),
          const SizedBox(height: 8),
          Text(
            doctorModel.bio ?? "تخصص ${doctorModel.specialties?.name}",
            style: Apptextstyles.font16blackRegular.copyWith(height: 1.5),
            textAlign: TextAlign.justify,
          ),
          20.hBox,
          ClinicInfoSection(clinic: doctorModel.clinicData),
          20.hBox,
          TitelText(title: 'مواعيد العمل'),
          20.hBox,
          ScheduleSection(
              workingDayList: doctorModel.clinicData?.clinicWorkingDay),
          20.hBox,
          DoctorReviewSection(),
          20.hBox,
          AppButton(
            title: "استعلام عن الحجز",
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
