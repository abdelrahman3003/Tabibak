import 'dart:io';

void main() {
  final file = File('lib/features/home/presentation/views/widget/home_screen/doctors_list/doctor_item.dart');
  String content = file.readAsStringSync();

  final rootOld = '''
  Widget _buildRoot(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: 8.radius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: _decoration(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            16.wBox,
            Expanded(child: _buildInfo(context)),
          ],
        ),
      ),
    );
  }
''';

  final rootNew = '''
  Widget _buildRoot(BuildContext context) {
    final hasNewOffer =
        doctorSummary.offers != null && doctorSummary.offers!.isNotEmpty;
    final hasOldOffer = doctorSummary.clinic?.offer != null &&
        doctorSummary.clinic!.offer!.isNotEmpty;
    final hasAnyOffer = hasNewOffer || hasOldOffer;

    String? offerTitle;
    if (hasNewOffer) {
      offerTitle = context.locale.languageCode == 'ar'
          ? doctorSummary.offers!.first.titleAr ?? 'Special Offer'.tr()
          : doctorSummary.offers!.first.titleEn ?? 'Special Offer'.tr();
    } else if (hasOldOffer) {
      offerTitle = doctorSummary.clinic!.offer;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.radius20,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: _decoration(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(),
                16.wBox,
                Expanded(child: _buildInfo(context)),
              ],
            ),
          ),
          if (hasAnyOffer && offerTitle != null && offerTitle.isNotEmpty)
            PositionedDirectional(
              top: 0,
              end: 0,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 160),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: const BorderRadiusDirectional.only(
                    topEnd: Radius.circular(20),
                    bottomStart: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_offer_rounded,
                      size: 14,
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        offerTitle,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onTertiary,
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
''';

  final priceOld = '''
  Widget _buildPriceAndButton(BuildContext context) {
    final hasNewOffer =
        doctorSummary.offers != null && doctorSummary.offers!.isNotEmpty;
    final hasOldOffer = doctorSummary.clinic?.offer != null &&
        doctorSummary.clinic!.offer!.isNotEmpty;
    final hasAnyOffer = hasNewOffer || hasOldOffer;

    return Row(
      children: [
        Expanded(
          child: hasAnyOffer
              ? Row(
                  children: [
                    Icon(Icons.local_offer,
                        size: 14,
                        color: Theme.of(context).colorScheme.tertiary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        hasNewOffer
                            ? (context.locale.languageCode == 'ar'
                                ? doctorSummary.offers!.first.titleAr ??
                                    'Special Offer'.tr()
                                : doctorSummary.offers!.first.titleEn ??
                                    'Special Offer'.tr())
                            : doctorSummary.clinic!.offer!,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        if (doctorSummary.visitsCount != null && doctorSummary.visitsCount! > 1)
          Row(
            children: [
              const Icon(Icons.group, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                "\${doctorSummary.visitsCount} \${"Visits".tr()}",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
      ],
    );
  }
''';

  final priceNew = '''
  Widget _buildPriceAndButton(BuildContext context) {
    if (doctorSummary.visitsCount == null || doctorSummary.visitsCount! <= 1) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        const Spacer(),
        Row(
          children: [
            const Icon(Icons.group, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              "\${doctorSummary.visitsCount} \${"Visits".tr()}",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    );
  }
''';

  content = content.replaceFirst(rootOld.trim(), rootNew.trim());
  content = content.replaceFirst(priceOld.trim(), priceNew.trim());

  file.writeAsStringSync(content);
}
