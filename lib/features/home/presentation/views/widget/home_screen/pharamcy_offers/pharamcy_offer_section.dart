import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/home/presentation/manager/home_provider/home_provider.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/pharamcy_offers/home_offer_card.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/title_text.dart';

class PharmacyOffersSection extends StatelessWidget {
  const PharmacyOffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final offers = ref.watch(
          homeControllerProvider.select(
            (state) => state.pharmacyOffers ?? [],
          ),
        );
        if (offers.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(title: AppStrings.pharmacyOffers),
            12.hBox,
            SizedBox(
              height: 170.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: offers.length,
                separatorBuilder: (_, __) => 12.wBox,
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  return HomeOfferCard(
                    offer: offer,
                  );
                },
              ),
            ),
            20.hBox,
          ],
        );
      },
    );
  }
}
