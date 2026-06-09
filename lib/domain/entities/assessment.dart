class Assessment {
  final String vehicleType;
  final String fuelType;
  final double weeklyDistance;
  final double publicTransportUsage; // hours/week
  final int flightsPerYear;
  final double monthlyElectricity; // kWh
  final double acUsage; // hours/day
  final double renewableEnergyUsage; // ratio (0.0 to 1.0)
  final String dietType; // vegan, vegetarian, mixed, high meat
  final String shoppingFrequency; // low, medium, high
  final String electronicsPurchase; // rarely, occasionally, frequently
  final String recyclingHabits; // regularly, occasionally, never
  final String plasticConsumption; // low, medium, high
  final bool composting;

  const Assessment({
    required this.vehicleType,
    required this.fuelType,
    required this.weeklyDistance,
    required this.publicTransportUsage,
    required this.flightsPerYear,
    required this.monthlyElectricity,
    required this.acUsage,
    required this.renewableEnergyUsage,
    required this.dietType,
    required this.shoppingFrequency,
    required this.electronicsPurchase,
    required this.recyclingHabits,
    required this.plasticConsumption,
    required this.composting,
  });

  factory Assessment.empty() => const Assessment(
        vehicleType: 'None',
        fuelType: 'None',
        weeklyDistance: 0.0,
        publicTransportUsage: 0.0,
        flightsPerYear: 0,
        monthlyElectricity: 0.0,
        acUsage: 0.0,
        renewableEnergyUsage: 0.0,
        dietType: 'Mixed',
        shoppingFrequency: 'Medium',
        electronicsPurchase: 'Occasionally',
        recyclingHabits: 'Occasionally',
        plasticConsumption: 'Medium',
        composting: false,
      );

  Assessment copyWith({
    String? vehicleType,
    String? fuelType,
    double? weeklyDistance,
    double? publicTransportUsage,
    int? flightsPerYear,
    double? monthlyElectricity,
    double? acUsage,
    double? renewableEnergyUsage,
    String? dietType,
    String? shoppingFrequency,
    String? electronicsPurchase,
    String? recyclingHabits,
    String? plasticConsumption,
    bool? composting,
  }) {
    return Assessment(
      vehicleType: vehicleType ?? this.vehicleType,
      fuelType: fuelType ?? this.fuelType,
      weeklyDistance: weeklyDistance ?? this.weeklyDistance,
      publicTransportUsage: publicTransportUsage ?? this.publicTransportUsage,
      flightsPerYear: flightsPerYear ?? this.flightsPerYear,
      monthlyElectricity: monthlyElectricity ?? this.monthlyElectricity,
      acUsage: acUsage ?? this.acUsage,
      renewableEnergyUsage: renewableEnergyUsage ?? this.renewableEnergyUsage,
      dietType: dietType ?? this.dietType,
      shoppingFrequency: shoppingFrequency ?? this.shoppingFrequency,
      electronicsPurchase: electronicsPurchase ?? this.electronicsPurchase,
      recyclingHabits: recyclingHabits ?? this.recyclingHabits,
      plasticConsumption: plasticConsumption ?? this.plasticConsumption,
      composting: composting ?? this.composting,
    );
  }
}
