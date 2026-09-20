import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/appointment/presentation/manager/appointment_booking_provider/appointment_booking_provider.dart';
import 'package:tabibak/features/home/data/model/day_shift_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class BookingConfirmScreen extends ConsumerStatefulWidget {
  final DoctorModel doctorModel;
  final AppointmentModel appointmentModel;

  const BookingConfirmScreen({
    super.key,
    required this.doctorModel,
    required this.appointmentModel,
  });

  @override
  ConsumerState<BookingConfirmScreen> createState() =>
      _BookingConfirmScreenState();
}

class _BookingConfirmScreenState extends ConsumerState<BookingConfirmScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentBookingNotifierProvider);
    final isLoading = state.isLoading;
    final timeString = _getTimeString(
      state.dayShiftsModel,
      widget.appointmentModel.shiftMorningId,
      widget.appointmentModel.shiftEveningId,
    );
    final periodLabel = widget.appointmentModel.shiftMorningId != null
        ? AppStrings.morningShift
        : AppStrings.eveningShift;

    ref.listen(appointmentBookingNotifierProvider, (prev, next) {
      if (next.isSuccess && next.appointmentModel != null) {
        ref.read(appointmentBookingNotifierProvider.notifier).consumeSuccess();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.pushReplacementNamed(Routes.layoutScreen);
        });
      }
    });

    return Scaffold(
      backgroundColor: AppColors.scaffoldBG,
      appBar: AppBarWidget(title: AppStrings.confirmBooking),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDoctorCard(context),
                  12.hBox,
                  _buildInfoSection(timeString, periodLabel),
                ],
              ),
            ),
          ),
          _buildConfirmButton(isLoading),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50.r,
            height: 50.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight,
            ),
            child: Icon(
              Icons.local_hospital,
              color: AppColors.primary,
              size: 28.r,
            ),
          ),
          12.wBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.doctorModel.name ?? '',
                  style: Apptextstyles.font16Blackebold,
                ),
                4.hBox,
                Text(
                  widget.doctorModel.clinic?.clinicName ?? '',
                  style: Apptextstyles.font14BlackReqular.copyWith(
                    color: AppColors.subtextColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "${widget.doctorModel.clinic?.consultationFee ?? AppStrings.unknown} ${AppStrings.egp}",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String timeString, String periodLabel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(Icons.calendar_today_outlined, AppStrings.date,
              widget.appointmentModel.appointmentDate ?? ''),
          _buildDivider(),
          _buildInfoRow(
              Icons.access_time_outlined, AppStrings.periodLabel, periodLabel),
          _buildDivider(),
          _buildInfoRow(Icons.timelapse_outlined, AppStrings.time, timeString),
          _buildDivider(),
          _buildInfoRow(Icons.person_outline, AppStrings.name,
              widget.appointmentModel.name ?? ''),
          _buildDivider(),
          _buildInfoRow(Icons.phone_outlined, AppStrings.phone,
              widget.appointmentModel.phone ?? ''),
          if (widget.appointmentModel.description != null &&
              widget.appointmentModel.description!.isNotEmpty) ...[
            _buildDivider(),
            _buildInfoRow(
                Icons.description_outlined,
                AppStrings.conditionDescription,
                widget.appointmentModel.description!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20.r, color: AppColors.primary),
          12.wBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Apptextstyles.font14BlackReqular.copyWith(
                    color: AppColors.subtextColor,
                  ),
                ),
                2.hBox,
                Text(
                  value,
                  style: Apptextstyles.font14Blackbold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
        height: 1, thickness: 0.5, color: AppColors.borderLight);
  }

  Widget _buildConfirmButton(bool isLoading) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: AppButton(
        title: AppStrings.confirmBooking,
        isLoading: isLoading,
        color: AppColors.primary,
        onPressed: isLoading
            ? null
            : () async {
                ref
                    .read(appointmentBookingNotifierProvider.notifier)
                    .addAppointment(widget.appointmentModel);
              },
      ),
    );
  }

  String _getTimeString(
    DayShiftsModel? model,
    int? shiftMorningId,
    int? shiftEveningId,
  ) {
    final isMorning = shiftMorningId != null;
    if (isMorning) {
      return "${model?.morning?.start ?? ''} - ${model?.morning?.end ?? ''}";
    }
    return "${model?.evening?.start ?? ''} - ${model?.evening?.end ?? ''}";
  }
}
