import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/helper/app_snack_bar.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/core/widgets/app_drop_dowm.dart';
import 'package:tabibak/features/auth/presentation/manager/selected_city/city_provider.dart';
import 'package:tabibak/features/home/data/model/clinic_model.dart';

class SelectCityScreen extends ConsumerStatefulWidget {
  const SelectCityScreen({super.key});

  @override
  ConsumerState<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends ConsumerState<SelectCityScreen> {
  CityModel? selectedCity;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(cityProvider.notifier).getCities();
    });
  }

  @override
  Widget build(BuildContext context) {
    log("-------- build city user id.  ${Supabase.instance.client.auth.currentUser?.id}");
    ref.listen(cityProvider, (previous, next) {
      if (next.isSaved) {
        context.pushNamedAndRemoveUntil(
          Routes.layoutScreen,
          (route) => false,
        );
      }

      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        showErrorSnackBar(next.errorMessage!);
      }
    });

    final state = ref.watch(cityProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.selectCity),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.city,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : AppDropdown<CityModel>(
                    items: state.cities,
                    value: selectedCity,
                    hint: AppStrings.selectCity,
                    labelBuilder: (city) {
                      return context.locale.languageCode == "en"
                          ? city.nameEn ?? city.nameAr ?? ''
                          : city.nameAr ?? city.nameEn ?? '';
                    },
                    prefixIcon: const Icon(
                      Icons.location_city_outlined,
                      color: AppColors.primary,
                    ),
                    onChanged: (city) {
                      setState(() {
                        selectedCity = city;
                      });

                      ref.read(cityProvider.notifier).updateCity(city?.id);
                    },
                    validator: (value) {
                      if (value == null) {
                        return AppStrings.pleaseSelectCity;
                      }
                      return null;
                    },
                  ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: AppButton(
                title: AppStrings.confirm,
                isLoading: state.isSaving,
                onPressed: selectedCity == null || state.isSaving
                    ? null
                    : () async {
                        await ref.read(cityProvider.notifier).saveCity();
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
