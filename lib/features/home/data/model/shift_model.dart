import 'package:json_annotation/json_annotation.dart';

part 'shift_model.g.dart';

@JsonSerializable()
class ShiftModel {
  final int id;
  @JsonKey(name: 'morning_start')
  final String? morningStart;
  @JsonKey(name: 'morning_end')
  final String? morningEnd;
  @JsonKey(name: 'evening_start')
  final String? eveningStart;
  @JsonKey(name: 'evening_end')
  final String? eveningEnd;

  ShiftModel({
    required this.id,
    this.morningStart,
    this.morningEnd,
    this.eveningStart,
    this.eveningEnd,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShiftModelToJson(this);
}
