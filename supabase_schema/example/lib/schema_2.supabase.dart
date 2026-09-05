// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// SupabaseTableGenerator
// **************************************************************************

// --------------------------------------------------------------------------
// Metadata:
// - Schema: AccountSchema
// - Table: accounts
// - Base model: Account
// - Base fields: 4
// - Models (0): none
// --------------------------------------------------------------------------

// ignore_for_file: type=lint, invalid_annotation_target, unused_import

import 'schema_2.dart';

import 'package:example/schema.supabase.dart';

import 'package:supabase_schema/supabase_schema.dart';

part 'schema_2.supabase.freezed.dart';

part 'schema_2.supabase.g.dart';

extension type AccountId._(int value) {
  factory AccountId.fromValue(int value) => AccountId._(value);
  factory AccountId.fromJson(dynamic value) {
    if (value is int) {
      return AccountId._(value);
    } else if (value == null) {
      throw ArgumentError.notNull('value');
    } else {
      throw ArgumentError(
        'Value of AccountId must be of type int, but was ${value.runtimeType}. Please provide the correct type.',
      );
    }
  }
  int toJson() => value;
  int call() => value;
}

@freezed
sealed class Account with _$Account {
  const Account._();

  @JsonSerializable(explicitToJson: true)
  const factory Account({
    @JsonKey(name: "id") required AccountId id,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "created_at") required DateTime createdAt,
    @JsonKey(name: "user") required User owner,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  // These constrains can be helpful for queries, filter by etc.
  static const String tableName = "accounts";
  static const String idKey = "id";
  static const String nameKey = "name";
  static const String createdAtKey = "created_at";
  static const String userKey = "user";

  // These for safer select statements
  static String get selectColumns => 'id,name,created_at,user';
}
