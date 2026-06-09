import 'package:flutter_test/flutter_test.dart';
import 'package:ecomentor_ai/core/utils/calculations.dart';

void main() {
  group('Carbon Calculations Unit Tests', () {
    test('calculateTransportationCarbon returns correct emissions for gasoline vehicles', () {
      final emissions = CarbonCalculations.calculateTransportationCarbon(
        vehicleType: 'gasoline',
        weeklyDistance: 100.0,
        publicTransportHours: 0.0,
        flightsPerYear: 0,
      );
      // distance: 100 * 52 = 5200 km. Gasoline: 0.18 kg/commute. 5200 * 0.18 = 936 kg
      expect(emissions, 936.0);
    });

    test('calculateEnergyCarbon returns correct emissions accounting for renewables', () {
      final emissions = CarbonCalculations.calculateEnergyCarbon(
        monthlyElectricityKwh: 200.0,
        acHoursPerDay: 4.0,
        renewableEnergyPercentage: 0.25, // 25% solar offset
      );
      // electricity: 200 * 12 * 0.85 * (1 - 0.25) = 1530 kg
      // AC: 4 * 365 * 0.6 = 876 kg
      // Total: 2406 kg
      expect(emissions, 2406.0);
    });

    test('calculateFoodCarbon returns correct values based on diet types', () {
      expect(CarbonCalculations.calculateFoodCarbon('vegan'), 800.0);
      expect(CarbonCalculations.calculateFoodCarbon('vegetarian'), 1200.0);
      expect(CarbonCalculations.calculateFoodCarbon('mixed'), 2000.0);
      expect(CarbonCalculations.calculateFoodCarbon('high meat'), 3000.0);
    });

    test('calculateSustainabilityScore scales linearly within bounds', () {
      // Net-zero target (<= 1500 kg CO2) gets 100
      expect(CarbonCalculations.calculateSustainabilityScore(1200), 100);
      // High footprint (>= 15000 kg CO2) gets 0
      expect(CarbonCalculations.calculateSustainabilityScore(16000), 0);
      // Midpoint: (8250 kg CO2) gets 50
      expect(CarbonCalculations.calculateSustainabilityScore(8250), 50);
    });

    test('calculateGrade returns correct grades', () {
      expect(CarbonCalculations.calculateGrade(97), 'A+');
      expect(CarbonCalculations.calculateGrade(88), 'A');
      expect(CarbonCalculations.calculateGrade(72), 'B');
      expect(CarbonCalculations.calculateGrade(58), 'C');
      expect(CarbonCalculations.calculateGrade(41), 'D');
      expect(CarbonCalculations.calculateGrade(12), 'F');
    });
  });
}
