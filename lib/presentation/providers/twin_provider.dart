import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/local_data_source.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/assessment.dart';
import '../../domain/entities/climate_twin.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/entities/user_progress.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/calculate_carbon_usecase.dart';
import '../../domain/usecases/calculate_score_usecase.dart';
import '../../domain/usecases/get_recommendations_usecase.dart';

/// Represents the global state for the Climate Twin dashboard elements.
class TwinState {
  final Assessment assessment;
  final ClimateTwin twin;
  final UserProgress progress;
  final List<Recommendation> recommendations;
  final bool isLoading;
  final bool hasAssessment;

  const TwinState({
    required this.assessment,
    required this.twin,
    required this.progress,
    required this.recommendations,
    required this.isLoading,
    required this.hasAssessment,
  });

  TwinState copyWith({
    Assessment? assessment,
    ClimateTwin? twin,
    UserProgress? progress,
    List<Recommendation>? recommendations,
    bool? isLoading,
    bool? hasAssessment,
  }) {
    return TwinState(
      assessment: assessment ?? this.assessment,
      twin: twin ?? this.twin,
      progress: progress ?? this.progress,
      recommendations: recommendations ?? this.recommendations,
      isLoading: isLoading ?? this.isLoading,
      hasAssessment: hasAssessment ?? this.hasAssessment,
    );
  }

  factory TwinState.initial() => TwinState(
        assessment: Assessment.empty(),
        twin: ClimateTwin.empty(),
        progress: UserProgress.empty(),
        recommendations: const [],
        isLoading: true,
        hasAssessment: false,
      );
}

/// Provider for global SharedPreferences dependencies.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main()');
});

/// Provider for LocalDataSource instances.
final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  final SharedPreferences prefs = ref.watch(sharedPreferencesProvider);
  return LocalDataSource(prefs);
});

/// Provider for UserRepository implementations.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final LocalDataSource local = ref.watch(localDataSourceProvider);
  return UserRepositoryImpl(local);
});

/// Global state provider for twin operations and achievements progress.
final twinProvider = StateNotifierProvider<TwinNotifier, TwinState>((ref) {
  final UserRepository repo = ref.watch(userRepositoryProvider);
  return TwinNotifier(repo);
});

/// Controller that maps user onboarding entries and achievements checklist triggers.
class TwinNotifier extends StateNotifier<TwinState> {
  final UserRepository _repository;
  final CalculateCarbonUseCase _calculateCarbon = CalculateCarbonUseCase();
  final CalculateScoreUseCase _calculateScore = CalculateScoreUseCase();
  final GetRecommendationsUseCase _getRecommendations = GetRecommendationsUseCase();

  TwinNotifier(this._repository) : super(TwinState.initial()) {
    loadData();
  }

  /// Fetches saved user profile values from cache and computes metrics.
  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    final Assessment? assessment = await _repository.getAssessment();
    final UserProgress progress = await _repository.getProgress();

