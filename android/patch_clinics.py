import os

filepath = "/Users/hello/development/Projects/Tabibak/lib/features/doctor/presentation/views/widget/doctor_details_body.dart"

with open(filepath, 'r') as f:
    content = f.read()

# 1. Add imports
if "clinic_info_section.dart" not in content:
    content = content.replace("import 'package:tabibak/features/doctor/presentation/views/widget/doctor_review_section.dart';",
                              "import 'package:tabibak/features/doctor/presentation/views/widget/doctor_review_section.dart';\nimport 'package:tabibak/features/doctor/presentation/views/widget/clinic_info_section.dart';\nimport 'package:tabibak/features/doctor/presentation/views/widget/schedule_section.dart';")

# 2. Modify _ClinicsSection
old_clinics_section = """class _ClinicsSection extends StatelessWidget {
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
}"""

new_clinics_section = """class _ClinicsSection extends StatelessWidget {
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

    if (clinics.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(title: AppStrings.clinicDetails),
          10.hBox,
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.14),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClinicInfoSection(clinic: clinics.first),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(height: 1, thickness: 1),
                ),
                ScheduleSection(workingDayList: clinics.first.workingDays),
              ],
            ),
          ),
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
}"""

content = content.replace(old_clinics_section, new_clinics_section)

with open(filepath, 'w') as f:
    f.write(content)

print("Patch applied successfully.")
