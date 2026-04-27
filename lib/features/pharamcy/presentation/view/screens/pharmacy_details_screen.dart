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

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: switch (state) {
        // Loading
        PharmacyDetailsState(isLoading: true) =>
          const Center(child: AppCircleIndicator()),

        // Error
        PharmacyDetailsState(errorMessage: final error) when error != null =>
          Center(child: Text(error)),

        // No data
        PharmacyDetailsState(pharmacy: null) =>
          Center(child: Text(AppStrings.unknownErrorOccurred)),

        // Success
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
                backgroundColor: const Color(0xFF2D7DD2),
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.arrow_back, color: Color(0xFF2D7DD2)),
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
                          color: const Color(0xFF2D7DD2),
                          child: const Icon(Icons.local_pharmacy,
                              size: 80, color: Colors.white54),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: .5),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Body Content ──────────────────────────────────────────────
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
