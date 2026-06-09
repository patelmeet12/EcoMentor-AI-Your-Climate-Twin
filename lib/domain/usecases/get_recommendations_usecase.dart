import '../entities/assessment.dart';
import '../entities/recommendation.dart';
import '../../core/utils/recommendation_engine.dart';

/// Use case that triggers recommendation rules against user habits
/// to produce a dynamic list of personalized actions.
class GetRecommendationsUseCase {
  /// Evaluates user habits and outputs a checklist of recommendations.
  List<Recommendation> call(Assessment habits, double totalCarbon) {
    return RecommendationEngine.generateRecommendations(habits, totalCarbon);
  }
}
