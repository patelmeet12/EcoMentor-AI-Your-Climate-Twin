import 'package:flutter_test/flutter_test.dart';
import 'package:ecomentor_ai/domain/entities/assessment.dart';
import 'package:ecomentor_ai/domain/usecases/calculate_carbon_usecase.dart';
import 'package:ecomentor_ai/domain/usecases/calculate_score_usecase.dart';
import 'package:ecomentor_ai/domain/usecases/get_recommendations_usecase.dart';
import 'package:ecomentor_ai/domain/usecases/simulate_carbon_usecase.dart';

void main() {
  group('CalculateCarbonUseCase Tests', () {
    test('calculates accurate category emissions from Assessment data', () {
      final useCase = CalculateCarbonUseCase();
      final assessment = Assessment.empty().copyWith(
        vehicleType: 'Gasoline Car',
        weeklyDistance: 100.0,
        monthlyElectricity: 200.0,
        dietType: 'Vegan',
      );

      final result = useCase(assessment);

      // check category keys are present
      expect(result.containsKey('transport'), true);
      expect(result.containsKey('energy'), true);
      expect(result.containsKey('food'), true);
      expect(result.containsKey('shopping'), true);
      expect(result.containsKey('waste'), true);

      // Verify specific calculated emissions
      // Transport gasoline: 100 * 52 * 0.18 = 936
      expect(result['transport'], 936.0);
      // Food Vegan: 800
      expect(result['food'], 800.0);
    });
  });

  group('CalculateScoreUseCase Tests', () {
    final useCase = CalculateScoreUseCase();

    test('executeScore calculates correct score bounds', () {
      expect(useCase.executeScore(1200), 100);
      expect(useCase.executeScore(16000), 0);
    });

    test('executeGrade converts scores correctly to letter grades', () {
      expect(useCase.executeGrade(95), 'A+');
      expect(useCase.executeGrade(85), 'A');
      expect(useCase.executeGrade(75), 'B');
    });

    test('executePersonality evaluates personality correctly', () {
      final personality = useCase.executePersonality(
        score: 45,
        transport: 4000,
        energy: 1000,
        food: 1000,
        shopping: 1000,
        waste: 1000,
        total: 8000,
      );
      // Transport is 50% of the total footprint
      expect(personality, 'Carbon Commuter');
    });
  });

  group('GetRecommendationsUseCase Tests', () {
    test('returns checklist of recommendations matching input', () {
      final useCase = GetRecommendationsUseCase();
      final habits = Assessment.empty().copyWith(dietType: 'High Meat');

      final result = useCase(habits, 5000.0);

      expect(result.isNotEmpty, true);
      expect(result.any((r) => r.id == 'food_meatless'), true);
    });
  });

  group('SimulateCarbonUseCase Tests', () {
    test('calculates correct simulated outputs after applying offsets', () {
      final useCase = SimulateCarbonUseCase();
      final result = useCase(
        baseEmissions: 8000.0,
        reducedEmissionsOffset: 2000.0,
      );

      expect(result['emissions'], 6000.0);
      expect(result['score'] > 0, true);
      expect(result['grade'] != 'F', true);
    });

    test('ensures simulated emissions are clamped to at least zero', () {
      final useCase = SimulateCarbonUseCase();
      final result = useCase(
        baseEmissions: 1000.0,
        reducedEmissionsOffset: 3000.0,
      );

      expect(result['emissions'], 0.0);
      expect(result['score'], 100);
      expect(result['grade'], 'A+');
    });
  });
}
