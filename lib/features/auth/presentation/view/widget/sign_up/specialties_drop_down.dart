import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/widgets/app_drop_dowm.dart';
import 'package:tabibak/features/home/data/model/specialty_model.dart';
import 'package:tabibak/features/home/presentation/manager/all_specialteis_provider/all_specialties_provider.dart';

class SpecialtiesDropDown extends ConsumerWidget {
  final void Function(SpecialtyModel?)? onSelected;
  final SpecialtyModel? value;
  final String? Function(SpecialtyModel?)? validator;

  const SpecialtiesDropDown({
    super.key,
    this.onSelected,
    this.value,
    this.validator,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(specialtiesNotifierProvider);

    return AppDropdown<SpecialtyModel>(
      hint: AppStrings.specialty,
      items: state.specialties ?? [],
      value: value,
      labelBuilder: (item) =>
          Localizations.localeOf(context).languageCode == 'ar'
              ? item.nameAr ?? ''
              : item.nameEn ?? '',
      onChanged: onSelected,
      validator: validator,
      prefixIcon: const Icon(Icons.medical_services_outlined, size: 24),
    );
  }
}
