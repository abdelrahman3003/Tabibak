import 'package:flutter/material.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_button.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/doctor_details_screen/clinic_info_section.dart';
import 'package:tabibak/features/home/presentation/views/widget/doctor_details_screen/schedule_section.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/titel_text.dart';

import 'doctor_details_header.dart';
import 'doctor_review_section.dart';

class DoctorDetailsBody extends StatefulWidget {
  const DoctorDetailsBody({super.key, required this.doctorModel});
  final DoctorModel doctorModel;

  @override
  State<DoctorDetailsBody> createState() => _DoctorDetailsBodyState();
}

class _DoctorDetailsBodyState extends State<DoctorDetailsBody> {
  @override
  Widget build(BuildContext context) {
    final doctorModel = widget.doctorModel;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                DoctorDetailsHeader(
                  name: doctorModel.name,
                  image: doctorModel.image,
                  specialty: doctorModel.specialties?.name,
                  university: doctorModel.universityData?.name,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TitelText(title: "'نبذة عن الطبيب'"),
          const SizedBox(height: 8),
          Text(
            doctorModel.bio ?? "تخصص ${doctorModel.specialties?.name}",
            style: Apptextstyles.font16blackRegular.copyWith(height: 1.5),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),
          ClinicInfoSection(clinic: doctorModel.clinicData),
          const SizedBox(height: 20),
          TitelText(title: 'مواعيد العمل'),
          const SizedBox(height: 20),
          ScheduleSection(
              workingDayList: doctorModel.clinicData?.clinicWorkingDay),
          const SizedBox(height: 20),
          TitelText(title: 'التعليقات'),
          10.hBox,
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
