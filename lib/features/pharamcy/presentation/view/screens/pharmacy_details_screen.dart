import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/widgets/app_circle_indicator.dart';
import 'package:tabibak/features/pharamcy/presentation/manager/pharamcy_details_states.dart';
import 'package:tabibak/features/pharamcy/presentation/manager/pharamcy_detalis_provider.dart';
import 'package:tabibak/features/pharamcy/presentation/view/widgets/pharmacy_offer_body.dart';

class PharmacyDetailsScreen extends ConsumerWidget {
  final int pharmacyId;
  const PharmacyDetailsScreen({required this.pharmacyId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pharmacyDetailsControllerProvider(pharmacyId));
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: switch (state) {
        PharmacyDetailsState(isLoading: true) =>
          const Center(child: AppCircleIndicator()),
        PharmacyDetailsState(errorMessage: final error) when error != null =>
          Center(child: Text(error)),
        PharmacyDetailsState(pharmacy: null) =>
          Center(child: Text(AppStrings.unknownErrorOccurred)),
        PharmacyDetailsState(
          pharmacy: final pharmacy,
          offers: final offers,
          employees: final employees,
        ) =>
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                backgroundColor: colorScheme.primary,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        pharmacy!.image ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: colorScheme.primary,
                          child: const Icon(
                            Icons.local_pharmacy,
                            size: 80,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(
                                isDark ? 0.85 : 0.5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PharmacyOfferBody(
                pharmacyModel: pharmacy,
                offers: offers,
                employees: employees,
              ),
            ],
          ),
      },
    );
  }
}
