// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProgressModelImpl _$$UserProgressModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserProgressModelImpl(
      completedActionIds: (json['completedActionIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      totalCarbonReduced: (json['totalCarbonReduced'] as num).toDouble(),
      xpPoints: (json['xpPoints'] as num).toInt(),
      streakDays: (json['streakDays'] as num).toInt(),
      achievements: (json['achievements'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastUpdatedDate: json['lastUpdatedDate'] as String?,
    );

Map<String, dynamic> _$$UserProgressModelImplToJson(
        _$UserProgressModelImpl instance) =>
    <String, dynamic>{
      'completedActionIds': instance.completedActionIds,
      'totalCarbonReduced': instance.totalCarbonReduced,
      'xpPoints': instance.xpPoints,
      'streakDays': instance.streakDays,
      'achievements': instance.achievements,
      'lastUpdatedDate': instance.lastUpdatedDate,
    };
