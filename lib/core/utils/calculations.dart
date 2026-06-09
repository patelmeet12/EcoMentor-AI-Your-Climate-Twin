import 'dart:math';

class CarbonCalculations {
  /// Calculates annual transportation carbon emissions in kg CO2
  static double calculateTransportationCarbon({
    required String vehicleType,
    required double weeklyDistance,
    required double publicTransportHours,
    required int flightsPerYear,
  }) {
    double carEmissions = 0.0;
    double annualCarDistance = weeklyDistance * 52.0;

    switch (vehicleType.toLowerCase()) {
      case 'gasoline':
      case 'gasoline car':
        carEmissions = annualCarDistance * 0.18;
        break;
      case 'diesel':
      case 'diesel car':
        carEmissions = annualCarDistance * 0.17;
        break;
      case 'hybrid':
      case 'hybrid car':
        carEmissions = annualCarDistance * 0.09;
        break;
      case 'electric':
      case 'electric car':
        carEmissions = annualCarDistance * 0.05;
        break;
      case 'motorcycle':
        carEmissions = annualCarDistance * 0.08;
        break;
      default:
        carEmissions = 0.0; // "none" or invalid
    }

    // Public transport: hours/week converted to km/week (assume 25 km/h avg speed)
    double publicWeeklyKm = publicTransportHours * 25.0;
    double publicEmissions = publicWeeklyKm * 52.0 * 0.03;

    // Flights: average short/medium haul flights per year
    double flightEmissions = flightsPerYear * 500.0;

    return carEmissions + publicEmissions + flightEmissions;
  }

  /// Calculates annual home energy carbon emissions in kg CO2
  static double calculateEnergyCarbon({
    required double monthlyElectricityKwh,
    required double acHoursPerDay,
    required double renewableEnergyPercentage, // 0.0 to 1.0
  }) {
    // Electricity: monthly kwh * 12 * factor (0.85 kg/kwh in India/mixed grid)
    double electricityEmissions = monthlyElectricityKwh * 12.0 * 0.85 * (1.0 - renewableEnergyPercentage);

    // AC: hours/day * 365 * factor (assume typical split AC uses ~1.2 kW, factor is ~0.85 kg/kWh, so ~1.0 kg CO2/hour)
    // Let's use 0.6 kg CO2/hour as specified in implementation plan
    double acEmissions = acHoursPerDay * 365.0 * 0.6;

    return electricityEmissions + acEmissions;
  }

  /// Calculates annual food carbon emissions in kg CO2
  static double calculateFoodCarbon(String dietType) {
    switch (dietType.toLowerCase()) {
      case 'vegan':
        return 800.0;
      case 'vegetarian':
        return 1200.0;
      case 'mixed':
      case 'mixed diet':
        return 2000.0;
      case 'high meat':
      case 'high meat consumption':
        return 3000.0;
      default:
        return 2000.0;
    }
  }

  /// Calculates annual shopping carbon emissions in kg CO2
  static double calculateShoppingCarbon({
    required String frequency, // low, medium, high
    required String electronicsFrequency, // rarely, occasionally, frequently
  }) {
    double base = 0.0;
    switch (frequency.toLowerCase()) {
      case 'low':
        base = 200.0;
        break;
      case 'medium':
        base = 600.0;
        break;
      case 'high':
        base = 1200.0;
        break;
      default:
        base = 600.0;
    }

    double electronics = 0.0;
    switch (electronicsFrequency.toLowerCase()) {
      case 'rarely':
        electronics = 100.0;
        break;
      case 'occasionally':
        electronics = 200.0;
        break;
      case 'frequently':
        electronics = 600.0;
        break;
      default:
        electronics = 200.0;
    }

    return base + electronics;
  }

  /// Calculates annual waste carbon emissions in kg CO2
  static double calculateWasteCarbon({
    required String recyclingHabits, // regularly, occasionally, never
    required String plasticConsumption, // low, medium, high
    required bool composting,
  }) {
    double base = 500.0;

    double recyclingOffset = 0.0;
    if (recyclingHabits.toLowerCase() == 'regularly') {
      recyclingOffset = -150.0;
    } else if (recyclingHabits.toLowerCase() == 'occasionally') {
      recyclingOffset = -50.0;
    }

    double plasticAdjustment = 0.0;
    if (plasticConsumption.toLowerCase() == 'high') {
      plasticAdjustment = 100.0;
    } else if (plasticConsumption.toLowerCase() == 'low') {
      plasticAdjustment = -50.0;
    }

    double compostOffset = composting ? -100.0 : 0.0;

    return base + recyclingOffset + plasticAdjustment + compostOffset;
  }

  /// Calculates sustainability score (0-100) based on total carbon emissions in kg CO2/year.
  /// 1500 kg is very sustainable (score 100). 15000 kg or above is highly unsustainable (score 0).
  static int calculateSustainabilityScore(double totalCarbon) {
    if (totalCarbon <= 1500) return 100;
    if (totalCarbon >= 15000) return 0;

    double score = 100.0 - ((totalCarbon - 1500) / (15000 - 1500) * 100.0);
    return max(0, min(100, score.round()));
  }

  /// Calculates the sustainability grade from the score (A+ to F)
  static String calculateGrade(int score) {
    if (score >= 95) return 'A+';
    if (score >= 85) return 'A';
    if (score >= 70) return 'B';
    if (score >= 55) return 'C';
    if (score >= 40) return 'D';
    return 'F';
  }

  /// Determines the environmental personality of the Climate Twin
  static String calculatePersonality({
    required int score,
    required double transportPct,
    required double energyPct,
    required double foodPct,
    required double shoppingPct,
    required double wastePct,
  }) {
    if (score >= 85) return 'Eco Hero';

    double maxPct = [transportPct, energyPct, foodPct, shoppingPct, wastePct].reduce(max);

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
