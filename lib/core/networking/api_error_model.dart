import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error_model.g.dart';

@JsonSerializable()
class ApiErrorModel {
  final String? message;
  final int? code;
  @JsonKey(name: "data")
  final dynamic errors;

  ApiErrorModel({required this.message, this.code, this.errors});
  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);
  Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);
  String getallResponseMessage() {
    if (errors == null || errors!.isEmpty) return "Unknwon error eccured";
    final errorMessage = errors!.entries.map(
      (e) {
        final value = e.value;
        return "${value.join(',')}";
      },
    ).join('\n');
    return errorMessage;
  }
}
