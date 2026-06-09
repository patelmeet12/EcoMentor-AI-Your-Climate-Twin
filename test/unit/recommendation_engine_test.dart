import 'package:flutter_test/flutter_test.dart';
import 'package:ecomentor_ai/core/utils/recommendation_engine.dart';
import 'package:ecomentor_ai/domain/entities/assessment.dart';

void main() {
  group('Recommendation Engine Unit Tests', () {
    test('suggests EV option for high-mileage gasoline car owners', () {
      final habits = Assessment.empty().copyWith(
        vehicleType: 'Gasoline Car',
        weeklyDistance: 200.0,
      );
      final recommendations = RecommendationEngine.generateRecommendations(habits, 8000.0);
      final hasEv = recommendations.any((r) => r.id == 'trans_ev');
      expect(hasEv, true);
    });

    test('suggests AC optimization for high AC users', () {
      final habits = Assessment.empty().copyWith(
        acUsage: 8.0,
      );
      final recommendations = RecommendationEngine.generateRecommendations(habits, 5000.0);
      final hasAcTemp = recommendations.any((r) => r.id == 'energy_ac_temp');
      expect(hasAcTemp, true);
    });

    test('suggests Meatless Mondays for high meat diets', () {
      final habits = Assessment.empty().copyWith(
        dietType: 'High Meat',
      );
      final recommendations = RecommendationEngine.generateRecommendations(habits, 4000.0);
      final hasMeatless = recommendations.any((r) => r.id == 'food_meatless');
      expect(hasMeatless, true);
    });

    test('suggests composting for users not composting organic waste', () {
      final habits = Assessment.empty().copyWith(
        composting: false,
      );
      final recommendations = RecommendationEngine.generateRecommendations(habits, 4000.0);
      final hasCompost = recommendations.any((r) => r.id == 'waste_compost');
      expect(hasCompost, true);
    });
  });
}
