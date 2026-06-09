import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/assessment_model.dart';
import '../models/user_progress_model.dart';

class LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSource(this.sharedPreferences);

  static const _keyAssessment = 'assessment_data';
  static const _keyProgress = 'user_progress_data';

  Future<void> saveAssessment(AssessmentModel model) async {
    final jsonString = jsonEncode(model.toJson());
    await sharedPreferences.setString(_keyAssessment, jsonString);
  }

  Future<AssessmentModel?> getAssessment() async {
    final jsonString = sharedPreferences.getString(_keyAssessment);
    if (jsonString == null) return null;
    try {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return AssessmentModel.fromJson(jsonMap);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveProgress(UserProgressModel model) async {
    final jsonString = jsonEncode(model.toJson());
    await sharedPreferences.setString(_keyProgress, jsonString);
  }

  Future<UserProgressModel?> getProgress() async {
    final jsonString = sharedPreferences.getString(_keyProgress);
    if (jsonString == null) return null;
    try {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserProgressModel.fromJson(jsonMap);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearAll() async {
    await sharedPreferences.remove(_keyAssessment);
    await sharedPreferences.remove(_keyProgress);
  }
}
