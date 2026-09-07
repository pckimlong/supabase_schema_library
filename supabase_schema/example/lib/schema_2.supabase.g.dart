// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema_2.supabase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Account _$AccountFromJson(Map<String, dynamic> json) => _Account(
  id: AccountId.fromJson(json['id']),
  name: json['name'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  owner: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AccountToJson(_Account instance) => <String, dynamic>{
  'id': instance.id.toJson(),
  'name': instance.name,
  'created_at': instance.createdAt.toIso8601String(),
  'user': instance.owner.toJson(),
};
