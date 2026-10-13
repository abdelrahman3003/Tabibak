import 'package:flutter_test/flutter_test.dart';
import 'package:tabibak/features/home/data/model/offer_model.dart';
import 'package:tabibak/features/pharamcy/data/models/pharmacy_offer_model.dart';

void main() {
  group('OfferModel expiry tests', () {
    test('expired offer returns isExpired = true and isValid = false', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 1)).toIso8601String();
      final offer = OfferModel(
        id: 1,
        titleEn: 'Expired Offer',
        expiryDate: pastDate,
        isActive: true,
      );

      expect(offer.isExpired, isTrue);
      expect(offer.isValid, isFalse);
    });

    test('future offer returns isExpired = false and isValid = true', () {
      final futureDate = DateTime.now().add(const Duration(days: 5)).toIso8601String();
      final offer = OfferModel(
        id: 2,
        titleEn: 'Active Offer',
        expiryDate: futureDate,
        isActive: true,
      );

      expect(offer.isExpired, isFalse);
      expect(offer.isValid, isTrue);
    });

    test('null expiryDate falls back to endDate', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 2)).toIso8601String();
      final offer = OfferModel(
        id: 3,
        titleEn: 'Fallback Expired',
        endDate: pastDate,
        isActive: true,
      );

      expect(offer.isExpired, isTrue);
      expect(offer.isValid, isFalse);
    });
  });

  group('PharmacyOfferModel expiry tests', () {
    test('expired pharmacy offer returns isExpired = true and isValid = false', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 1)).toIso8601String();
      final offer = PharmacyOfferModel(
        id: 1,
        titleEn: 'Expired Pharmacy Offer',
        expiryDate: pastDate,
      );

      expect(offer.isExpired, isTrue);
      expect(offer.isValid, isFalse);
    });

    test('active pharmacy offer returns isExpired = false and isValid = true', () {
      final futureDate = DateTime.now().add(const Duration(days: 5)).toIso8601String();
      final offer = PharmacyOfferModel(
        id: 2,
        titleEn: 'Active Pharmacy Offer',
        expiryDate: futureDate,
      );

      expect(offer.isExpired, isFalse);
      expect(offer.isValid, isTrue);
    });
  });
}
