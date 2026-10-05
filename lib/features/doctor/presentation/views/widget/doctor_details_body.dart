import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/bio_text.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/booking_dialog_injury.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/clinic_info_section.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/comment_list/comment_list_states.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/schedule_section.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/title_text.dart';

import 'doctor_details_header.dart';

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
            child: DoctorDetailsHeader(doctor: doctorModel),
          ),
          if (doctorModel.bioAr != null || doctorModel.bioEn != null)
            Column(
              children: [
                20.hBox,
                TitleText(title: AppStrings.aboutDoctor),
                10.hBox,
                BioText(
                    text: context.locale.languageCode == 'ar'
                        ? doctorModel.bioAr ?? ""
                        : doctorModel.bioEn ?? ""),
                20.hBox,
              ],
            ),
          20.hBox,
          if (doctorModel.clinicList != null &&
              doctorModel.clinicList!.isNotEmpty)
            ...doctorModel.clinicList!.take(2).map((clinic) => Column(
                  children: [
                    ClinicInfoSection(clinic: clinic),
                    10.hBox,
                    ScheduleSection(workingDayList: clinic.workingDays),
                    20.hBox,
                  ],
                ))
          else if (doctorModel.clinic != null)
            Column(
              children: [
                ClinicInfoSection(clinic: doctorModel.clinic),
                10.hBox,
                ScheduleSection(
                  workingDayList: doctorModel.clinic?.workingDays,
                ),
                20.hBox,
              ],
            ),
          20.hBox,
          CommentListStates(
              doctorId: doctorModel.doctorId,
              initialComments: doctorModel.comments ?? []),
          20.hBox,
          AppButton(
            title: AppStrings.bookingInquiry,
            borderRadius: AppRadius.radius8,
            onPressed: () {
              final clinicToCheck = doctorModel.clinicList?.isNotEmpty == true 
                  ? doctorModel.clinicList!.first 
                  : doctorModel.clinic;
              final isBooked = clinicToCheck?.isBooking ?? false;
              if (isBooked) {
                context.pushNamed(Routes.appointmentBookingScreen,
                    arguments: doctorModel);
              } else {
                showDialog(
                  context: context,
                  builder: (context) => BookingDialogInjury(
                    isBooked: isBooked,
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
