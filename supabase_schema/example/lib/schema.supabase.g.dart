// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.supabase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: UserId.fromJson(json['id']),
  name: json['name'] as String,
  email: json['email'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id.toJson(),
  'name': instance.name,
  'email': instance.email,
  'created_at': instance.createdAt.toIso8601String(),
};

_CreateUserModel _$CreateUserModelFromJson(Map<String, dynamic> json) =>
    _CreateUserModel(
      id: UserId.fromJson(json['id']),
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$CreateUserModelToJson(_CreateUserModel instance) =>
    <String, dynamic>{
      'id': instance.id.toJson(),
      'name': instance.name,
      'email': instance.email,
      'created_at': instance.createdAt.toIso8601String(),
    };
