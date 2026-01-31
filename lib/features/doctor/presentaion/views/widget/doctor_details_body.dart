import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
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
            child: DoctorDetailsHeader(
              name: doctorModel.name,
              image: doctorModel.image,
              specialty: doctorModel.specialty?.nameAr,
              university: doctorModel.education?.university,
              rate: 1,
            ),
          ),
          20.hBox,
          TitleText(title: AppStrings.aboutDoctor),
          const SizedBox(height: 8),
          // Text(
          //   doctorModel.bio ??
          //       "${AppStrings.specialty} ${doctorModel.specialty?.nameAr}",
          //   style: Theme.of(context).textTheme.bodyLarge,
          //   textAlign: TextAlign.justify,
          // ),
          20.hBox,
          // ClinicInfoSection(clinic: doctorModel.clinic),
          // 20.hBox,
          // ScheduleSection(
          //   workingDayList: doctorModel.clinic?.workingDays,
          // ),
          // 20.hBox,
          // DoctorReviewSection(doctorModel: doctorModel),
          // 20.hBox,
          // AppButton(
          //   title: AppStrings.bookingInquiry,
          //   onPressed: () {
          //     final isBooked = doctorModel.clinic!.isBooking;
          //     if (isBooked != null && isBooked) {
          //       context.pushNamed(Routes.appointmentBookingScreen,
          //           arguments: doctorModel);
          //     } else {
          //       showDialog(
          //         context: context,
          //         builder: (context) => BookingDialogInjury(
          //           isBooked: isBooked!,
          //         ),
          //       );
          //     }
          //   },
          // )
        ],
      ),
    );
  }
}
