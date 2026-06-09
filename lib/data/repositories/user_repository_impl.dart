import '../../domain/entities/assessment.dart';
import '../../domain/entities/user_progress.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/assessment_model.dart';
import '../models/user_progress_model.dart';

class UserRepositoryImpl implements UserRepository {
  final LocalDataSource localDataSource;

  UserRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveAssessment(Assessment assessment) async {
    final model = AssessmentModel.fromEntity(assessment);
    await localDataSource.saveAssessment(model);
  }

  @override
  Future<Assessment?> getAssessment() async {
    final model = await localDataSource.getAssessment();
    return model?.toEntity();
  }

  @override
  Future<void> saveProgress(UserProgress progress) async {
    final model = UserProgressModel.fromEntity(progress);
    await localDataSource.saveProgress(model);
  }

  @override
  Future<UserProgress> getProgress() async {
    final model = await localDataSource.getProgress();
    if (model == null) {
      return UserProgress.empty();
    }
    return model.toEntity();
  }

  @override
  Future<void> clearAllData() async {
    await localDataSource.clearAll();
  }
}
