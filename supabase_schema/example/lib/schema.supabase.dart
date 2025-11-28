// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// SupabaseTableGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// dart format width=80

// **************************************************************************

// SupabaseTableGenerator

// --------------------------------------------------------------------------
// Metadata:
// - Schema: UserSchema
// - Table: users
// - Base model: User
// - Base fields: 5
// - Models (1): CreateUserModel
// --------------------------------------------------------------------------

// ignore_for_file: invalid_annotation_target

import 'package:supabase_schema/supabase_schema.dart';

part 'schema.supabase.freezed.dart';

part 'schema.supabase.g.dart';

extension type UserId._(int value) {
  factory UserId.fromValue(int value) => UserId._(value);
  factory UserId.fromJson(dynamic value) {
    if (value is int) {
      return UserId._(value);
    } else if (value == null) {
      throw ArgumentError.notNull('value');
    } else {
      throw ArgumentError(
        'Value of UserId must be of type int, but was ${value.runtimeType}. Please provide the correct type.',
      );
    }
  }
  int toJson() => value;
  int call() => value;
}

@freezed
sealed class User with _$User {
  const User._();

  @JsonSerializable(explicitToJson: true)
  const factory User({
    @JsonKey(name: "id") required UserId id,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "email") required String email,
    @JsonKey(name: "created_at") required DateTime createdAt,
    @JsonKey(name: "joinUserId") required User joinUserId,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // These constrains can be helpful for queries, filter by etc.
  static const String tableName = "users";
  static const String idKey = "id";
  static const String nameKey = "name";
  static const String emailKey = "email";
  static const String createdAtKey = "created_at";
  static const String joinUserIdKey = "joinUserId";

  // These for safer select statements
  static String get selectColumns =>
      'id,name,email,created_at,joinUserId:${User.tableName}!join_user_id(${User.selectColumns})';
}

@freezed
sealed class CreateUserModel with _$CreateUserModel {
  const CreateUserModel._();

  @JsonSerializable(explicitToJson: true)
  const factory CreateUserModel({
    @JsonKey(name: "id") required UserId id,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "email") required String email,
    @JsonKey(name: "created_at") required DateTime createdAt,
    @JsonKey(name: "user") required User user,
    @JsonKey(name: "joinUser2Id") required User joinUser2Id,
  }) = _CreateUserModel;

  factory CreateUserModel.fromJson(Map<String, dynamic> json) =>
      _$CreateUserModelFromJson(json);

  static const String tableName = "users";

  static const String idKey = "id";
  static const String nameKey = "name";
  static const String emailKey = "email";
  static const String createdAtKey = "created_at";
  static const String userKey = "user";
  static const String joinUser2IdKey = "joinUser2Id";

  static String get selectColumns =>
      'id,name,email,created_at,user,joinUser2Id:${User.tableName}!join_user2_id(${User.selectColumns})';
}
