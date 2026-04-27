class PharmacyModel {
  final int? id;
  final String? name;
  final String? addressAr;
  final String? addressEn;
  final String? image;
  final String? phone;
  final String? timeStart;
  final String? timeEnd;
  final String? doctorName;
  final String? createdAt;

  PharmacyModel({
    this.id,
    this.name,
    this.addressAr,
    this.addressEn,
    this.image,
    this.phone,
    this.doctorName,
    this.timeStart,
    this.timeEnd,
    this.createdAt,
  });

  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    return PharmacyModel(
      id: json['id'],
      name: json['name'],
      addressAr: json['address_ar'],
      addressEn: json['address_en'],
      phone: json['phone'],
      image: json['image'],
      doctorName: json['doctor_name'],
      timeStart: json['time_start'],
      timeEnd: json['time_end'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address_ar': addressAr,
      'address_en': addressEn,
      'image': image,
      'time_start': timeStart,
      'time_end': timeEnd,
    };
  }
}
