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
import 'package:tabibak/features/doctor/presentation/views/widget/comment_list/comment_list_states.dart';
import 'package:tabibak/features/home/data/model/clinic_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/title_text.dart';

import 'doctor_details_header.dart';

class DoctorDetailsBody extends StatelessWidget {
  const DoctorDetailsBody({super.key, required this.doctorModel});
  final DoctorModel doctorModel;

  @override
  Widget build(BuildContext context) {
    final bioText = context.locale.languageCode == 'ar'
        ? doctorModel.bioAr
        : doctorModel.bioEn;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: DoctorDetailsHeader(doctor: doctorModel),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.hBox,
              TitleText(title: AppStrings.aboutDoctor),
              10.hBox,
              BioText(
                  text: (bioText != null && bioText.trim().isNotEmpty)
                      ? bioText
                      : 'No biography available for this doctor.'.tr()),
              20.hBox,
            ],
          ),
          _ClinicsSection(
            doctorModel: doctorModel,
            clinics: doctorModel.clinicList?.isNotEmpty == true
                ? doctorModel.clinicList!
                : (doctorModel.clinic != null ? [doctorModel.clinic!] : []),
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
              final clinics = doctorModel.clinicList?.isNotEmpty == true
                  ? doctorModel.clinicList!
                  : (doctorModel.clinic != null ? [doctorModel.clinic!] : <ClinicModel>[]);
              
              if (clinics.isEmpty) {
                return;
              }
              
              void navigateToBooking(ClinicModel clinic) {
                if (clinic.isBooking == true) {
                  final selectedDoctor = DoctorModel(
                    doctorId: doctorModel.doctorId,
                    name: doctorModel.name,
                    image: doctorModel.image,
                    bioAr: doctorModel.bioAr,
                    bioEn: doctorModel.bioEn,
                    avrRating: doctorModel.avrRating,
                    ratingsCount: doctorModel.ratingsCount,
                    specialty: doctorModel.specialty,
                    phone: doctorModel.phone,
                    email: doctorModel.email,
                    clinicList: doctorModel.clinicList,
                    comments: doctorModel.comments,
                    education: doctorModel.education,
                    ratings: doctorModel.ratings,
                    clinic: clinic,
                  );
                  context.pushNamed(Routes.appointmentBookingScreen, arguments: selectedDoctor);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => BookingDialogInjury(isBooked: false),
                  );
                }
              }

              if (clinics.length == 1) {
                navigateToBooking(clinics.first);
              } else {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    return SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                'Select a Clinic'.tr(),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...clinics.map((clinic) {
                              final locale = context.locale.languageCode;
                              final city = clinic.clinicAddresses?.isNotEmpty == true
                                  ? (locale == 'ar' ? clinic.clinicAddresses!.first.city?.nameAr : clinic.clinicAddresses!.first.city?.nameEn)
                                  : '';
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                leading: CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                  child: Icon(Icons.local_hospital_outlined, color: Theme.of(context).colorScheme.primary),
                                ),
                                title: Text(clinic.clinicName ?? 'Clinic'.tr(), style: const TextStyle(fontWeight: FontWeight.w600)),
                                subtitle: city?.isNotEmpty == true ? Text(city!) : null,
                                onTap: () {
                                  Navigator.pop(context);
                                  navigateToBooking(clinic);
                                },
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          )

        ],
      ),
    );
  }
}

class _ClinicsSection extends StatelessWidget {
  const _ClinicsSection({required this.clinics, required this.doctorModel});

  final List<ClinicModel> clinics;
  final DoctorModel doctorModel;

  @override
  Widget build(BuildContext context) {
    if (clinics.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(title: AppStrings.clinicDetails),
          10.hBox,
          Text('No clinic information'.tr(),
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
            title: clinics.length > 1
                ? 'Clinics Details'.tr()
                : AppStrings.clinicDetails),
        10.hBox,
        SizedBox(
          height: 168,
          child: LayoutBuilder(
            builder: (context, constraints) => ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: clinics.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) => SizedBox(
                width: constraints.maxWidth * .88,
                child: _ClinicCard(
                  clinic: clinics[index],
                  clinicNumber: index + 1,
                  doctorModel: doctorModel,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ClinicCard extends StatelessWidget {
  const _ClinicCard({
    required this.clinic,
    required this.clinicNumber,
    required this.doctorModel,
  });

  final ClinicModel clinic;
  final int clinicNumber;
  final DoctorModel doctorModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = context.locale.languageCode;
    final address = _addressText(clinic, locale);
    final phoneNumber = clinic.phoneNumber?.trim();
    final colors = theme.colorScheme;

    final titleText = clinic.clinicName?.trim().isNotEmpty == true
        ? clinic.clinicName!
        : '${'Clinic'.tr()} $clinicNumber';

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.primary.withValues(alpha: .14)),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: .08),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.pushNamed(Routes.clinicDetailsScreen, arguments: {
              'clinic': clinic,
              'doctorModel': doctorModel
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.local_hospital_outlined,
                          size: 26,
                          color: colors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        titleText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                      ),
                    ),
                    if (clinic.isAvailable == true)
                      const Padding(
                        padding: EdgeInsetsDirectional.only(start: 8),
                        child: Icon(Icons.circle, size: 9, color: Colors.green),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(
                  height: 1,
                  color: colors.primary.withValues(alpha: .12),
                ),
                const SizedBox(height: 10),
                _ClinicDetailRow(
                  icon: Icons.location_on_outlined,
                  text: address.isNotEmpty
                      ? address
                      : 'Address not available'.tr(),
                  maxLines: 2,
                  prominent: true,
                ),
                const SizedBox(height: 8),
                _ClinicDetailRow(
                  icon: Icons.phone_outlined,
                  text: phoneNumber?.isNotEmpty == true
                      ? phoneNumber!
                      : AppStrings.numberNotAvailable,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _addressText(ClinicModel clinic, String locale) {
    final addresses = clinic.clinicAddresses;
    if (addresses == null || addresses.isEmpty) return '';

    final address = addresses.first;
    final city = locale == 'ar' ? address.city?.nameAr : address.city?.nameEn;

    return [address.street, address.department, address.floor, city]
        .where((part) => part?.trim().isNotEmpty == true)
        .join(', ');
  }
}

class _ClinicDetailRow extends StatelessWidget {
  const _ClinicDetailRow({
    required this.icon,
    required this.text,
    this.maxLines = 1,
    this.prominent = false,
  });

  final IconData icon;
  final String text;
  final int maxLines;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: prominent ? 22 : 20, color: colors.primary),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: (prominent
                    ? theme.textTheme.titleMedium
                    : theme.textTheme.bodyLarge)
                ?.copyWith(
              color: colors.onSurfaceVariant,
              height: prominent ? 1.3 : 1.2,
              fontWeight: prominent ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
