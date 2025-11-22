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
// - Base fields: 4
// - Models (1): CreateUserModel
// --------------------------------------------------------------------------

// ignore_for_file: invalid_annotation_target

import 'package:supabase_schema/supabase_schema.dart';

part 'schema.supabase.freezed.dart';

part 'schema.supabase.g.dart';

extension type UserId._(int id) {
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
  int toJson() => id;
  int call() => id;
  int get value => id;

  /// Creates an instance of UserId with a value of -1.
  /// This is used to represent an empty or invalid UserId for placeholder or default values of form fields.
  /// WARNING: This is not a valid UserId access it value through [value] or [toJson] will throw an error.
  factory UserId.empty() => UserId._(-1);
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
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // These constrains can be helpful for queries, filter by etc.
  static const String tableName = "users";
  static const String idKey = "id";
  static const String nameKey = "name";
  static const String emailKey = "email";
  static const String createdAtKey = "created_at";

  // These for safer select statements
  static String get selectColumns => 'id,name,email,created_at';
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
  }) = _CreateUserModel;

  factory CreateUserModel.fromJson(Map<String, dynamic> json) =>
      _$CreateUserModelFromJson(json);

  static const String tableName = "users";

  static const String idKey = "id";
  static const String nameKey = "name";
  static const String emailKey = "email";
  static const String createdAtKey = "created_at";

  static String get selectColumns => 'id,name,email,created_at';
}
