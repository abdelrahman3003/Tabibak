class PharmacyEmployeeModel {
  final int? id;
  final String? name;
  final int? age;
  final String? startTime;
  final String? endTime;
  final int? pharmacyId;
  final String? createdAt;
  final String? image;
  final String? phone;
  PharmacyEmployeeModel(
      {this.id,
      this.name,
      this.age,
      this.startTime,
      this.endTime,
      this.pharmacyId,
      this.createdAt,
      this.image,
      this.phone});

  factory PharmacyEmployeeModel.fromJson(Map<String, dynamic> json) {
    return PharmacyEmployeeModel(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      pharmacyId: json['pharmacy_id'],
      image: json['image'],
      phone: json['phone'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'start_time': startTime,
      'end_time': endTime,
      'pharmacy_id': pharmacyId,
    };
  }
}
