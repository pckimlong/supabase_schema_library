// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schema.supabase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

@JsonKey(name: "id") UserId get id;@JsonKey(name: "name") String get name;@JsonKey(name: "email") String get email;@JsonKey(name: "created_at") DateTime get createdAt;@JsonKey(name: "joinUserId") User get joinUserId;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.joinUserId, joinUserId) || other.joinUserId == joinUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,createdAt,joinUserId);

@override
String toString() {
  return 'User(id: $id, name: $name, email: $email, createdAt: $createdAt, joinUserId: $joinUserId)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") UserId id,@JsonKey(name: "name") String name,@JsonKey(name: "email") String email,@JsonKey(name: "created_at") DateTime createdAt,@JsonKey(name: "joinUserId") User joinUserId
});


$UserCopyWith<$Res> get joinUserId;

}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? createdAt = null,Object? joinUserId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as UserId,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,joinUserId: null == joinUserId ? _self.joinUserId : joinUserId // ignore: cast_nullable_to_non_nullable
as User,
  ));
}
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get joinUserId {
  
  return $UserCopyWith<$Res>(_self.joinUserId, (value) {
    return _then(_self.copyWith(joinUserId: value));
  });
}
}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  UserId id, @JsonKey(name: "name")  String name, @JsonKey(name: "email")  String email, @JsonKey(name: "created_at")  DateTime createdAt, @JsonKey(name: "joinUserId")  User joinUserId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.createdAt,_that.joinUserId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  UserId id, @JsonKey(name: "name")  String name, @JsonKey(name: "email")  String email, @JsonKey(name: "created_at")  DateTime createdAt, @JsonKey(name: "joinUserId")  User joinUserId)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.name,_that.email,_that.createdAt,_that.joinUserId);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  UserId id, @JsonKey(name: "name")  String name, @JsonKey(name: "email")  String email, @JsonKey(name: "created_at")  DateTime createdAt, @JsonKey(name: "joinUserId")  User joinUserId)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.createdAt,_that.joinUserId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _User extends User {
  const _User({@JsonKey(name: "id") required this.id, @JsonKey(name: "name") required this.name, @JsonKey(name: "email") required this.email, @JsonKey(name: "created_at") required this.createdAt, @JsonKey(name: "joinUserId") required this.joinUserId}): super._();
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override@JsonKey(name: "id") final  UserId id;
@override@JsonKey(name: "name") final  String name;
@override@JsonKey(name: "email") final  String email;
@override@JsonKey(name: "created_at") final  DateTime createdAt;
@override@JsonKey(name: "joinUserId") final  User joinUserId;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.joinUserId, joinUserId) || other.joinUserId == joinUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,createdAt,joinUserId);

@override
String toString() {
  return 'User(id: $id, name: $name, email: $email, createdAt: $createdAt, joinUserId: $joinUserId)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") UserId id,@JsonKey(name: "name") String name,@JsonKey(name: "email") String email,@JsonKey(name: "created_at") DateTime createdAt,@JsonKey(name: "joinUserId") User joinUserId
});


@override $UserCopyWith<$Res> get joinUserId;

}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? createdAt = null,Object? joinUserId = null,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as UserId,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,joinUserId: null == joinUserId ? _self.joinUserId : joinUserId // ignore: cast_nullable_to_non_nullable
as User,
  ));
}

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get joinUserId {
  
  return $UserCopyWith<$Res>(_self.joinUserId, (value) {
    return _then(_self.copyWith(joinUserId: value));
  });
}
}


/// @nodoc
mixin _$CreateUserModel {

@JsonKey(name: "id") UserId get id;@JsonKey(name: "name") String get name;@JsonKey(name: "email") String get email;@JsonKey(name: "created_at") DateTime get createdAt;@JsonKey(name: "user") User get user;@JsonKey(name: "joinUser2Id") User get joinUser2Id;
/// Create a copy of CreateUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateUserModelCopyWith<CreateUserModel> get copyWith => _$CreateUserModelCopyWithImpl<CreateUserModel>(this as CreateUserModel, _$identity);

  /// Serializes this CreateUserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.user, user) || other.user == user)&&(identical(other.joinUser2Id, joinUser2Id) || other.joinUser2Id == joinUser2Id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,createdAt,user,joinUser2Id);

@override
String toString() {
  return 'CreateUserModel(id: $id, name: $name, email: $email, createdAt: $createdAt, user: $user, joinUser2Id: $joinUser2Id)';
}


}

/// @nodoc
abstract mixin class $CreateUserModelCopyWith<$Res>  {
  factory $CreateUserModelCopyWith(CreateUserModel value, $Res Function(CreateUserModel) _then) = _$CreateUserModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") UserId id,@JsonKey(name: "name") String name,@JsonKey(name: "email") String email,@JsonKey(name: "created_at") DateTime createdAt,@JsonKey(name: "user") User user,@JsonKey(name: "joinUser2Id") User joinUser2Id
});


