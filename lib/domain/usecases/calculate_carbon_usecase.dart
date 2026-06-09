import '../entities/assessment.dart';
import '../../core/utils/calculations.dart';

/// Use case that calculates the annual carbon emissions breakdown (in kg CO₂)
/// across all categories (Transportation, Energy, Food, Shopping, and Waste).
class CalculateCarbonUseCase {
  /// Computes the carbon emissions for each category and returns them as a map.
  Map<String, double> call(Assessment assessment) {
    final double transport = CarbonCalculations.calculateTransportationCarbon(
      vehicleType: assessment.vehicleType,
      weeklyDistance: assessment.weeklyDistance,
      publicTransportHours: assessment.publicTransportUsage,
      flightsPerYear: assessment.flightsPerYear,
    );

    final double energy = CarbonCalculations.calculateEnergyCarbon(
      monthlyElectricityKwh: assessment.monthlyElectricity,
      acHoursPerDay: assessment.acUsage,
      renewableEnergyPercentage: assessment.renewableEnergyUsage,
    );

    final double food = CarbonCalculations.calculateFoodCarbon(assessment.dietType);
    
    final double shopping = CarbonCalculations.calculateShoppingCarbon(
      frequency: assessment.shoppingFrequency,
      electronicsFrequency: assessment.electronicsPurchase,
    );
    
    final double waste = CarbonCalculations.calculateWasteCarbon(
      recyclingHabits: assessment.recyclingHabits,
      plasticConsumption: assessment.plasticConsumption,
      composting: assessment.composting,
    );

    return {
      'transport': transport,
      'energy': energy,
      'food': food,
      'shopping': shopping,
      'waste': waste,
    };
  }
}
