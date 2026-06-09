import '../../core/utils/calculations.dart';

/// Use case that calculates the overall Sustainability Score (0-100),
/// Letter Grade (A+ to F), and Environmental Personality based on emissions.
class CalculateScoreUseCase {
  /// Computes the sustainability score.
  int executeScore(double totalCarbon) {
    return CarbonCalculations.calculateSustainabilityScore(totalCarbon);
  }

  /// Computes the sustainability grade.
  String executeGrade(int score) {
    return CarbonCalculations.calculateGrade(score);
  }

  /// Evaluates and assigns the environmental personality title.
  String executePersonality({
    required int score,
    required double transport,
    required double energy,
    required double food,
    required double shopping,
    required double waste,
    required double total,
  }) {
    final double divisor = total > 0 ? total : 1.0;
    return CarbonCalculations.calculatePersonality(
      score: score,
      transportPct: transport / divisor,
      energyPct: energy / divisor,
      foodPct: food / divisor,
      shoppingPct: shopping / divisor,
      wastePct: waste / divisor,
    );
  }
}
