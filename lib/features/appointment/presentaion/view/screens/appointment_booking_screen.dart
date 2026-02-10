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
import 'package:tabibak/features/appointment/presentaion/view/widget/booking/title_text_field.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/doctors_list/doctor_item.dart';
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
  final descriptionController = TextEditingController();
  int? selectedShiftMorningId;
  int? selectedShiftEveningId;
  final _formState = GlobalKey<FormState>();
  @override
  void dispose() {
    patientNameController.dispose();
    phonePhoneController.dispose();
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DoctorItem(
                  doctorSummary: widget.doctorModel,
                  isShowBooking: false,
                ),
                20.hBox,
                TitleTextField(text: "أدخل اسمك الكامل"),
                10.hBox,
                AppTextFormFiled(
                  hint: 'أدخل اسمك الكامل',
                  controller: patientNameController,
                  validator: (value) => Validation.validateName(value),
                  prefixIcon: Icon(Icons.person_3_outlined),
                ),
                20.hBox,
                TitleTextField(text: "رقم الهاتف"),
                10.hBox,
                AppTextFormFiled(
                  hint: "05x xxx xxxx",
                  controller: phonePhoneController,
                  validator: (value) => Validation.validateRequired(value),
                  prefixIcon: Icon(Icons.phone_android_outlined),
                ),
                20.hBox,
                TitleTextField(text: "وصف الحالة"),
                10.hBox,
                AppTextFormFiled(
                  hint: "اشرح باختصار سبب الحجز...",
                  controller: descriptionController,
                  maxLines: 3,
                ),
                30.hBox,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleTextField(text: "التاريخ"),
                          BookingDate(
                            clinicID: widget.doctorModel.clinic!.id!,
                            dateController: ref.read(dateStateController),
                          ),
                          10.hBox,
                        ],
                      ),
                    ),
                    20.wBox,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleTextField(text: "الفترة"),
                          DropDownShiftsStates(
                            onSelected: ({shiftEveningId, shiftMorningId}) {
                              selectedShiftMorningId = shiftMorningId;
                              selectedShiftEveningId = shiftEveningId;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                30.hBox,
                BookingButtonStates(
                  onPressed: () {
                    if (!_formState.currentState!.validate()) {
                      return;
                    }
                    ref
                        .read(appointmentBookingNotifierProvider.notifier)
                        .addAppointment(
                          AppointmentModel(
                            userId:
                                Supabase.instance.client.auth.currentUser!.id,
                            doctorId: widget.doctorModel.doctorId,
                            name: patientNameController.text,
                            phone: phonePhoneController.text,
                            description: descriptionController.text,
                            appointmentDate: ref.read(dateStateController).text,
                            shiftMorningId: selectedShiftMorningId,
                            shiftEveningId: selectedShiftEveningId,
                            status: 1,
                          ),
                        );
                  },
                ),
                20.hBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
