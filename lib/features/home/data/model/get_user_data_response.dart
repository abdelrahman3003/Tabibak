import 'package:json_annotation/json_annotation.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';

part 'get_user_data_response.g.dart';

@JsonSerializable()
class GetUserDataResponse {
  @JsonKey(name: 'data')
  final List<UserModel> userModelList;

  GetUserDataResponse({
    required this.userModelList,
  });

  factory GetUserDataResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserDataResponseToJson(this);
}
