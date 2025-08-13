import 'package:json_annotation/json_annotation.dart';
import 'package:tabibak/features/home/domain/entites/specialise_model.dart';

part 'get_specialite_response.g.dart';

@JsonSerializable()
class GetSpecialiteResponse {
  @JsonKey(name: 'data')
  final List<SpecialiseModel> specialitesList;

  GetSpecialiteResponse({
    required this.specialitesList,
  });

  factory GetSpecialiteResponse.fromJson(Map<String, dynamic> json) =>
      _$GetSpecialiteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetSpecialiteResponseToJson(this);
}
