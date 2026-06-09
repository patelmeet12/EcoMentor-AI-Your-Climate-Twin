// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_progress_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProgressModel _$UserProgressModelFromJson(Map<String, dynamic> json) {
  return _UserProgressModel.fromJson(json);
}

/// @nodoc
mixin _$UserProgressModel {
  List<String> get completedActionIds => throw _privateConstructorUsedError;
  double get totalCarbonReduced => throw _privateConstructorUsedError;
  int get xpPoints => throw _privateConstructorUsedError;
  int get streakDays => throw _privateConstructorUsedError;
  List<String> get achievements => throw _privateConstructorUsedError;
  String? get lastUpdatedDate => throw _privateConstructorUsedError;

  /// Serializes this UserProgressModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProgressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProgressModelCopyWith<UserProgressModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProgressModelCopyWith<$Res> {
  factory $UserProgressModelCopyWith(
          UserProgressModel value, $Res Function(UserProgressModel) then) =
      _$UserProgressModelCopyWithImpl<$Res, UserProgressModel>;
  @useResult
  $Res call(
      {List<String> completedActionIds,
      double totalCarbonReduced,
      int xpPoints,
      int streakDays,
      List<String> achievements,
      String? lastUpdatedDate});
}

/// @nodoc
class _$UserProgressModelCopyWithImpl<$Res, $Val extends UserProgressModel>
    implements $UserProgressModelCopyWith<$Res> {
  _$UserProgressModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProgressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completedActionIds = null,
    Object? totalCarbonReduced = null,
    Object? xpPoints = null,
    Object? streakDays = null,
    Object? achievements = null,
    Object? lastUpdatedDate = freezed,
  }) {
    return _then(_value.copyWith(
      completedActionIds: null == completedActionIds
          ? _value.completedActionIds
          : completedActionIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      totalCarbonReduced: null == totalCarbonReduced
          ? _value.totalCarbonReduced
          : totalCarbonReduced // ignore: cast_nullable_to_non_nullable
              as double,
      xpPoints: null == xpPoints
          ? _value.xpPoints
          : xpPoints // ignore: cast_nullable_to_non_nullable
              as int,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      achievements: null == achievements
          ? _value.achievements
          : achievements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastUpdatedDate: freezed == lastUpdatedDate
          ? _value.lastUpdatedDate
          : lastUpdatedDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProgressModelImplCopyWith<$Res>
    implements $UserProgressModelCopyWith<$Res> {
  factory _$$UserProgressModelImplCopyWith(_$UserProgressModelImpl value,
          $Res Function(_$UserProgressModelImpl) then) =
      __$$UserProgressModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> completedActionIds,
      double totalCarbonReduced,
      int xpPoints,
      int streakDays,
      List<String> achievements,
      String? lastUpdatedDate});
}

/// @nodoc
class __$$UserProgressModelImplCopyWithImpl<$Res>
    extends _$UserProgressModelCopyWithImpl<$Res, _$UserProgressModelImpl>
    implements _$$UserProgressModelImplCopyWith<$Res> {
  __$$UserProgressModelImplCopyWithImpl(_$UserProgressModelImpl _value,
      $Res Function(_$UserProgressModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProgressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completedActionIds = null,
    Object? totalCarbonReduced = null,
    Object? xpPoints = null,
    Object? streakDays = null,
    Object? achievements = null,
    Object? lastUpdatedDate = freezed,
  }) {
    return _then(_$UserProgressModelImpl(
      completedActionIds: null == completedActionIds
          ? _value._completedActionIds
          : completedActionIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      totalCarbonReduced: null == totalCarbonReduced
          ? _value.totalCarbonReduced
          : totalCarbonReduced // ignore: cast_nullable_to_non_nullable
              as double,
      xpPoints: null == xpPoints
          ? _value.xpPoints
          : xpPoints // ignore: cast_nullable_to_non_nullable
              as int,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      achievements: null == achievements
          ? _value._achievements
          : achievements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastUpdatedDate: freezed == lastUpdatedDate
          ? _value.lastUpdatedDate
          : lastUpdatedDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProgressModelImpl implements _UserProgressModel {
  const _$UserProgressModelImpl(
      {required final List<String> completedActionIds,
      required this.totalCarbonReduced,
      required this.xpPoints,
      required this.streakDays,
      required final List<String> achievements,
      this.lastUpdatedDate})
      : _completedActionIds = completedActionIds,
        _achievements = achievements;

  factory _$UserProgressModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProgressModelImplFromJson(json);

  final List<String> _completedActionIds;
  @override
  List<String> get completedActionIds {
    if (_completedActionIds is EqualUnmodifiableListView)
      return _completedActionIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedActionIds);
  }

  @override
  final double totalCarbonReduced;
  @override
  final int xpPoints;
  @override
  final int streakDays;
  final List<String> _achievements;
  @override
  List<String> get achievements {
    if (_achievements is EqualUnmodifiableListView) return _achievements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_achievements);
  }

  @override
  final String? lastUpdatedDate;

  @override
  String toString() {
    return 'UserProgressModel(completedActionIds: $completedActionIds, totalCarbonReduced: $totalCarbonReduced, xpPoints: $xpPoints, streakDays: $streakDays, achievements: $achievements, lastUpdatedDate: $lastUpdatedDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProgressModelImpl &&
            const DeepCollectionEquality()
                .equals(other._completedActionIds, _completedActionIds) &&
            (identical(other.totalCarbonReduced, totalCarbonReduced) ||
                other.totalCarbonReduced == totalCarbonReduced) &&
            (identical(other.xpPoints, xpPoints) ||
                other.xpPoints == xpPoints) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            const DeepCollectionEquality()
                .equals(other._achievements, _achievements) &&
            (identical(other.lastUpdatedDate, lastUpdatedDate) ||
                other.lastUpdatedDate == lastUpdatedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_completedActionIds),
      totalCarbonReduced,
      xpPoints,
      streakDays,
      const DeepCollectionEquality().hash(_achievements),
      lastUpdatedDate);

  /// Create a copy of UserProgressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProgressModelImplCopyWith<_$UserProgressModelImpl> get copyWith =>
      __$$UserProgressModelImplCopyWithImpl<_$UserProgressModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProgressModelImplToJson(
      this,
    );
  }
}

abstract class _UserProgressModel implements UserProgressModel {
  const factory _UserProgressModel(
      {required final List<String> completedActionIds,
      required final double totalCarbonReduced,
      required final int xpPoints,
      required final int streakDays,
      required final List<String> achievements,
      final String? lastUpdatedDate}) = _$UserProgressModelImpl;

  factory _UserProgressModel.fromJson(Map<String, dynamic> json) =
      _$UserProgressModelImpl.fromJson;

  @override
  List<String> get completedActionIds;
  @override
  double get totalCarbonReduced;
  @override
  int get xpPoints;
  @override
  int get streakDays;
  @override
  List<String> get achievements;
  @override
  String? get lastUpdatedDate;

  /// Create a copy of UserProgressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProgressModelImplCopyWith<_$UserProgressModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
