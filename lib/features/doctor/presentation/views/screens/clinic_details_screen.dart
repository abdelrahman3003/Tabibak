import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/booking_dialog_injury.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/clinic_info_section.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/schedule_section.dart';
import 'package:tabibak/features/home/data/model/clinic_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

class ClinicDetailsScreen extends StatelessWidget {
  const ClinicDetailsScreen(
      {super.key, required this.clinic, this.doctorModel});

  final ClinicModel clinic;
  final DoctorModel? doctorModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.clinicDetails,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClinicInfoSection(clinic: clinic),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(height: 1, thickness: 1),
                  ),
                  ScheduleSection(workingDayList: clinic.workingDays),
                ],
              ),
            ),
            24.hBox,
            if (doctorModel != null)
              AppButton(
                title: 'Check Booking'.tr(),
                borderRadius: AppRadius.radius8,
                onPressed: () {
                  final isBooked = clinic.isBooking ?? false;
                  if (isBooked) {
                    final selectedDoctor = DoctorModel(
                      doctorId: doctorModel!.doctorId,
                      name: doctorModel!.name,
                      image: doctorModel!.image,
                      bioAr: doctorModel!.bioAr,
                      bioEn: doctorModel!.bioEn,
                      avrRating: doctorModel!.avrRating,
                      ratingsCount: doctorModel!.ratingsCount,
                      specialty: doctorModel!.specialty,
                      phone: doctorModel!.phone,
                      email: doctorModel!.email,
                      clinicList: doctorModel!.clinicList,
                      comments: doctorModel!.comments,
                      education: doctorModel!.education,
                      ratings: doctorModel!.ratings,
                      clinic: clinic, // Inject the exact clinic!
                    );
                    context.pushNamed(Routes.appointmentBookingScreen,
                        arguments: selectedDoctor);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => BookingDialogInjury(
                        isBooked: isBooked,
                      ),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
