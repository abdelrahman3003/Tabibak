import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/widgets/app_text_formfiled.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/booking/booking_button_states.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/booking/booking_date.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/booking/drop_down_shifts_states.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({super.key, required this.doctorModel});

  final DoctorModel doctorModel;

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController phonePhoneController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? dateTime;
  int? shiftId;

  @override
  void dispose() {
    patientNameController.dispose();
    phonePhoneController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: AppStrings.bookingInquiry),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AppTextFormFiled(
              hint: "Patient Name",
              controller: patientNameController,
            ),
            10.hBox,
            AppTextFormFiled(
              hint: "Phone Number",
              controller: phonePhoneController,
            ),
            10.hBox,
            AppTextFormFiled(
              hint: "Description",
              controller: descriptionController,
            ),
            10.hBox,
            BookingDate(clinicID: widget.doctorModel.clinic!.id!),
            10.hBox,
            DropDownShiftsStates(),
            Spacer(),
            BookingButtonStates(
              doctorModel: widget.doctorModel,
            ),
          ],
        ),
      ),
    );
  }
}
