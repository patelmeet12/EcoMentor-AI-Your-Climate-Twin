import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/calculations.dart';
import '../../core/utils/recommendation_engine.dart';
import '../../data/datasources/local_data_source.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/assessment.dart';
import '../../domain/entities/climate_twin.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/entities/user_progress.dart';
import '../../domain/repositories/user_repository.dart';

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

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main()');
});

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalDataSource(prefs);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final local = ref.watch(localDataSourceProvider);
  return UserRepositoryImpl(local);
});

final twinProvider = StateNotifierProvider<TwinNotifier, TwinState>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return TwinNotifier(repo);
});

class TwinNotifier extends StateNotifier<TwinState> {
  final UserRepository _repository;

  TwinNotifier(this._repository) : super(TwinState.initial()) {
    loadData();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    final assessment = await _repository.getAssessment();
    final progress = await _repository.getProgress();

    if (assessment != null) {
      final twin = _calculateTwin(assessment);
      final recommendations = RecommendationEngine.generateRecommendations(assessment, twin.annualEmissions);
      
      // Map completion state from progress
      final updatedRecs = recommendations.map((r) {
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

  Future<void> saveAssessment(Assessment assessment) async {
    state = state.copyWith(isLoading: true);
    await _repository.saveAssessment(assessment);

    final twin = _calculateTwin(assessment);
    final recommendations = RecommendationEngine.generateRecommendations(assessment, twin.annualEmissions);

    // Initial onboarding achievement
    var progress = state.progress;
    var updatedAchievements = List<String>.from(progress.achievements);
    var addedXp = 0;

    if (!updatedAchievements.contains('Green Starter')) {
      updatedAchievements.add('Green Starter');
      addedXp += 100; // Award 100 XP for getting started
    }

    // High/low score achievements
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

  Future<void> toggleRecommendation(String recommendationId) async {
    final updatedRecs = state.recommendations.map((r) {
      if (r.id == recommendationId) {
        return r.copyWith(isCompleted: !r.isCompleted);
      }
      return r;
    }).toList();

    final targetRec = state.recommendations.firstWhere((r) => r.id == recommendationId);
    final isNowCompleted = !targetRec.isCompleted;

    var progress = state.progress;
    var completedIds = List<String>.from(progress.completedActionIds);
    double carbonChange = targetRec.impactKg;
    int xpChange = 100; // 100 XP per action

    if (isNowCompleted) {
      completedIds.add(recommendationId);
    } else {
      completedIds.remove(recommendationId);
      carbonChange = -carbonChange;
      xpChange = -xpChange;
    }

    // Calculate streak
    int newStreak = progress.streakDays;
    String todayStr = DateTime.now().toIso8601String().substring(0, 10);
    String? lastDate = progress.lastUpdatedDate;

    if (isNowCompleted) {
      if (lastDate == null) {
        newStreak = 1;
      } else {
        final last = DateTime.parse(lastDate);
        final today = DateTime.parse(todayStr);
        final diffDays = today.difference(last).inDays;

        if (diffDays == 1) {
          newStreak += 1;
        } else if (diffDays > 1) {
          newStreak = 1;
        }
      }
    }

    // Achievements updates
    var updatedAchievements = List<String>.from(progress.achievements);
    if (completedIds.isNotEmpty && !updatedAchievements.contains('Carbon Reducer')) {
      updatedAchievements.add('Carbon Reducer');
      xpChange += 200; // Badge bonus
    }
    if (completedIds.length >= 3 && !updatedAchievements.contains('Planet Guardian')) {
      updatedAchievements.add('Planet Guardian');
      xpChange += 400; // Badge bonus
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

  Future<void> resetData() async {
    state = state.copyWith(isLoading: true);
    await _repository.clearAllData();
    state = TwinState.initial().copyWith(isLoading: false);
  }

  ClimateTwin _calculateTwin(Assessment assessment) {
    final transport = CarbonCalculations.calculateTransportationCarbon(
      vehicleType: assessment.vehicleType,
      weeklyDistance: assessment.weeklyDistance,
      publicTransportHours: assessment.publicTransportUsage,
      flightsPerYear: assessment.flightsPerYear,
    );

    final energy = CarbonCalculations.calculateEnergyCarbon(
      monthlyElectricityKwh: assessment.monthlyElectricity,
      acHoursPerDay: assessment.acUsage,
      renewableEnergyPercentage: assessment.renewableEnergyUsage,
    );

    final food = CarbonCalculations.calculateFoodCarbon(assessment.dietType);
    final shopping = CarbonCalculations.calculateShoppingCarbon(
      frequency: assessment.shoppingFrequency,
      electronicsFrequency: assessment.electronicsPurchase,
    );
    final waste = CarbonCalculations.calculateWasteCarbon(
      recyclingHabits: assessment.recyclingHabits,
      plasticConsumption: assessment.plasticConsumption,
      composting: assessment.composting,
    );

    final annual = transport + energy + food + shopping + waste;
    final monthly = annual / 12.0;
    final score = CarbonCalculations.calculateSustainabilityScore(annual);
    final grade = CarbonCalculations.calculateGrade(score);

    // Identify biggest source
    String biggest = 'Food';
    double maxVal = food;
    if (transport > maxVal) {
      biggest = 'Transportation';
      maxVal = transport;
    }
    if (energy > maxVal) {
      biggest = 'Home Energy';
      maxVal = energy;
    }
    if (shopping > maxVal) {
      biggest = 'Shopping';
      maxVal = shopping;
    }
    if (waste > maxVal) {
      biggest = 'Waste';
      maxVal = waste;
    }

    final double total = annual > 0 ? annual : 1.0;
    final personality = CarbonCalculations.calculatePersonality(
      score: score,
      transportPct: transport / total,
      energyPct: energy / total,
      foodPct: food / total,
      shoppingPct: shopping / total,
      wastePct: waste / total,
    );

    // Dynamic insights
    final List<String> insights = [];
    final tPct = (transport / total * 100).toStringAsFixed(0);
    final ePct = (energy / total * 100).toStringAsFixed(0);
    
    if (biggest == 'Transportation') {
      insights.add('Transportation contributes $tPct% of your footprint and is currently your largest improvement opportunity.');
    } else if (biggest == 'Home Energy') {
      insights.add('Home energy contributes $ePct% of your emissions. Adding renewable offsets or tuning cooling is highly recommended.');
    } else {
      insights.add('Your lifestyle profile reveals that $biggest emissions represent your primary carbon output at ${(maxVal/total*100).toStringAsFixed(0)}%.');
    }

    if (score >= 80) {
      insights.add('Excellent effort! Your Climate Twin enjoys high sustainability marks. Keep reinforcing your green habits.');
    } else if (score >= 50) {
      insights.add('You are on a constructive path. Small revisions in $biggest will readily lift your Climate Twin to an A grade.');
    } else {
      insights.add('Your Twin shows warning signs. Target key reduction items in $biggest to start your carbon improvement journey.');
    }

    return ClimateTwin(
      score: score,
      grade: grade,
      personality: personality,
      monthlyEmissions: monthly,
      annualEmissions: annual,
      biggestSource: biggest,
      transportEmissions: transport,
      energyEmissions: energy,
      foodEmissions: food,
      shoppingEmissions: shopping,
      wasteEmissions: waste,
      insights: insights,
    );
  }
}
