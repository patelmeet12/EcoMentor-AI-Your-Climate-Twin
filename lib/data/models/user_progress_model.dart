import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_progress.dart';

part 'user_progress_model.freezed.dart';
part 'user_progress_model.g.dart';

@freezed
class UserProgressModel with _$UserProgressModel {
  const factory UserProgressModel({
    required List<String> completedActionIds,
    required double totalCarbonReduced,
    required int xpPoints,
    required int streakDays,
    required List<String> achievements,
    String? lastUpdatedDate,
  }) = _UserProgressModel;

  factory UserProgressModel.fromJson(Map<String, dynamic> json) =>
      _$UserProgressModelFromJson(json);

  factory UserProgressModel.fromEntity(UserProgress entity) => UserProgressModel(
        completedActionIds: entity.completedActionIds,
        totalCarbonReduced: entity.totalCarbonReduced,
        xpPoints: entity.xpPoints,
        streakDays: entity.streakDays,
        achievements: entity.achievements,
        lastUpdatedDate: entity.lastUpdatedDate,
      );
}

extension UserProgressModelX on UserProgressModel {
  UserProgress toEntity() => UserProgress(
        completedActionIds: completedActionIds,
        totalCarbonReduced: totalCarbonReduced,
        xpPoints: xpPoints,
        streakDays: streakDays,
        achievements: achievements,
        lastUpdatedDate: lastUpdatedDate,
      );
}
