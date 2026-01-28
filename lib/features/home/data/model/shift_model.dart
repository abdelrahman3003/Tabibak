import 'package:json_annotation/json_annotation.dart';

part 'shift_model.g.dart';

@JsonSerializable()
class ShiftModel {
  final int id;
  @JsonKey(name: 'start')
  final String? start;
  @JsonKey(name: 'end')
  final String? end;

  ShiftModel({
    required this.id,
    this.start,
    this.end,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShiftModelToJson(this);
}
