import '../entities/assessment.dart';
import '../entities/user_progress.dart';

abstract class UserRepository {
  Future<void> saveAssessment(Assessment assessment);
  Future<Assessment?> getAssessment();
  Future<void> saveProgress(UserProgress progress);
  Future<UserProgress> getProgress();
  Future<void> clearAllData();
}
