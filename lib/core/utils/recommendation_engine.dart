import '../../domain/entities/assessment.dart';
import '../../domain/entities/recommendation.dart';
import '../constants/app_constants.dart';

/// Local rule-based suggestion engine. Analyzes lifestyle details and generates
/// prioritized actionable recommendations with annual cash and carbon offsets.
class RecommendationEngine {
  /// Evaluates assessment answers and returns a list of tailored recommendations.
  static List<Recommendation> generateRecommendations(Assessment habits, double totalCarbon) {
    final List<Recommendation> recommendationsList = [];

    // Calculate category carbon scores first to show relative importance
    final double transportCarbon = habits.weeklyDistance * 52.0 *
            (habits.vehicleType.toLowerCase().contains('gasoline')
                ? AppConstants.factorGasolineCar
                : habits.vehicleType.toLowerCase().contains('diesel')
                    ? AppConstants.factorDieselCar
                    : habits.vehicleType.toLowerCase().contains('hybrid')
                        ? AppConstants.factorHybridCar
                        : habits.vehicleType.toLowerCase().contains('electric')
                            ? AppConstants.factorElectricCar
                            : habits.vehicleType.toLowerCase().contains('motorcycle')
                                ? AppConstants.factorMotorcycle
                                : 0.0) +
        (habits.publicTransportUsage * AppConstants.avgPublicSpeedKmh * 52.0 * AppConstants.factorPublicTransport) +
        (habits.flightsPerYear * AppConstants.factorFlights);

    final double energyCarbon = (habits.monthlyElectricity *
            12.0 *
            AppConstants.factorGridElectricity *
            (1.0 - habits.renewableEnergyUsage)) +
        (habits.acUsage * 365.0 * AppConstants.factorAcHour);

    // Helper to calculate percentages
    final double transportPct = totalCarbon > 0 ? (transportCarbon / totalCarbon * 100) : 0;
    final double energyPct = totalCarbon > 0 ? (energyCarbon / totalCarbon * 100) : 0;

    // 1. TRANSPORTATION RECOMMENDATIONS
    final bool isCommuterFossilFuel = habits.vehicleType.toLowerCase().contains('gasoline') ||
        habits.vehicleType.toLowerCase().contains('diesel');
        
    if (isCommuterFossilFuel && habits.weeklyDistance >= 80) {
      // Propose carpooling/transit 2 days per week (approx 35% reduction of private driving)
      final double annualCommuteSavings = habits.weeklyDistance * 52.0 * 0.35;
      recommendationsList.add(Recommendation(
        id: 'trans_carpool',
        title: 'Switch to Carpool or Transit 2 days/week',
        description: 'Reduce weekly driving of your fossil fuel car by sharing rides or utilizing public transport.',
        category: 'transportation',
        impactKg: annualCommuteSavings * AppConstants.factorGasolineCar, // default gasoline factor for generic savings
        savingsInr: annualCommuteSavings * 6.5, // at ₹6.5 running cost/km
        difficulty: 'Low',
        priority: transportPct >= 40 ? 'High' : 'Medium',
        reasoning: 'Transportation contributes ${transportPct.toStringAsFixed(0)}% of your footprint. Replacing two weekly drives with transit reduces urban congestion and reduces fossil fuel depletion.',
      ));
    }

    if (isCommuterFossilFuel && habits.weeklyDistance >= 150) {
      // Propose EV upgrade
      recommendationsList.add(Recommendation(
        id: 'trans_ev',
        title: 'Transition to an Electric Vehicle (EV)',
        description: 'Upgrade your primary high-emission car to a fully battery-electric vehicle for your commutes.',
        category: 'transportation',
        impactKg: habits.weeklyDistance * 52.0 * (AppConstants.factorGasolineCar - AppConstants.factorElectricCar),
        savingsInr: habits.weeklyDistance * 52.0 * 3.5, // ₹3.5/km electric running cost delta savings
        difficulty: 'High',
        priority: transportPct >= 50 ? 'High' : 'Medium',
        reasoning: 'Replacing your ICE car with an EV reduces operating costs and shifts your energy usage to more sustainable electric options, saving significant emissions long-term.',
      ));
    }

    if (habits.flightsPerYear >= 2) {
      // Flight reduction
      recommendationsList.add(Recommendation(
        id: 'trans_flights',
        title: 'Offset flight carbon or travel via trains',
        description: 'Consider substituting domestic short-haul flights with high-speed rail, or purchase verified carbon offsets.',
        category: 'transportation',
        impactKg: habits.flightsPerYear * (AppConstants.factorFlights * 0.5), // assume cutting flights by 50%
        savingsInr: habits.flightsPerYear * 6000.0,
        difficulty: 'Medium',
        priority: 'High',
        reasoning: 'A single flight contributes 500 kg of CO2 directly into the upper atmosphere. Reducing flights or offsetting is essential to balance high travel emissions.',
      ));
    }

    // 2. ENERGY RECOMMENDATIONS
    if (habits.acUsage >= 3) {
      recommendationsList.add(Recommendation(
        id: 'energy_ac_temp',
        title: 'Set your AC temperature to 24°C or above',
        description: 'Raise your AC setpoint from a cold temperature (e.g., 18°C) to 24°C. Use ceiling fans to circulate air.',
        category: 'energy',
        impactKg: habits.acUsage * 365.0 * AppConstants.factorAcHour * 0.20, // 20% AC saving
        savingsInr: habits.acUsage * 365.0 * 1.2 * 0.20 * 8.0, // AC power 1.2kW * 20% * ₹8/kWh
        difficulty: 'Low',
        priority: energyPct >= 30 ? 'High' : 'Medium',
        reasoning: 'Every 1°C increase in AC temperature settings saves roughly 6% in AC power consumption, quickly lowering your electricity bill and grid load.',
      ));
    }

    if (habits.renewableEnergyUsage < 0.2 && habits.monthlyElectricity >= 100) {
      recommendationsList.add(Recommendation(
        id: 'energy_solar',
        title: 'Install Rooftop Solar Panels',
        description: 'Cover a portion of your monthly energy usage with solar panels or opt for a green utility grid tariff.',
        category: 'energy',
        impactKg: habits.monthlyElectricity * 12.0 * AppConstants.factorGridElectricity * 0.6, // 60% offset
        savingsInr: habits.monthlyElectricity * 12.0 * 0.6 * 7.5, // 60% power savings at ₹7.5/kWh
        difficulty: 'High',
        priority: energyPct >= 40 ? 'High' : 'Medium',
        reasoning: 'Your home primarily relies on grid energy. Offsetting 60% of your footprint with clean solar power yields high emissions reduction and eliminates monthly power costs.',
      ));
    }

    // 3. FOOD RECOMMENDATIONS
    final String diet = habits.dietType.toLowerCase();
    if (diet == 'high meat' || diet == 'high meat consumption') {
      recommendationsList.add(Recommendation(
        id: 'food_meatless',
        title: 'Introduce Meatless Mondays',
        description: 'Substitute animal proteins with beans, lentils, tofu, and other plant-based options one day per week.',
        category: 'food',
        impactKg: 350.0,
        savingsInr: 4500.0,
        difficulty: 'Low',
        priority: 'High',
        reasoning: 'Livestock farming produces major methane emissions. Eating plant-based meals even one day a week significantly drops food-related carbon footprint.',
      ));
    }

    if (diet == 'mixed' || diet.contains('mixed')) {
      recommendationsList.add(Recommendation(
        id: 'food_vegetarian',
        title: 'Adopt a Vegetarian Diet',
        description: 'Remove meat from your daily diet while retaining dairy products and organic eggs.',
        category: 'food',
        impactKg: AppConstants.factorDietMixed - AppConstants.factorDietVegetarian,
        savingsInr: 10000.0,
        difficulty: 'Medium',
        priority: 'Medium',
        reasoning: 'Reducing meat products avoids land degradation and greenhouse gas emissions associated with animal agriculture.',
      ));
    }

    // 4. SHOPPING RECOMMENDATIONS
    final String elect = habits.electronicsPurchase.toLowerCase();
    if (elect == 'frequently' || elect == 'occasionally') {
      recommendationsList.add(Recommendation(
        id: 'shop_refurbished',
        title: 'Purchase Refurbished Electronics',
        description: 'Opt for certified pre-owned or refurbished items for your next smartphone, laptop, or home appliance.',
        category: 'shopping',
        impactKg: 200.0,
        savingsInr: 12000.0,
        difficulty: 'Low',
        priority: 'Medium',
        reasoning: 'Manufacturing digital devices produces high emissions and electronic waste. Refurbished gadgets extend product lifespans and cut electronic waste.',
      ));
    }

    if (habits.shoppingFrequency.toLowerCase() == 'high') {
      recommendationsList.add(Recommendation(
        id: 'shop_mindful',
        title: 'Practice a One-In, One-Out Shopping Rule',
        description: 'Prevent impulsive purchases. Buy new items only to replace worn-out essentials.',
        category: 'shopping',
        impactKg: 400.0,
        savingsInr: 25000.0,
        difficulty: 'Medium',
        priority: 'Medium',
        reasoning: 'Industrial production, shipping, and fast-fashion disposal generate severe supply chain pollution. Buying less directly reduces these background impacts.',
      ));
    }

    // 5. WASTE RECOMMENDATIONS
    if (!habits.composting) {
      recommendationsList.add(Recommendation(
        id: 'waste_compost',
        title: 'Start Organic Composting',
        description: 'Set up a small home composter for organic vegetable peels, coffee grounds, and food leftovers.',
        category: 'waste',
        impactKg: AppConstants.factorCompostOffset.abs(),
        savingsInr: 1500.0,
        difficulty: 'Medium',
        priority: 'Low',
        reasoning: 'Organic kitchen waste trapped in landfills generates methane gas due to anaerobic conditions. Composting turns it into nutrient-rich soil aerobically.',
      ));
    }

    final String recycle = habits.recyclingHabits.toLowerCase();
    if (recycle == 'never' || recycle == 'occasionally') {
      recommendationsList.add(Recommendation(
        id: 'waste_recycle',
        title: 'Implement Dedicated Waste Segregation',
        description: 'Divide household waste into dry recyclables (paper, plastic, metal) and organic waste.',
        category: 'waste',
        impactKg: AppConstants.factorWasteRecycleReg.abs(),
        savingsInr: 1000.0,
        difficulty: 'Low',
        priority: 'High',
        reasoning: 'Recycling saves materials from landfills and energy-intensive manufacturing processes, forming a crucial circular economy habit.',
      ));
    }

    // Default recommendation if list is too short
    if (recommendationsList.length < 3) {
      recommendationsList.add(Recommendation(
        id: 'default_energy_efficient_lights',
        title: 'Upgrade to Smart LED Lighting',
        description: 'Replace remaining halogen or CFL bulbs with energy star rated LED lights.',
        category: 'energy',
        impactKg: 120.0,
        savingsInr: 2200.0,
        difficulty: 'Low',
        priority: 'High',
        reasoning: 'LED lighting consumes 80% less energy than incandescent lightbulbs and has a much longer lifespan.',
      ));
    }

    return recommendationsList;
  }
}
