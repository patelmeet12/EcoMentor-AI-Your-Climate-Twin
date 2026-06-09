import '../../core/utils/calculations.dart';

/// Use case that calculates simulated footprints based on toggled offsets.
class SimulateCarbonUseCase {
  /// Calculates simulated emissions, scores, and grades after applying offsets.
  Map<String, dynamic> call({
    required double baseEmissions,
    required double reducedEmissionsOffset,
  }) {
    final double simulatedEmissions = baseEmissions - reducedEmissionsOffset;
    final double finalEmissions = simulatedEmissions < 0 ? 0.0 : simulatedEmissions;
    final int simulatedScore = CarbonCalculations.calculateSustainabilityScore(finalEmissions);
    final String simulatedGrade = CarbonCalculations.calculateGrade(simulatedScore);

    return {
      'emissions': finalEmissions,
      'score': simulatedScore,
      'grade': simulatedGrade,
    };
  }
}
