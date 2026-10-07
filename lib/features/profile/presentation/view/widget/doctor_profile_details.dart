import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/doctor/data/repo/doctor_repo.dart';
import 'package:tabibak/features/home/data/model/clinic_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:url_launcher/url_launcher.dart';

final _profileDoctorProvider =
    FutureProvider.family<DoctorModel, String>((ref, doctorId) async {
  final result = await getIt<DoctorRepo>().getDoctor(doctorId);

  return result.when(
    sucess: (doctor) => doctor,
    failure: (error) => throw Exception(error.message),
  );
});

class DoctorProfileDetails extends ConsumerWidget {
  const DoctorProfileDetails({
    super.key,
    required this.doctorId,
    this.onBookClinic,
  });

  final String doctorId;

  /// Called when the user taps "Book now" on a clinic.
  /// If null, the booking button is hidden.
  final void Function(DoctorModel doctor, ClinicModel clinic)? onBookClinic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorAsync = ref.watch(_profileDoctorProvider(doctorId));

    return doctorAsync.when(
      loading: () => const _ProfileSkeleton(),
      error: (error, _) => _ErrorState(
        onRetry: () => ref.invalidate(_profileDoctorProvider(doctorId)),
      ),
      data: (doctor) => _DoctorProfileSummary(
        doctor: doctor,
        onBookClinic: onBookClinic,
      ),
    );
  }
}

// ───────────────────────── States ─────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 44,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'Could not load doctor information'.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text('Retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSkeleton extends StatefulWidget {
  const _ProfileSkeleton();

  @override
  State<_ProfileSkeleton> createState() => _ProfileSkeletonState();
}

class _ProfileSkeletonState extends State<_ProfileSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  late final Animation<double> _opacity =
      Tween<double>(begin: .45, end: 1).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;

    Widget box(double height, {double radius = 16}) => Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
          ),
        );

    return FadeTransition(
      opacity: _opacity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          children: [
            box(190, radius: 22),
            const SizedBox(height: 18),
            box(170),
            const SizedBox(height: 12),
            box(170),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Summary ─────────────────────────

class _DoctorProfileSummary extends StatelessWidget {
  const _DoctorProfileSummary({
    required this.doctor,
    required this.onBookClinic,
  });

  final DoctorModel doctor;
  final void Function(DoctorModel doctor, ClinicModel clinic)? onBookClinic;

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;

    final specialty = locale == 'ar'
        ? doctor.specialty?.nameAr ?? doctor.specialty?.nameEn
        : doctor.specialty?.nameEn ?? doctor.specialty?.nameAr;

    final clinics = doctor.clinicList?.isNotEmpty == true
        ? doctor.clinicList!
        : doctor.clinic == null
            ? <ClinicModel>[]
            : <ClinicModel>[doctor.clinic!];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DoctorHero(
            doctor: doctor,
            specialty: specialty,
          ),
          const SizedBox(height: 20),
          _ClinicsSection(
            clinics: clinics,
            doctor: doctor,
            onBookClinic: onBookClinic,
          ),
          const SizedBox(height: 16),
          _ProfileSection(
            icon: Icons.badge_outlined,
            title: 'Doctor details'.tr(),
            subtitle: _doctorDetailsSubtitle(doctor),
            initiallyExpanded: false,
            child: _DoctorDetailsContent(
              doctor: doctor,
              locale: locale,
            ),
          ),
        ],
      ),
    );
  }
}

String _doctorDetailsSubtitle(DoctorModel doctor) {
  final parts = <String>[];

  if (_present(doctor.phone)) {
    parts.add(doctor.phone!);
  }

  if (doctor.avrRating != null) {
    parts.add('★ ${doctor.avrRating}');
  }

  return parts.isEmpty
      ? 'View professional and contact details'.tr()
      : parts.join('  ·  ');
}

// ───────────────────────── Hero ─────────────────────────

class _DoctorHero extends StatelessWidget {
  const _DoctorHero({
    required this.doctor,
    required this.specialty,
  });

  final DoctorModel doctor;
  final String? specialty;

