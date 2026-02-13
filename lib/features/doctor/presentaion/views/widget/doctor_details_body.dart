import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/doctor/presentaion/views/widget/bio_text.dart';
import 'package:tabibak/features/doctor/presentaion/views/widget/booking_dialog_injury.dart';
import 'package:tabibak/features/doctor/presentaion/views/widget/clinic_info_section.dart';
import 'package:tabibak/features/doctor/presentaion/views/widget/comment_list/comment_list_states.dart';
import 'package:tabibak/features/doctor/presentaion/views/widget/schedule_section.dart';
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
          20.hBox,
          TitleText(title: AppStrings.aboutDoctor),
          10.hBox,
          BioText(
            text: doctorModel.bio ??
                "${AppStrings.specialty} ${context.locale.languageCode == 'ar' ? doctorModel.specialty?.nameAr : doctorModel.specialty?.nameEn}",
          ),
          40.hBox,
          ClinicInfoSection(clinic: doctorModel.clinic),
          40.hBox,
          TitleText(title: AppStrings.workingHours),
          10.hBox,
          ScheduleSection(
            workingDayList: doctorModel.clinic?.workingDays,
          ),
          40.hBox,
          CommentListStates(
              doctorId: doctorModel.doctorId,
              initialComments: doctorModel.comments ?? []),
          20.hBox,
          AppButton(
            title: AppStrings.bookingInquiry,
            borderRadius: AppRadius.radius8,
            onPressed: () {
              final isBooked = doctorModel.clinic!.isBooking;
              if (isBooked != null && isBooked) {
                context.pushNamed(Routes.appointmentBookingScreen,
                    arguments: doctorModel);
              } else {
                showDialog(
                  context: context,
                  builder: (context) => BookingDialogInjury(
                    isBooked: isBooked!,
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
