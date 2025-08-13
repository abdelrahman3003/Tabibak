// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserDataResponse _$GetUserDataResponseFromJson(Map<String, dynamic> json) =>
    GetUserDataResponse(
      userModelList: (json['data'] as List<dynamic>)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetUserDataResponseToJson(
        GetUserDataResponse instance) =>
    <String, dynamic>{
      'data': instance.userModelList,
    };