  bool get _isAvailable =>
      doctor.clinicList?.any((clinic) => clinic.isAvailable == true) == true ||
      doctor.clinic?.isAvailable == true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: .78),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: theme.colorScheme.surface,
                backgroundImage:
                    _present(doctor.image) ? NetworkImage(doctor.image!) : null,
                child: !_present(doctor.image)
                    ? Icon(
                        Icons.person_outline,
                        size: 38,
                        color: theme.colorScheme.primary,
                      )
                    : null,
              ),
              if (_isAvailable)
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            doctor.name ?? 'Doctor'.tr(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_present(specialty)) ...[
            const SizedBox(height: 3),
            Text(
              specialty!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: .88),
              ),
            ),
          ],
          if (_hasEducation(doctor)) ...[
            const SizedBox(height: 3),
            Text(
              [
                doctor.education?.degree,
                doctor.education?.university,
              ].where(_present).join(' · '),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: .78),
              ),
            ),
          ],
          if (doctor.avrRating != null || doctor.visitsCount != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: .18),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (doctor.avrRating != null) ...[
                    const Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${doctor.avrRating}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '(${doctor.ratingsCount ?? 0} ${'Reviews'.tr()})',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color:
                            theme.colorScheme.onPrimary.withValues(alpha: .85),
                      ),
                    ),
                  ],
                  if (doctor.avrRating != null && doctor.visitsCount != null && doctor.visitsCount! > 0)
                    const SizedBox(width: 12),
                  if (doctor.visitsCount != null && doctor.visitsCount! > 0) ...[
                    Icon(
                      Icons.visibility_outlined,
                      size: 18,
                      color: theme.colorScheme.onPrimary.withValues(alpha: .9),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${doctor.visitsCount} ${'Visits'.tr()}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color:
                            theme.colorScheme.onPrimary.withValues(alpha: .85),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ───────────────────────── Clinics (redesigned) ─────────────────────────

class _ClinicsSection extends StatelessWidget {
  const _ClinicsSection({
    required this.clinics,
    required this.doctor,
    required this.onBookClinic,
  });

  final List<ClinicModel> clinics;
  final DoctorModel doctor;
  final void Function(DoctorModel doctor, ClinicModel clinic)? onBookClinic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Clinics'.tr(),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (clinics.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${clinics.length}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        if (clinics.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: .5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.local_hospital_outlined,
                  size: 32,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 8),
                Text(
                  'No clinic information'.tr(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          )
        else if (clinics.length == 1)
          _ClinicDetailsContent(
            clinic: clinics.single,
            onBook: _bookCallback(clinics.single),
          )
        else
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: clinics.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) => LayoutBuilder(
                builder: (context, constraints) => SizedBox(
                  width: constraints.maxWidth * .88,
                  child: _ClinicCard(
                    clinic: clinics[index],
                    onOpenDetails: () => _showClinicDetails(
                      context,
                      clinics[index],
                    ),
                    onBook: _bookCallback(clinics[index]),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  VoidCallback? _bookCallback(ClinicModel clinic) {
    if (clinic.isBooking == true && onBookClinic != null) {
      return () => onBookClinic!(doctor, clinic);
    }
    return null;
  }

  void _showClinicDetails(BuildContext context, ClinicModel clinic) {
    Navigator.of(context).pushNamed(
      Routes.clinicDetailsScreen,
      arguments: clinic,
    );
  }
}

class _ClinicCard extends StatelessWidget {
  const _ClinicCard({
    required this.clinic,
    required this.onOpenDetails,
    required this.onBook,
  });

  final ClinicModel clinic;
  final VoidCallback onOpenDetails;
  final VoidCallback? onBook;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = context.locale.languageCode;

    final name =
        _present(clinic.clinicName) ? clinic.clinicName! : 'Clinic'.tr();
    final address = _clinicAddress(clinic, locale);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .8)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: .06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onOpenDetails,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(Icons.local_hospital_outlined,
                          color: colors.primary, size: 21),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_rounded,
                        size: 19, color: colors.primary),
                  ],
                ),
                if (clinic.isAvailable != null) ...[
                  const SizedBox(height: 8),
                  _StatusPill(isAvailable: clinic.isAvailable!),
                ],
                const SizedBox(height: 12),
                Divider(height: 1, color: colors.outlineVariant),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 17, color: colors.primary),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        address.isNotEmpty
                            ? address
                            : 'Address not available'.tr(),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style:
                            theme.textTheme.bodySmall?.copyWith(height: 1.35),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    'View details'.tr(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.icon, this.text, {this.prefix});

  final IconData icon;
  final String text;
  final String? prefix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                if (prefix != null)
                  TextSpan(
                    text: prefix,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                TextSpan(text: text),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _ClinicDetailsContent extends StatelessWidget {
  const _ClinicDetailsContent({
    required this.clinic,
    required this.onBook,
  });

  final ClinicModel clinic;
  final VoidCallback? onBook;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = context.locale.languageCode;
    final addresses = clinic.clinicAddresses ?? [];
    final workingDays = clinic.workingDays ?? [];
    final name =
        _present(clinic.clinicName) ? clinic.clinicName! : 'Clinic'.tr();
    final todayEntry = _todayEntry(workingDays);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            if (clinic.isAvailable != null)
              _StatusPill(isAvailable: clinic.isAvailable!),
          ],
        ),
        const SizedBox(height: 16),
        for (final address in addresses)
          _SheetLine(
            Icons.location_on_outlined,
            [
              address.street,
              address.department,
              if (address.floor != null) '${'Floor'.tr()} ${address.floor}',
              locale == 'ar' ? address.city?.nameAr : address.city?.nameEn,
            ].where(_present).join(', '),
          ),
        if (_present(clinic.phoneNumber))
          _SheetLine(
            Icons.phone_outlined,
            clinic.phoneNumber!,
            highlight: true,
            onTap: () => _launch(Uri(scheme: 'tel', path: clinic.phoneNumber!)),
          ),
        if (clinic.consultationFee != null)
          _SheetLine(
            Icons.payments_outlined,
            '${'Consultation fee'.tr()}: ${clinic.consultationFee} ${'EGP'.tr()}',
          ),
        if (clinic.isBooking != null)
          _SheetLine(
            Icons.event_available_outlined,
            (clinic.isBooking! ? 'Booking available' : 'Booking unavailable')
                .tr(),
          ),
        if (workingDays.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(
            'Working hours'.tr(),
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._buildWorkingHours(
            workingDays: workingDays,
            locale: locale,
            todayEntry: todayEntry,
            theme: theme,
          ),
        ],
        if (addresses.isEmpty &&
            !_present(clinic.phoneNumber) &&
            clinic.consultationFee == null &&
            clinic.isBooking == null &&
            workingDays.isEmpty)
          Text('No clinic information'.tr()),
        if (onBook != null || _present(clinic.phoneNumber)) ...[
          const SizedBox(height: 18),
          Row(
            children: [
              if (_present(clinic.phoneNumber))
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _launch(
                      Uri(scheme: 'tel', path: clinic.phoneNumber!),
                    ),
                    icon: const Icon(Icons.phone_outlined),
                    label: Text('Call'.tr()),
                  ),
                ),
              if (onBook != null && _present(clinic.phoneNumber))
                const SizedBox(width: 10),
              if (onBook != null)
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: onBook,
                    icon: const Icon(Icons.event_available),
                    label: Text('Book now'.tr()),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _SheetLine extends StatelessWidget {
  const _SheetLine(
    this.icon,
    this.text, {
    this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: highlight ? theme.colorScheme.primary : null,
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: content,
    );
  }
}

class _HoursRow extends StatelessWidget {
  const _HoursRow({
    required this.day,
    required this.hours,
    required this.isToday,
  });

  final String? day;
  final String hours;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isToday
            ? theme.colorScheme.primaryContainer.withValues(alpha: .6)
            : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              day ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            hours.isEmpty ? 'Closed'.tr() : hours,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: hours.isEmpty ? theme.colorScheme.onSurfaceVariant : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final color =
        isAvailable ? Colors.green : Theme.of(context).colorScheme.outline;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 7, color: color),
          const SizedBox(width: 5),
          Text(
            (isAvailable ? 'Available' : 'Unavailable').tr(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Doctor details ─────────────────────────

class _DoctorDetailsContent extends StatelessWidget {
  const _DoctorDetailsContent({
    required this.doctor,
    required this.locale,
  });

  final DoctorModel doctor;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final bio = locale == 'ar'
        ? doctor.bioAr ?? doctor.bioEn
        : doctor.bioEn ?? doctor.bioAr;

    final education = doctor.education;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_present(doctor.phone))
            _DetailLine(
              Icons.phone_outlined,
              'Phone'.tr(),
              doctor.phone!,
              onTap: () => _launch(Uri(scheme: 'tel', path: doctor.phone!)),
            ),
          if (_present(doctor.email))
            _DetailLine(
              Icons.email_outlined,
              'Email'.tr(),
              doctor.email!,
              onTap: () => _launch(Uri(scheme: 'mailto', path: doctor.email!)),
            ),
          if (education != null && _present(education.degree))
            _DetailLine(
              Icons.school_outlined,
              'Degree'.tr(),
              education.degree!,
            ),
          if (education != null && _present(education.university))
            _DetailLine(
              Icons.account_balance_outlined,
              'University'.tr(),
              education.university!,
            ),
          if (education != null && _present(education.certificate))
            _DetailLine(
              Icons.workspace_premium_outlined,
              'Certificate'.tr(),
              education.certificate!,
            ),
          if (education?.year != null)
            _DetailLine(
              Icons.calendar_today_outlined,
              'Graduation year'.tr(),
              '${education!.year}',
            ),
          if (education != null && _present(education.country))
            _DetailLine(
              Icons.public_outlined,
              'Country'.tr(),
              education.country!,
            ),
          if (_present(bio)) ...[
            const SizedBox(height: 8),
            _ExpandableText(
              title: 'Biography'.tr(),
              text: bio!,
            ),
          ],
          if (doctor.avrRating == null && doctor.ratingsCount != null)
            _DetailLine(
              Icons.star_outline,
              'Rating'.tr(),
              '${doctor.ratingsCount}',
            ),
          if (!_present(doctor.phone) &&
              !_present(doctor.email) &&
              !_hasEducation(doctor) &&
              !_present(bio))
            Text('No additional information'.tr()),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatefulWidget {
  const _ProfileSection({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.initiallyExpanded,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;
  final bool initiallyExpanded;

  @override
  State<_ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<_ProfileSection> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Semantics(
            button: true,
            expanded: _expanded,
            label: widget.title,
            child: InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.icon,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _expanded ? .5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.keyboard_arrow_down),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _expanded
                ? SizedBox(width: double.infinity, child: widget.child)
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine(
    this.icon,
    this.title,
    this.value, {
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 9),
          SizedBox(
            width: 105,
            child: Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: onTap != null ? theme.colorScheme.primary : null,
                decoration: onTap != null ? TextDecoration.underline : null,
                decorationColor: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: content,
    );
  }
}

class _ExpandableText extends StatefulWidget {
  const _ExpandableText({
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 2),
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.topCenter,
          child: Text(
            widget.text,
            maxLines: _expanded ? null : 2,
            overflow: _expanded ? null : TextOverflow.ellipsis,
          ),
        ),
        if (widget.text.length > 110)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  (_expanded ? 'Show less' : 'Show more').tr(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ───────────────────────── Helpers ─────────────────────────

bool _present(String? value) => value != null && value.trim().isNotEmpty;

bool _hasEducation(DoctorModel doctor) {
  final education = doctor.education;

  return education != null &&
      [
        education.degree,
        education.university,
        education.certificate,
        education.year?.toString(),
        education.country,
      ].any(_present);
}

String _clinicAddress(ClinicModel clinic, String locale) {
  final addresses = clinic.clinicAddresses ?? [];
  if (addresses.isEmpty) return '';

  final address = addresses.first;

  String getCityName(CityModel? city) {
    if (city == null) return '';
    return (locale == 'ar' ? city.nameAr : city.nameEn) ??
        city.nameAr ??
        city.nameEn ??
        '';
  }

  return [
    getCityName(address.governorate),
    getCityName(address.markaz),
  ].where((p) => p.isNotEmpty).join(', ');
}

/// Morning / evening shifts of a working day as "start–end" strings.
List<String> _shifts(dynamic day) {
  final result = <String>[];

  final morning = day.shiftMorning;
  if (morning != null && _present(morning.start) && _present(morning.end)) {
    result.add('${morning.start}–${morning.end}');
  }

  final evening = day.shiftEvening;
  if (evening != null && _present(evening.start) && _present(evening.end)) {
    result.add('${evening.start}–${evening.end}');
  }

  return result;
}

/// Finds today's entry by matching the English day name (Mon, Monday, ...).
/// Returns null when nothing matches, so the UI simply hides "Today".
dynamic _todayEntry(List<dynamic> workingDays) {
  const abbreviations = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
  final today = abbreviations[DateTime.now().weekday - 1];

  for (final day in workingDays) {
    final en = (day.day.dayEn as String?)?.toLowerCase().trim();
    if (en != null && en.startsWith(today)) return day;
  }
  return null;
}

String? _todayHours(ClinicModel clinic, String locale) {
  final days = clinic.workingDays ?? [];
  if (days.isEmpty) return null;

  final entry = _todayEntry(days);
  if (entry == null) return null;

  final shifts = _shifts(entry);
  return shifts.isEmpty ? 'Closed'.tr() : shifts.join(' · ');
}

Future<void> _launch(Uri uri) async {
  try {
    await launchUrl(uri);
  } catch (_) {
    // Device may not support the scheme (e.g. tablet without telephony).
  }
}

/// Groups working days by schedule and returns either a single summary row
/// or individual day rows depending on how uniform the schedule is.
List<Widget> _buildWorkingHours({
  required List<dynamic> workingDays,
  required String locale,
  required dynamic todayEntry,
  required ThemeData theme,
}) {
  // All 7 canonical day keys in calendar order.
  const allDayKeys = [
    'saturday',
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
  ];

  // ── Step 1: Deduplicate by day name, keep first non-empty hours. ──
  final dayHours = <String, String>{}; // dayKey → raw hours string
  final dayModels = <String, dynamic>{}; // dayKey → original WorkingDay model

  for (final day in workingDays) {
    final enName = ((day.day.dayEn as String?) ?? '').trim().toLowerCase();
    if (enName.isEmpty) continue;

    final hours = _shifts(day).join(' · ');

    // Keep the first entry that has actual hours; skip duplicates.
    if (!dayHours.containsKey(enName) || dayHours[enName]!.isEmpty) {
      dayHours[enName] = hours;
      dayModels[enName] = day;
    }
  }

  // ── Step 2: Separate open days from closed/missing days. ──
  final openDays = <String, String>{}; // dayKey → hours (non-empty only)
  for (final entry in dayHours.entries) {
    if (entry.value.isNotEmpty) {
      openDays[entry.key] = entry.value;
    }
  }

  // ── Step 3: Group open days by their hours string. ──
  final hoursToDays = <String, List<String>>{};
  for (final entry in openDays.entries) {
    hoursToDays.putIfAbsent(entry.value, () => []).add(entry.key);
  }

  // ── Step 4: Check if all open days share the SAME hours. ──
  if (hoursToDays.length == 1) {
    final commonHours = hoursToDays.keys.first;
    final openDayKeys = hoursToDays.values.first.toSet();
    final missingDays = allDayKeys.where((d) => !openDayKeys.contains(d)).toList();

    // Localized day name helper.
    String localizedDay(String enKey) {
      if (locale == 'ar') {
        const map = {
          'saturday': 'السبت',
          'sunday': 'الأحد',
          'monday': 'الاثنين',
          'tuesday': 'الثلاثاء',
          'wednesday': 'الأربعاء',
          'thursday': 'الخميس',
          'friday': 'الجمعة',
        };
        return map[enKey] ?? enKey;
      }
      // Capitalize for English display.
      return '${enKey[0].toUpperCase()}${enKey.substring(1)}';
    }

    // Build a themed summary container that matches _HoursRow styling.
    Widget summaryRow(String text) {
      return Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: todayEntry != null
              ? theme.colorScheme.primaryContainer.withValues(alpha: .6)
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight:
                todayEntry != null ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
    }

    // Rule 1 — all 7 days open with same hours.
    if (missingDays.isEmpty) {
      return [
        summaryRow('${'Open every day from'.tr()} $commonHours'),
      ];
    }

    // Rule 2 — 6 days open, 1 day off.
    if (missingDays.length == 1) {
      final off = localizedDay(missingDays[0]);
      return [
        summaryRow(
          '${'Open every day except'.tr()} $off ${'from'.tr()} $commonHours',
        ),
      ];
    }

    // Rule 3 — 5 days open, 2 days off.
    if (missingDays.length == 2) {
      final off1 = localizedDay(missingDays[0]);
      final off2 = localizedDay(missingDays[1]);
      return [
        summaryRow(
          '${'Open every day except'.tr()} $off1 ${'and'.tr()} $off2 ${'from'.tr()} $commonHours',
        ),
      ];
    }
  }

  // ── Rule 4 — fallback: show each working day individually. ──
  final result = <Widget>[];
  for (final dayKey in allDayKeys) {
    final model = dayModels[dayKey];
    if (model == null) continue;

    final hours = dayHours[dayKey] ?? '';
    final isToday = todayEntry != null &&
        ((todayEntry.day.dayEn as String?) ?? '').trim().toLowerCase() ==
            dayKey;

    result.add(
      _HoursRow(
        day: locale == 'ar' ? model.day.dayAr : model.day.dayEn,
        hours: hours.isEmpty ? '' : hours,
        isToday: isToday,
      ),
    );
  }
  return result;
}
