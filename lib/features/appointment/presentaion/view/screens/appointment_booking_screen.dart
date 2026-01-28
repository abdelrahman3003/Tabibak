import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/helper/validation.dart';
import 'package:tabibak/core/widgets/app_text_formfiled.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_provider.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/booking/booking_button_states.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/booking/booking_date.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/booking/drop_down_shifts_states.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class AppointmentBookingScreen extends ConsumerStatefulWidget {
  const AppointmentBookingScreen({super.key, required this.doctorModel});

  final DoctorModel doctorModel;

  @override
  ConsumerState<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState
    extends ConsumerState<AppointmentBookingScreen> {
  final patientNameController = TextEditingController();
  final phonePhoneController = TextEditingController();
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();
  int? selectedShiftMorningId;
  int? selectedShiftEveningId;
  final _formState = GlobalKey<FormState>();
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
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formState,
          child: Column(
            children: [
              AppTextFormFiled(
                hint: 'Patient Name',
                controller: patientNameController,
                validator: (value) => Validation.validateName(value),
              ),
              10.hBox,
              AppTextFormFiled(
                hint: 'Phone Number',
                controller: phonePhoneController,
                validator: (value) => Validation.validateRequired(value),
              ),
              10.hBox,
              AppTextFormFiled(
                hint: 'Description',
                controller: descriptionController,
                validator: (value) => Validation.validateRequired(value),
              ),
              10.hBox,
              BookingDate(
                clinicID: widget.doctorModel.clinic!.id!,
                dateController: ref.read(dateStateController.notifier).state,
              ),
              10.hBox,
              DropDownShiftsStates(
                onSelected: ({shiftEveningId, shiftMorningId}) {
                  selectedShiftMorningId = shiftMorningId;
                  selectedShiftEveningId = shiftEveningId;
                },
              ),
              const Spacer(),
              BookingButtonStates(
                onPressed: () {
                  if (!_formState.currentState!.validate()) {
                    return;
                  }
                  ref
                      .read(appointmentBookingNotifierProvider.notifier)
                      .addAppointment(AppointmentModel(
                        userId: Supabase.instance.client.auth.currentUser!.id,
                        doctorId: widget.doctorModel.doctorId,
                        name: patientNameController.text,
                        phone: phonePhoneController.text,
                        description: descriptionController.text,
                        appointmentDate: dateController.text,
                        shiftMorningId: selectedShiftMorningId,
                        shiftEveningId: selectedShiftEveningId,
                        status: 1,
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
