import 'package:json_annotation/json_annotation.dart';
import 'package:tabibak/features/home/data/model/clinic_model.dart';
import 'package:tabibak/features/home/data/model/comment_model.dart';
import 'package:tabibak/features/home/data/model/education_model.dart';
import 'package:tabibak/features/home/data/model/rating_model.dart';
import 'package:tabibak/features/home/data/model/specialty_model.dart';

part 'doctor_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DoctorModel {
  @JsonKey(name: 'doctor_id')
  final String doctorId;
  final String? name;
  final String? image;
  @JsonKey(name: 'avg_rating')
  final double? avrRating;
  @JsonKey(name: 'ratings_count')
  final int? ratingsCount;
  @JsonKey(name: 'bio_ar')
  final String? bioAr;
  @JsonKey(name: 'bio_en')
  final String? bioEn;
  final String? phone;
  final String? email;
  @JsonKey(name: 'specialties')
  final SpecialtyModel? specialty;
  final EducationModel? education;
  @JsonKey(name: 'clinic_data')
  final ClinicModel? clinic;
  final List<CommentModel>? comments;
  final List<RatingModel>? ratings;
  DoctorModel({
    required this.doctorId,
    this.name,
    this.image,
    this.bioAr,
    this.bioEn,
    this.avrRating,
    this.ratingsCount,
    this.specialty,
    this.phone,
    this.email,
    this.clinic,
    this.comments,
    this.education,
    this.ratings,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);
}
