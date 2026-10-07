import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/widgets/app_drop_dowm.dart';
import 'package:tabibak/features/auth/presentation/manager/sign%20up/sign_up_provider.dart';
import 'package:tabibak/features/home/data/model/clinic_model.dart';

class CityDropdown extends ConsumerWidget {
  const CityDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signUpNotifierProvider);

    return Column(
      children: [
        AppDropdown<CityModel>(
          items: state.cities.where((e) => e.type == 'markaz').toList(),
          value:
              state.cities.where((e) => e.id == state.districtId).firstOrNull,
          hint: AppStrings.selectDistrict,
          labelBuilder: (city) => context.locale.languageCode == "en"
              ? city.nameEn ?? city.nameAr ?? ''
              : city.nameAr ?? city.nameEn ?? '',
          prefixIcon: const Icon(Icons.location_city_outlined),
          onChanged: (city) {
            ref
                .read(signUpNotifierProvider.notifier)
                .onDistrictChanged(city?.id);
          },
          validator: (value) {
            if (value == null) {
              return AppStrings.pleaseSelectDistrict;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        if (state.districtId != null)
          AppDropdown<CityModel>(
            items: state.cities
                .where((e) => e.parentId == state.districtId)
                .toList(),
            value:
                state.cities.where((e) => e.id == state.villageId).firstOrNull,
            hint: AppStrings.selectVillage,
            labelBuilder: (village) => context.locale.languageCode == "en"
                ? village.nameEn ?? village.nameAr ?? ''
                : village.nameAr ?? village.nameEn ?? '',
            prefixIcon: const Icon(Icons.landscape_outlined),
            onChanged: (village) {
              ref
                  .read(signUpNotifierProvider.notifier)
                  .onVillageChanged(village?.id);
            },
          ),
      ],
    );
  }
}
