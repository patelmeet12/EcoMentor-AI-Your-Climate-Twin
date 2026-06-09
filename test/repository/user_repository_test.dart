import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecomentor_ai/data/datasources/local_data_source.dart';
import 'package:ecomentor_ai/data/repositories/user_repository_impl.dart';
import 'package:ecomentor_ai/domain/entities/assessment.dart';
import 'package:ecomentor_ai/domain/entities/user_progress.dart';

void main() {
  group('UserRepository SharedPreferences Persistence Tests', () {
    late UserRepositoryImpl repository;
    late LocalDataSource localDataSource;

    setUp(() async {
      // Setup mock values for testing shared preferences
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      localDataSource = LocalDataSource(prefs);
      repository = UserRepositoryImpl(localDataSource);
    });

    test('saves and loads assessment correctly in SharedPreferences cache', () async {
      final assessment = Assessment.empty().copyWith(
        vehicleType: 'Electric Car',
        weeklyDistance: 140.0,
        dietType: 'Vegan',
        composting: true,
      );

      await repository.saveAssessment(assessment);
      final retrieved = await repository.getAssessment();

      expect(retrieved, isNotNull);
      expect(retrieved!.vehicleType, 'Electric Car');
      expect(retrieved.weeklyDistance, 140.0);
      expect(retrieved.dietType, 'Vegan');
      expect(retrieved.composting, true);
    });

    test('saves and loads user progress correctly in SharedPreferences cache', () async {
      final progress = UserProgress.empty().copyWith(
        xpPoints: 750,
        streakDays: 3,
        achievements: ['Green Starter', 'Streak Master'],
      );

      await repository.saveProgress(progress);
      final retrieved = await repository.getProgress();

      expect(retrieved, isNotNull);
      expect(retrieved.xpPoints, 750);
      expect(retrieved.streakDays, 3);
      expect(retrieved.achievements, contains('Streak Master'));
    });

    test('removes all caches correctly when clearAllData is triggered', () async {
      final assessment = Assessment.empty().copyWith(weeklyDistance: 100);
      await repository.saveAssessment(assessment);

      await repository.clearAllData();
      final retrieved = await repository.getAssessment();

      expect(retrieved, isNull);
    });
  });
}
