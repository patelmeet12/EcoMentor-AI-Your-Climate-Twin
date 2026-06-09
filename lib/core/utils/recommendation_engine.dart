import '../../domain/entities/assessment.dart';
import '../../domain/entities/recommendation.dart';

class RecommendationEngine {
  static List<Recommendation> generateRecommendations(Assessment habits, double totalCarbon) {
    final List<Recommendation> list = [];

    // Calculate category carbon scores first to show relative importance
    final transportCarbon = habits.weeklyDistance * 52.0 * 
        (habits.vehicleType.toLowerCase().contains('gasoline') ? 0.18 :
         habits.vehicleType.toLowerCase().contains('diesel') ? 0.17 :
         habits.vehicleType.toLowerCase().contains('hybrid') ? 0.09 :
         habits.vehicleType.toLowerCase().contains('electric') ? 0.05 :
         habits.vehicleType.toLowerCase().contains('motorcycle') ? 0.08 : 0.0) +
        (habits.publicTransportUsage * 25.0 * 52.0 * 0.03) +
        (habits.flightsPerYear * 500.0);

    final energyCarbon = (habits.monthlyElectricity * 12.0 * 0.85 * (1.0 - habits.renewableEnergyUsage)) +
        (habits.acUsage * 365.0 * 0.6);

    // Helper to calculate percentages
    final double transportPct = totalCarbon > 0 ? (transportCarbon / totalCarbon * 100) : 0;
    final double energyPct = totalCarbon > 0 ? (energyCarbon / totalCarbon * 100) : 0;

    // 1. TRANSPORTATION RECOMMENDATIONS
    if ((habits.vehicleType.toLowerCase().contains('gasoline') || 
         habits.vehicleType.toLowerCase().contains('diesel')) && 
        habits.weeklyDistance >= 80) {
      list.add(Recommendation(
        id: 'trans_carpool',
        title: 'Switch to Carpool or Transit 2 days/week',
        description: 'Reduce weekly driving of your fossil fuel car by sharing rides or utilizing public transport.',
        category: 'transportation',
        impactKg: habits.weeklyDistance * 52.0 * 0.18 * 0.35, // 35% reduction
        savingsInr: habits.weeklyDistance * 52.0 * 0.35 * 6.5, // 35% savings at ~₹6.5 fuel cost/km
        difficulty: 'Low',
        priority: transportPct >= 40 ? 'High' : 'Medium',
        reasoning: 'Transportation contributes ${transportPct.toStringAsFixed(0)}% of your footprint. Replacing two weekly drives with transit reduces urban congestion and reduces fossil fuel depletion.',
      ));
    }

    if ((habits.vehicleType.toLowerCase().contains('gasoline') || 
         habits.vehicleType.toLowerCase().contains('diesel')) && 
        habits.weeklyDistance >= 150) {
      list.add(Recommendation(
        id: 'trans_ev',
        title: 'Transition to an Electric Vehicle (EV)',
        description: 'Upgrade your primary high-emission car to a fully battery-electric vehicle for your commutes.',
        category: 'transportation',
        impactKg: habits.weeklyDistance * 52.0 * 0.13, // Difference of gasoline (0.18) vs electric (0.05)
        savingsInr: habits.weeklyDistance * 52.0 * 3.5, // Saving of ₹3.5/km in running costs
        difficulty: 'High',
        priority: transportPct >= 50 ? 'High' : 'Medium',
        reasoning: 'Replacing your ICE car with an EV reduces operating costs and shifts your energy usage to more sustainable electric options, saving significant emissions long-term.',
      ));
    }

    if (habits.flightsPerYear >= 2) {
      list.add(Recommendation(
        id: 'trans_flights',
        title: 'Offset flight carbon or travel via trains',
        description: 'Consider substituting domestic short-haul flights with high-speed rail, or purchase verified carbon offsets.',
        category: 'transportation',
        impactKg: habits.flightsPerYear * 250.0, // reduce flights by 50%
        savingsInr: habits.flightsPerYear * 6000.0, // average flight cost difference
        difficulty: 'Medium',
        priority: 'High',
        reasoning: 'A single flight contributes 500 kg of CO2 directly into the upper atmosphere. Reducing flights or offsetting is essential to balance high travel emissions.',
      ));
    }

    // 2. ENERGY RECOMMENDATIONS
    if (habits.acUsage >= 3) {
      list.add(Recommendation(
        id: 'energy_ac_temp',
        title: 'Set your AC temperature to 24°C or above',
        description: 'Raise your AC setpoint from a cold temperature (e.g., 18°C) to 24°C. Use ceiling fans to circulate air.',
        category: 'energy',
        impactKg: habits.acUsage * 365.0 * 0.6 * 0.20, // 20% savings on AC load
        savingsInr: habits.acUsage * 365.0 * 1.2 * 0.20 * 8.0, // AC power 1.2kW * 20% * ₹8/kWh
        difficulty: 'Low',
        priority: energyPct >= 30 ? 'High' : 'Medium',
        reasoning: 'Every 1°C increase in AC temperature settings saves roughly 6% in AC power consumption, quickly lowering your electricity bill and grid load.',
      ));
    }

    if (habits.renewableEnergyUsage < 0.2 && habits.monthlyElectricity >= 100) {
      list.add(Recommendation(
        id: 'energy_solar',
        title: 'Install Rooftop Solar Panels',
        description: 'Cover a portion of your monthly energy usage with solar panels or opt for a green utility grid tariff.',
        category: 'energy',
        impactKg: habits.monthlyElectricity * 12.0 * 0.85 * 0.6, // 60% grid offset
        savingsInr: habits.monthlyElectricity * 12.0 * 0.6 * 7.5, // 60% power savings at ₹7.5/kWh
        difficulty: 'High',
        priority: energyPct >= 40 ? 'High' : 'Medium',
        reasoning: 'Your home primarily relies on grid energy. Offsetting 60% of your footprint with clean solar power yields high emissions reduction and eliminates monthly power costs.',
      ));
    }

    // 3. FOOD RECOMMENDATIONS
    if (habits.dietType.toLowerCase() == 'high meat' || habits.dietType.toLowerCase() == 'high meat consumption') {
      list.add(Recommendation(
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

    if (habits.dietType.toLowerCase() == 'mixed' || habits.dietType.toLowerCase().contains('mixed')) {
      list.add(Recommendation(
        id: 'food_vegetarian',
        title: 'Adopt a Vegetarian Diet',
        description: 'Remove meat from your daily diet while retaining dairy products and organic eggs.',
        category: 'food',
        impactKg: 800.0, // 2000kg mixed -> 1200kg vegetarian
        savingsInr: 10000.0,
        difficulty: 'Medium',
        priority: 'Medium',
        reasoning: 'Reducing meat products avoids land degradation and greenhouse gas emissions associated with animal agriculture.',
      ));
    }

    // 4. SHOPPING RECOMMENDATIONS
    if (habits.electronicsPurchase.toLowerCase() == 'frequently' || 
        habits.electronicsPurchase.toLowerCase() == 'occasionally') {
      list.add(Recommendation(
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
      list.add(Recommendation(
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
      list.add(Recommendation(
        id: 'waste_compost',
        title: 'Start Organic Composting',
        description: 'Set up a small home composter for organic vegetable peels, coffee grounds, and food leftovers.',
        category: 'waste',
        impactKg: 100.0,
        savingsInr: 1500.0, // saves buying soil/fertilizers
        difficulty: 'Medium',
        priority: 'Low',
        reasoning: 'Organic kitchen waste trapped in landfills generates methane gas due to anaerobic conditions. Composting turns it into nutrient-rich soil aerobically.',
      ));
    }

    if (habits.recyclingHabits.toLowerCase() == 'never' || 
        habits.recyclingHabits.toLowerCase() == 'occasionally') {
      list.add(Recommendation(
        id: 'waste_recycle',
        title: 'Implement Dedicated Waste Segregation',
        description: 'Divide household waste into dry recyclables (paper, plastic, metal) and organic waste.',
        category: 'waste',
        impactKg: 150.0,
        savingsInr: 1000.0,
        difficulty: 'Low',
        priority: 'High',
        reasoning: 'Recycling saves materials from landfills and energy-intensive manufacturing processes, forming a crucial circular economy habit.',
      ));
    }

    // Default recommendation if list is too short
    if (list.length < 3) {
      list.add(Recommendation(
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

    return list;
  }
}