$UserCopyWith<$Res> get user;$UserCopyWith<$Res> get joinUser2Id;

}
/// @nodoc
class _$CreateUserModelCopyWithImpl<$Res>
    implements $CreateUserModelCopyWith<$Res> {
  _$CreateUserModelCopyWithImpl(this._self, this._then);

  final CreateUserModel _self;
  final $Res Function(CreateUserModel) _then;

/// Create a copy of CreateUserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? createdAt = null,Object? user = null,Object? joinUser2Id = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as UserId,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,joinUser2Id: null == joinUser2Id ? _self.joinUser2Id : joinUser2Id // ignore: cast_nullable_to_non_nullable
as User,
  ));
}
/// Create a copy of CreateUserModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of CreateUserModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get joinUser2Id {
  
  return $UserCopyWith<$Res>(_self.joinUser2Id, (value) {
    return _then(_self.copyWith(joinUser2Id: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateUserModel].
extension CreateUserModelPatterns on CreateUserModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateUserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateUserModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateUserModel value)  $default,){
final _that = this;
switch (_that) {
case _CreateUserModel():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateUserModel value)?  $default,){
final _that = this;
switch (_that) {
case _CreateUserModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  UserId id, @JsonKey(name: "name")  String name, @JsonKey(name: "email")  String email, @JsonKey(name: "created_at")  DateTime createdAt, @JsonKey(name: "user")  User user, @JsonKey(name: "joinUser2Id")  User joinUser2Id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateUserModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.createdAt,_that.user,_that.joinUser2Id);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  UserId id, @JsonKey(name: "name")  String name, @JsonKey(name: "email")  String email, @JsonKey(name: "created_at")  DateTime createdAt, @JsonKey(name: "user")  User user, @JsonKey(name: "joinUser2Id")  User joinUser2Id)  $default,) {final _that = this;
switch (_that) {
case _CreateUserModel():
return $default(_that.id,_that.name,_that.email,_that.createdAt,_that.user,_that.joinUser2Id);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  UserId id, @JsonKey(name: "name")  String name, @JsonKey(name: "email")  String email, @JsonKey(name: "created_at")  DateTime createdAt, @JsonKey(name: "user")  User user, @JsonKey(name: "joinUser2Id")  User joinUser2Id)?  $default,) {final _that = this;
switch (_that) {
case _CreateUserModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.createdAt,_that.user,_that.joinUser2Id);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CreateUserModel extends CreateUserModel {
  const _CreateUserModel({@JsonKey(name: "id") required this.id, @JsonKey(name: "name") required this.name, @JsonKey(name: "email") required this.email, @JsonKey(name: "created_at") required this.createdAt, @JsonKey(name: "user") required this.user, @JsonKey(name: "joinUser2Id") required this.joinUser2Id}): super._();
  factory _CreateUserModel.fromJson(Map<String, dynamic> json) => _$CreateUserModelFromJson(json);

@override@JsonKey(name: "id") final  UserId id;
@override@JsonKey(name: "name") final  String name;
@override@JsonKey(name: "email") final  String email;
@override@JsonKey(name: "created_at") final  DateTime createdAt;
@override@JsonKey(name: "user") final  User user;
@override@JsonKey(name: "joinUser2Id") final  User joinUser2Id;

/// Create a copy of CreateUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateUserModelCopyWith<_CreateUserModel> get copyWith => __$CreateUserModelCopyWithImpl<_CreateUserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateUserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.user, user) || other.user == user)&&(identical(other.joinUser2Id, joinUser2Id) || other.joinUser2Id == joinUser2Id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,createdAt,user,joinUser2Id);

@override
String toString() {
  return 'CreateUserModel(id: $id, name: $name, email: $email, createdAt: $createdAt, user: $user, joinUser2Id: $joinUser2Id)';
}


}

/// @nodoc
abstract mixin class _$CreateUserModelCopyWith<$Res> implements $CreateUserModelCopyWith<$Res> {
  factory _$CreateUserModelCopyWith(_CreateUserModel value, $Res Function(_CreateUserModel) _then) = __$CreateUserModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") UserId id,@JsonKey(name: "name") String name,@JsonKey(name: "email") String email,@JsonKey(name: "created_at") DateTime createdAt,@JsonKey(name: "user") User user,@JsonKey(name: "joinUser2Id") User joinUser2Id
});


@override $UserCopyWith<$Res> get user;@override $UserCopyWith<$Res> get joinUser2Id;

}
/// @nodoc
class __$CreateUserModelCopyWithImpl<$Res>
    implements _$CreateUserModelCopyWith<$Res> {
  __$CreateUserModelCopyWithImpl(this._self, this._then);

  final _CreateUserModel _self;
  final $Res Function(_CreateUserModel) _then;

/// Create a copy of CreateUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? createdAt = null,Object? user = null,Object? joinUser2Id = null,}) {
  return _then(_CreateUserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as UserId,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,joinUser2Id: null == joinUser2Id ? _self.joinUser2Id : joinUser2Id // ignore: cast_nullable_to_non_nullable
as User,
  ));
}

/// Create a copy of CreateUserModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of CreateUserModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get joinUser2Id {
  
  return $UserCopyWith<$Res>(_self.joinUser2Id, (value) {
    return _then(_self.copyWith(joinUser2Id: value));
  });
}
}

// dart format on
