import 'dart:math';
import '../constants/app_constants.dart';

/// Provides static calculations for carbon footprints, sustainability grades,
/// scores, and environmental personalities.
class CarbonCalculations {
  /// Calculates annual transportation carbon emissions in kg CO₂ based on vehicle commute and flights.
  static double calculateTransportationCarbon({
    required String vehicleType,
    required double weeklyDistance,
    required double publicTransportHours,
    required int flightsPerYear,
  }) {
    double carEmissions = 0.0;
    final double annualCarDistance = weeklyDistance * 52.0;

    switch (vehicleType.toLowerCase()) {
      case 'gasoline':
      case 'gasoline car':
        carEmissions = annualCarDistance * AppConstants.factorGasolineCar;
        break;
      case 'diesel':
      case 'diesel car':
        carEmissions = annualCarDistance * AppConstants.factorDieselCar;
        break;
      case 'hybrid':
      case 'hybrid car':
        carEmissions = annualCarDistance * AppConstants.factorHybridCar;
        break;
      case 'electric':
      case 'electric car':
        carEmissions = annualCarDistance * AppConstants.factorElectricCar;
        break;
      case 'motorcycle':
        carEmissions = annualCarDistance * AppConstants.factorMotorcycle;
        break;
      default:
        carEmissions = 0.0;
    }

    // Public transport: hours/week converted to km/week
    final double publicWeeklyKm = publicTransportHours * AppConstants.avgPublicSpeedKmh;
    final double publicEmissions = publicWeeklyKm * 52.0 * AppConstants.factorPublicTransport;

    // Flights: annual count scaled by flight carbon factor
    final double flightEmissions = flightsPerYear * AppConstants.factorFlights;

    return carEmissions + publicEmissions + flightEmissions;
  }

  /// Calculates annual home energy carbon emissions in kg CO₂ from electricity usage and AC hours.
  static double calculateEnergyCarbon({
    required double monthlyElectricityKwh,
    required double acHoursPerDay,
    required double renewableEnergyPercentage,
  }) {
    // Electricity emissions scaled by grid factor and offset by solar usage ratio
    final double electricityEmissions = monthlyElectricityKwh *
        12.0 *
        AppConstants.factorGridElectricity *
        (1.0 - renewableEnergyPercentage);

    // AC usage emissions per day over the year
    final double acEmissions = acHoursPerDay * 365.0 * AppConstants.factorAcHour;

    return electricityEmissions + acEmissions;
  }

  /// Calculates annual food carbon emissions in kg CO₂ based on diet type.
  static double calculateFoodCarbon(String dietType) {
    switch (dietType.toLowerCase()) {
      case 'vegan':
        return AppConstants.factorDietVegan;
      case 'vegetarian':
        return AppConstants.factorDietVegetarian;
      case 'mixed':
      case 'mixed diet':
        return AppConstants.factorDietMixed;
      case 'high meat':
      case 'high meat consumption':
        return AppConstants.factorDietHighMeat;
      default:
        return AppConstants.factorDietMixed;
    }
  }

  /// Calculates annual shopping carbon emissions in kg CO₂ based on consumer habits.
  static double calculateShoppingCarbon({
    required String frequency,
    required String electronicsFrequency,
  }) {
    double baseEmissions = 0.0;
    switch (frequency.toLowerCase()) {
      case 'low':
        baseEmissions = AppConstants.factorShoppingLow;
        break;
      case 'medium':
        baseEmissions = AppConstants.factorShoppingMedium;
        break;
      case 'high':
        baseEmissions = AppConstants.factorShoppingHigh;
        break;
      default:
        baseEmissions = AppConstants.factorShoppingMedium;
    }

    double electronicsEmissions = 0.0;
    switch (electronicsFrequency.toLowerCase()) {
      case 'rarely':
        electronicsEmissions = AppConstants.factorElectronicsRare;
        break;
      case 'occasionally':
        electronicsEmissions = AppConstants.factorElectronicsOccasional;
        break;
      case 'frequently':
        electronicsEmissions = AppConstants.factorElectronicsFrequent;
        break;
      default:
        electronicsEmissions = AppConstants.factorElectronicsOccasional;
    }

    return baseEmissions + electronicsEmissions;
  }

  /// Calculates annual waste carbon emissions in kg CO₂ based on recycling and composting.
  static double calculateWasteCarbon({
    required String recyclingHabits,
    required String plasticConsumption,
    required bool composting,
  }) {
    const double baseEmissions = AppConstants.factorWasteBase;

    double recyclingOffset = 0.0;
    if (recyclingHabits.toLowerCase() == 'regularly') {
      recyclingOffset = AppConstants.factorWasteRecycleReg;
    } else if (recyclingHabits.toLowerCase() == 'occasionally') {
      recyclingOffset = AppConstants.factorWasteRecycleOcc;
    }

    double plasticAdjustment = 0.0;
    if (plasticConsumption.toLowerCase() == 'high') {
      plasticAdjustment = AppConstants.factorPlasticHigh;
    } else if (plasticConsumption.toLowerCase() == 'low') {
      plasticAdjustment = AppConstants.factorPlasticLow;
    }

    final double compostOffset = composting ? AppConstants.factorCompostOffset : 0.0;

    return baseEmissions + recyclingOffset + plasticAdjustment + compostOffset;
  }

  /// Evaluates the sustainability score (0-100) based on annual footprint thresholds.
  static int calculateSustainabilityScore(double totalCarbon) {
    if (totalCarbon <= AppConstants.thresholdNetZero) return 100;
    if (totalCarbon >= AppConstants.thresholdMaxFootprint) return 0;

    final double range = AppConstants.thresholdMaxFootprint - AppConstants.thresholdNetZero;
    final double score = 100.0 - ((totalCarbon - AppConstants.thresholdNetZero) / range * 100.0);
    return max(0, min(100, score.round()));
  }

  /// Determines the letter grade corresponding to the sustainability score.
  static String calculateGrade(int score) {
    if (score >= 95) return 'A+';
    if (score >= 85) return 'A';
    if (score >= 70) return 'B';
    if (score >= 55) return 'C';
    if (score >= 40) return 'D';
    return 'F';
  }

  /// Categorizes the user's environmental personality based on score and relative category contributions.
  static String calculatePersonality({
    required int score,
    required double transportPct,
    required double energyPct,
    required double foodPct,
    required double shoppingPct,
    required double wastePct,
  }) {
    if (score >= 85) return 'Eco Hero';

    final double maxPct = [transportPct, energyPct, foodPct, shoppingPct, wastePct].reduce(max);

    if (maxPct == transportPct) {
      return score >= 60 ? 'Conscious Traveler' : 'Carbon Commuter';
    } else if (maxPct == energyPct) {
      return score >= 60 ? 'Energy Optimizer' : 'Grid Dependent';
    } else if (maxPct == foodPct) {
      return score >= 60 ? 'Green Gastronomer' : 'Carnivore Twin';
    } else if (maxPct == shoppingPct) {
      return score >= 60 ? 'Mindful Consumer' : 'Materialist Twin';
    } else {
      return score >= 60 ? 'Zero-Waste Aspirant' : 'Waste Producer';
    }
  }
}
