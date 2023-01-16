// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  LatLng? get home => throw _privateConstructorUsedError;
  String get homeAddress => throw _privateConstructorUsedError;
  double get kilometers => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String id,
      String name,
      String email,
      LatLng? home,
      String homeAddress,
      double kilometers});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? home = freezed,
    Object? homeAddress = null,
    Object? kilometers = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      home: freezed == home
          ? _value.home
          : home // ignore: cast_nullable_to_non_nullable
              as LatLng?,
      homeAddress: null == homeAddress
          ? _value.homeAddress
          : homeAddress // ignore: cast_nullable_to_non_nullable
              as String,
      kilometers: null == kilometers
          ? _value.kilometers
          : kilometers // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$_UserCopyWith(_$_User value, $Res Function(_$_User) then) =
      __$$_UserCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String email,
      LatLng? home,
      String homeAddress,
      double kilometers});
}

/// @nodoc
class __$$_UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res, _$_User>
    implements _$$_UserCopyWith<$Res> {
  __$$_UserCopyWithImpl(_$_User _value, $Res Function(_$_User) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? home = freezed,
    Object? homeAddress = null,
    Object? kilometers = null,
  }) {
    return _then(_$_User(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      home: freezed == home
          ? _value.home
          : home // ignore: cast_nullable_to_non_nullable
              as LatLng?,
      homeAddress: null == homeAddress
          ? _value.homeAddress
          : homeAddress // ignore: cast_nullable_to_non_nullable
              as String,
      kilometers: null == kilometers
          ? _value.kilometers
          : kilometers // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$_User implements _User {
  const _$_User(
      {required this.id,
      required this.name,
      required this.email,
      this.home,
      this.homeAddress = '',
      this.kilometers = 0.0});

  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final LatLng? home;
  @override
  @JsonKey()
  final String homeAddress;
  @override
  @JsonKey()
  final double kilometers;

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, home: $home, homeAddress: $homeAddress, kilometers: $kilometers)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_User &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.home, home) || other.home == home) &&
            (identical(other.homeAddress, homeAddress) ||
                other.homeAddress == homeAddress) &&
            (identical(other.kilometers, kilometers) ||
                other.kilometers == kilometers));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, email, home, homeAddress, kilometers);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserCopyWith<_$_User> get copyWith =>
      __$$_UserCopyWithImpl<_$_User>(this, _$identity);
}

abstract class _User implements User {
  const factory _User(
      {required final String id,
      required final String name,
      required final String email,
      final LatLng? home,
      final String homeAddress,
      final double kilometers}) = _$_User;

  @override
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  LatLng? get home;
  @override
  String get homeAddress;
  @override
  double get kilometers;
  @override
  @JsonKey(ignore: true)
  _$$_UserCopyWith<_$_User> get copyWith => throw _privateConstructorUsedError;
}
