import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/features/doctor/data/repo/doctor_repo.dart';
import 'package:tabibak/features/home/data/model/clinic_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

final _profileDoctorProvider = FutureProvider.family<DoctorModel, String>((ref, doctorId) async {
  final result = await getIt<DoctorRepo>().getDoctor(doctorId);
  return result.when(sucess: (doctor) => doctor, failure: (error) => throw Exception(error.message));
});

class DoctorProfileDetails extends ConsumerWidget {
  const DoctorProfileDetails({super.key, required this.doctorId});
  final String doctorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorAsync = ref.watch(_profileDoctorProvider(doctorId));
    return doctorAsync.when(
      loading: () => const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
  error: (error, _) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Could not load doctor information'.tr()),
      TextButton.icon(
        onPressed: () => ref.invalidate(_profileDoctorProvider(doctorId)),
        icon: const Icon(Icons.refresh),
        label: Text('Retry'.tr()),
      ),
    ]),
  ),
      data: (doctor) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Doctor information'.tr(), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _InfoCard(children: [
            if (_present(doctor.specialty?.nameEn ?? doctor.specialty?.nameAr)) _InfoRow(Icons.medical_services_outlined, 'Specialty'.tr(), doctor.specialty!.nameEn ?? doctor.specialty!.nameAr!),
            if (_present(doctor.phone)) _InfoRow(Icons.phone_outlined, 'Phone'.tr(), doctor.phone!),
            if (_present(doctor.email)) _InfoRow(Icons.email_outlined, 'Email'.tr(), doctor.email!),
            if (_present(doctor.bioEn ?? doctor.bioAr)) _InfoRow(Icons.info_outline, 'Biography'.tr(), doctor.bioEn ?? doctor.bioAr!),
            if (doctor.education != null) ...[
              if (_present(doctor.education!.degree)) _InfoRow(Icons.school_outlined, 'Degree'.tr(), doctor.education!.degree!),
              if (_present(doctor.education!.university)) _InfoRow(Icons.account_balance_outlined, 'University'.tr(), doctor.education!.university!),
              if (_present(doctor.education!.certificate)) _InfoRow(Icons.workspace_premium_outlined, 'Certificate'.tr(), doctor.education!.certificate!),
              if (doctor.education!.year != null) _InfoRow(Icons.calendar_today_outlined, 'Graduation year'.tr(), '${doctor.education!.year}'),
              if (_present(doctor.education!.country)) _InfoRow(Icons.public_outlined, 'Country'.tr(), doctor.education!.country!),
            ],
            if (doctor.avrRating != null) _InfoRow(Icons.star_outline, 'Rating'.tr(), '${doctor.avrRating} (${doctor.ratingsCount ?? 0})'),
          ]),
          const SizedBox(height: 20),
          Text('Clinics'.tr(), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (doctor.clinicList != null && doctor.clinicList!.isNotEmpty)
            ...doctor.clinicList!.take(2).map((clinic) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ClinicCard(clinic: clinic),
                ))
          else if (doctor.clinic != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ClinicCard(clinic: doctor.clinic!),
            )
          else
            Text('No clinic information'.tr()),
        ]),
      ),
    );
  }
}

bool _present(String? value) => value != null && value.trim().isNotEmpty;

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children.isEmpty ? [Text('No additional information'.tr())] : children)));
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.icon, this.title, this.value);
  final IconData icon;
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 7), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.labelMedium), const SizedBox(height: 2), Text(value, style: Theme.of(context).textTheme.bodyMedium)]))]));
}

class _ClinicCard extends StatelessWidget {
  const _ClinicCard({required this.clinic});
  final ClinicModel clinic;
  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final addresses = clinic.clinicAddresses ?? [];
    final days = clinic.workingDays ?? [];
    return _InfoCard(children: [
      if (_present(clinic.clinicName)) _InfoRow(Icons.local_hospital_outlined, 'Clinic name'.tr(), clinic.clinicName!),
      if (addresses.isNotEmpty) ...addresses.map((address) {
        final city = locale == 'ar' ? address.city?.nameAr : address.city?.nameEn;
        final details = [address.street, address.department, address.floor == null ? null : '${'Floor'.tr()} ${address.floor}', city].where((part) => _present(part)).join(', ');
        return _InfoRow(Icons.location_on_outlined, 'Address'.tr(), details.isEmpty ? '—' : details);
      }),
      if (_present(clinic.phoneNumber)) _InfoRow(Icons.phone_outlined, 'Phone'.tr(), clinic.phoneNumber!),
      if (clinic.consultationFee != null) _InfoRow(Icons.payments_outlined, 'Consultation fee'.tr(), '${clinic.consultationFee}'),
      if (clinic.isBooking != null) _InfoRow(Icons.event_available_outlined, 'Booking'.tr(), (clinic.isBooking! ? 'Available' : 'Unavailable').tr()),
      if (clinic.isAvailable != null) _InfoRow(Icons.check_circle_outline, 'Clinic status'.tr(), (clinic.isAvailable! ? 'Available' : 'Unavailable').tr()),
      if (days.isNotEmpty) ...days.map((workingDay) {
        final dayName = locale == 'ar' ? workingDay.day.dayAr : workingDay.day.dayEn;
        final shifts = [workingDay.shiftMorning, workingDay.shiftEvening].where((shift) => shift != null && _present(shift.start) && _present(shift.end)).map((shift) => '${shift!.start}–${shift.end}').join(' / ');
        return _InfoRow(Icons.schedule_outlined, dayName ?? 'Working day'.tr(), shifts.isEmpty ? '—' : shifts);
      }),
      if (addresses.isEmpty && clinic.phoneNumber == null && clinic.consultationFee == null && days.isEmpty && !_present(clinic.clinicName)) Text('No clinic information'.tr()),
    ]);
  }
}
