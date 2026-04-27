import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/function/language_state.dart';
import 'package:tabibak/features/pharamcy/data/models/pharamcy_employee_model.dart';
import 'package:tabibak/features/pharamcy/data/models/pharmacy_model.dart';
import 'package:tabibak/features/pharamcy/data/models/pharmacy_offer_model.dart';
import 'package:tabibak/features/pharamcy/presentation/view/widgets/employee_chip.dart';
import 'package:tabibak/features/pharamcy/presentation/view/widgets/info_card.dart';
import 'package:tabibak/features/pharamcy/presentation/view/widgets/offer_card.dart';

class PharmacyOfferBody extends StatelessWidget {
  final List<PharmacyOfferModel> offers;
  final List<PharmacyEmployeeModel> employees;
  final PharmacyModel pharmacyModel;

  const PharmacyOfferBody({
    super.key,
    required this.offers,
    required this.employees,
    required this.pharmacyModel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Pharmacy Name ───────────────────────────────────────────────
            Text(
              pharmacyModel.name ?? '',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 20),

            // ── Info Cards ──────────────────────────────────────────────────
            InfoCard(
              icon: Icons.location_on_outlined,
              label: AppStrings.address,
              value: isArabic(context)
                  ? pharmacyModel.addressAr ?? ''
                  : pharmacyModel.addressEn ?? '',
              iconColor: colorScheme.error,
            ),
            const SizedBox(height: 12),
            InfoCard(
              icon: Icons.access_time_outlined,
              label: AppStrings.workingHours,
              value:
                  '${pharmacyModel.timeStart ?? ''} – ${pharmacyModel.timeEnd ?? ''}',
              iconColor: colorScheme.secondary,
            ),
            const SizedBox(height: 12),
            InfoCard(
              icon: Icons.phone_outlined,
              label: AppStrings.phone,
              value: pharmacyModel.phone ?? '',
              iconColor: colorScheme.primary,
            ),

            // ── Employees Section ───────────────────────────────────────────
            if (employees.isNotEmpty) ...[
              const SizedBox(height: 28),
              Text(
                AppStrings.ourTeam,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: employees.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return EmployeeChip(employee: employees[index]);
                  },
                ),
              ),
            ],

            // ── Offers Section ──────────────────────────────────────────────
            const SizedBox(height: 28),
            Text(
              AppStrings.availableOffers,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            if (offers.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    AppStrings.noOffersAvailable,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: offers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return OfferCard(offer: offers[index]);
                },
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
