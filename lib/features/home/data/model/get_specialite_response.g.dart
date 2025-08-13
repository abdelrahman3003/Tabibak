// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_specialite_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSpecialiteResponse _$GetSpecialiteResponseFromJson(
        Map<String, dynamic> json) =>
    GetSpecialiteResponse(
      specialitesList: (json['data'] as List<dynamic>)
          .map((e) => SpecialiseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetSpecialiteResponseToJson(
        GetSpecialiteResponse instance) =>
    <String, dynamic>{
      'data': instance.specialitesList,
    };
