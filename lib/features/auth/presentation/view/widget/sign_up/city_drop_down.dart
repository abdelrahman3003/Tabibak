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

    return AppDropdown<CityModel>(
      items: state.cities,
      value: state.cities
          .where((e) => e.id == state.cityId)
          .cast<CityModel?>()
          .firstOrNull,
      hint: AppStrings.selectCity,
      labelBuilder: (city) => context.locale.languageCode == "en"
          ? city.nameEn ?? ""
          : city.nameAr ?? "",
      prefixIcon: const Icon(Icons.location_city_outlined),
      onChanged: (city) {
        ref.read(signUpNotifierProvider.notifier).onCityChanged(city?.id);
      },
      validator: (value) {
        if (value == null) {
          return AppStrings.pleaseSelectCity;
        }
        return null;
      },
    );
  }
}