    if (assessment != null) {
      final ClimateTwin twin = _calculateTwin(assessment);
      final List<Recommendation> recommendations = _getRecommendations(assessment, twin.annualEmissions);

      // Sync completed states with the loaded progress cache
      final List<Recommendation> updatedRecs = recommendations.map((r) {
        return r.copyWith(isCompleted: progress.completedActionIds.contains(r.id));
      }).toList();

      state = state.copyWith(
        assessment: assessment,
        twin: twin,
        progress: progress,
        recommendations: updatedRecs,
        isLoading: false,
        hasAssessment: true,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        hasAssessment: false,
      );
    }
  }

  /// Stores onboarding habits and initializes achievements.
  Future<void> saveAssessment(Assessment assessment) async {
    state = state.copyWith(isLoading: true);
    await _repository.saveAssessment(assessment);

    final ClimateTwin twin = _calculateTwin(assessment);
    final List<Recommendation> recommendations = _getRecommendations(assessment, twin.annualEmissions);

    UserProgress progress = state.progress;
    final List<String> updatedAchievements = List<String>.from(progress.achievements);
    int addedXp = 0;

    // Gamification level badge adjustments
    if (!updatedAchievements.contains('Green Starter')) {
      updatedAchievements.add('Green Starter');
      addedXp += 100;
    }
    if (twin.score >= 70 && !updatedAchievements.contains('Eco Explorer')) {
      updatedAchievements.add('Eco Explorer');
      addedXp += 200;
    }
    if (twin.score >= 85 && !updatedAchievements.contains('Sustainability Hero')) {
      updatedAchievements.add('Sustainability Hero');
      addedXp += 300;
    }

    progress = progress.copyWith(
      achievements: updatedAchievements,
      xpPoints: progress.xpPoints + addedXp,
    );

    await _repository.saveProgress(progress);

    state = state.copyWith(
      assessment: assessment,
      twin: twin,
      progress: progress,
      recommendations: recommendations,
      isLoading: false,
      hasAssessment: true,
    );
  }

  /// Checks off a suggested recommendation from the dashboard list.
  Future<void> toggleRecommendation(String recommendationId) async {
    final List<Recommendation> updatedRecs = state.recommendations.map((r) {
      if (r.id == recommendationId) {
        return r.copyWith(isCompleted: !r.isCompleted);
      }
      return r;
    }).toList();

    final Recommendation targetRec = state.recommendations.firstWhere((r) => r.id == recommendationId);
    final bool isNowCompleted = !targetRec.isCompleted;

    UserProgress progress = state.progress;
    final List<String> completedIds = List<String>.from(progress.completedActionIds);
    double carbonChange = targetRec.impactKg;
    int xpChange = 100;

    if (isNowCompleted) {
      completedIds.add(recommendationId);
    } else {
      completedIds.remove(recommendationId);
      carbonChange = -carbonChange;
      xpChange = -xpChange;
    }

    // Process daily streak metrics
    int newStreak = progress.streakDays;
    final String todayStr = DateTime.now().toIso8601String().substring(0, 10);
    final String? lastDate = progress.lastUpdatedDate;

    if (isNowCompleted) {
      if (lastDate == null) {
        newStreak = 1;
      } else {
        final DateTime last = DateTime.parse(lastDate);
        final DateTime today = DateTime.parse(todayStr);
        final int diffDays = today.difference(last).inDays;

        if (diffDays == 1) {
          newStreak += 1;
        } else if (diffDays > 1) {
          newStreak = 1;
        }
      }
    }

    // Evaluate unlocks
    final List<String> updatedAchievements = List<String>.from(progress.achievements);
    if (completedIds.isNotEmpty && !updatedAchievements.contains('Carbon Reducer')) {
      updatedAchievements.add('Carbon Reducer');
      xpChange += 200;
    }
    if (completedIds.length >= 3 && !updatedAchievements.contains('Planet Guardian')) {
      updatedAchievements.add('Planet Guardian');
      xpChange += 400;
    }
    if (newStreak >= 3 && !updatedAchievements.contains('Streak Master')) {
      updatedAchievements.add('Streak Master');
      xpChange += 250;
    }

    progress = progress.copyWith(
      completedActionIds: completedIds,
      totalCarbonReduced: progress.totalCarbonReduced + carbonChange,
      xpPoints: progress.xpPoints + xpChange,
      streakDays: newStreak,
      achievements: updatedAchievements,
      lastUpdatedDate: todayStr,
    );

    await _repository.saveProgress(progress);

    state = state.copyWith(
      progress: progress,
      recommendations: updatedRecs,
    );
  }

  /// Erases cache entries and resets state.
  Future<void> resetData() async {
    state = state.copyWith(isLoading: true);
    await _repository.clearAllData();
    state = TwinState.initial().copyWith(isLoading: false);
  }

  /// Helper maps use cases parameters to calculate the ClimateTwin profile entity.
  ClimateTwin _calculateTwin(Assessment assessment) {
    final Map<String, double> emissionsMap = _calculateCarbon(assessment);

    final double transport = emissionsMap['transport']!;
    final double energy = emissionsMap['energy']!;
    final double food = emissionsMap['food']!;
    final double shopping = emissionsMap['shopping']!;
    final double waste = emissionsMap['waste']!;

    final double annual = transport + energy + food + shopping + waste;
    final double monthly = annual / 12.0;

    final int score = _calculateScore.executeScore(annual);
    final String grade = _calculateScore.executeGrade(score);

    // Identify biggest category source
    String biggestSource = 'Food';
    double maxVal = food;
    if (transport > maxVal) {
      biggestSource = 'Transportation';
      maxVal = transport;
    }
    if (energy > maxVal) {
      biggestSource = 'Home Energy';
      maxVal = energy;
    }
    if (shopping > maxVal) {
      biggestSource = 'Shopping';
      maxVal = shopping;
    }
    if (waste > maxVal) {
      biggestSource = 'Waste';
      maxVal = waste;
    }

    final double total = annual > 0 ? annual : 1.0;
    final String personality = _calculateScore.executePersonality(
      score: score,
      transport: transport,
      energy: energy,
      food: food,
      shopping: shopping,
      waste: waste,
      total: total,
    );

    // Dynamic insights
    final List<String> insights = [];
    final String tPct = (transport / total * 100).toStringAsFixed(0);
    final String ePct = (energy / total * 100).toStringAsFixed(0);

    if (biggestSource == 'Transportation') {
      insights.add('Transportation contributes $tPct% of your footprint and is currently your largest improvement opportunity.');
    } else if (biggestSource == 'Home Energy') {
      insights.add('Home energy contributes $ePct% of your emissions. Adding renewable offsets or tuning cooling is highly recommended.');
    } else {
      insights.add('Your lifestyle profile reveals that $biggestSource emissions represent your primary carbon output at ${(maxVal / total * 100).toStringAsFixed(0)}%.');
    }

    if (score >= 80) {
      insights.add('Excellent effort! Your Climate Twin enjoys high sustainability marks. Keep reinforcing your green habits.');
    } else if (score >= 50) {
      insights.add('You are on a constructive path. Small revisions in $biggestSource will readily lift your Climate Twin to an A grade.');
    } else {
      insights.add('Your Twin shows warning signs. Target key reduction items in $biggestSource to start your carbon improvement journey.');
    }

    return ClimateTwin(
      score: score,
      grade: grade,
      personality: personality,
      monthlyEmissions: monthly,
      annualEmissions: annual,
      biggestSource: biggestSource,
      transportEmissions: transport,
      energyEmissions: energy,
      foodEmissions: food,
      shoppingEmissions: shopping,
      wasteEmissions: waste,
      insights: insights,
    );
  }
}
