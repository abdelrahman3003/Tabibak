import 'package:tabibak/features/pharamcy/data/models/pharmacy_model.dart';

class PharmacyOfferModel {
  final int? id;
  final String? titleAr;
  final String? titleEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? startDate;
  final String? endDate;
  final int? pharmacyId;
  final String? createdAt;
  final PharmacyModel? pharmacy;
  final double? discount;
  PharmacyOfferModel({
    this.id,
    this.titleEn,
    this.titleAr,
    this.descriptionAr,
    this.descriptionEn,
    this.discount,
    this.startDate,
    this.endDate,
    this.pharmacyId,
    this.createdAt,
    this.pharmacy,
  });

  factory PharmacyOfferModel.fromJson(Map<String, dynamic> json) {
    return PharmacyOfferModel(
      id: json['id'],
      titleAr: json['title_ar'],
      titleEn: json['title_en'],
      discount: json['discount'],
      descriptionAr: json['description_ar'],
      descriptionEn: json['description_en'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      pharmacyId: json['pharmacy_id'],
      createdAt: json['created_at'],
      pharmacy: json['pharmacies'] != null
          ? PharmacyModel.fromJson(json['pharmacies'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title_ar': titleAr,
      'title_en': titleEn,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'start_date': startDate,
      'end_date': endDate,
      'pharmacy_id': pharmacyId,
    };
  }
}
