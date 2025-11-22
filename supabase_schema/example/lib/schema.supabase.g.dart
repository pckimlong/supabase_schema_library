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
  joinUserId: User.fromJson(json['joinUserId'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id.toJson(),
  'name': instance.name,
  'email': instance.email,
  'created_at': instance.createdAt.toIso8601String(),
  'joinUserId': instance.joinUserId.toJson(),
};

_CreateUserModel _$CreateUserModelFromJson(Map<String, dynamic> json) =>
    _CreateUserModel(
      id: UserId.fromJson(json['id']),
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      joinUser2Id: User.fromJson(json['joinUser2Id'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateUserModelToJson(_CreateUserModel instance) =>
    <String, dynamic>{
      'id': instance.id.toJson(),
      'name': instance.name,
      'email': instance.email,
      'created_at': instance.createdAt.toIso8601String(),
      'user': instance.user.toJson(),
      'joinUser2Id': instance.joinUser2Id.toJson(),
    };
