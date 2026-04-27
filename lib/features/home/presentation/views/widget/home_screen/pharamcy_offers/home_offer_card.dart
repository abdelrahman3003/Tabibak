import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/function/language_state.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/pharamcy/data/models/pharmacy_offer_model.dart';

class HomeOfferCard extends StatelessWidget {
  final PharmacyOfferModel offer;

  const HomeOfferCard({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          Routes.pharmacyDetailsScreen,
          arguments: offer.pharmacyId,
        );
      },
      child: Container(
        width: 220.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + Discount
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    offer.pharmacy?.image ?? "",
                    height: 100.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 100.h,
                      color: const Color(0xFF2D7DD2).withOpacity(0.15),
                      child: const Icon(
                        Icons.local_pharmacy,
                        color: Color(0xFF2D7DD2),
                        size: 36,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D7DD2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isArabic(context)
                          ? offer.titleAr ?? ""
                          : offer.titleEn ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Info
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic(context)
                        ? offer.pharmacy?.addressAr ?? ""
                        : offer.pharmacy?.addressEn ?? "",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.hBox,
                  Row(
                    children: [
                      const Icon(
                        Icons.local_pharmacy_outlined,
                        size: 14,
                        color: Color(0xFF2D7DD2),
                      ),
                      4.wBox,
                      Expanded(
                        child: Text(
                          offer.pharmacy?.name ?? "",
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
