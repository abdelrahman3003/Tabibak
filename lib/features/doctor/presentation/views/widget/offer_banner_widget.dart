import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak/features/home/data/model/offer_model.dart';

class OfferBannerWidget extends StatelessWidget {
  const OfferBannerWidget({super.key, required this.offer});
  final OfferModel offer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = context.locale.languageCode;
    final title = locale == 'ar' ? offer.titleAr : offer.titleEn;
    final details = locale == 'ar' ? offer.detailsAr : offer.detailsEn;

    if (title == null || title.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.local_offer, color: theme.colorScheme.onTertiaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onTertiaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (details != null && details.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      details,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onTertiaryContainer
                            .withValues(alpha: .8),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
