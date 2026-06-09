class ClimateTwin {
  final int score;
  final String grade;
  final String personality;
  final double monthlyEmissions; // in kg CO2
  final double annualEmissions;  // in kg CO2
  final String biggestSource;

  // Category breakdown in kg CO2
  final double transportEmissions;
  final double energyEmissions;
  final double foodEmissions;
  final double shoppingEmissions;
  final double wasteEmissions;

  final List<String> insights;

  const ClimateTwin({
    required this.score,
    required this.grade,
    required this.personality,
    required this.monthlyEmissions,
    required this.annualEmissions,
    required this.biggestSource,
    required this.transportEmissions,
    required this.energyEmissions,
    required this.foodEmissions,
    required this.shoppingEmissions,
    required this.wasteEmissions,
    required this.insights,
  });

  factory ClimateTwin.empty() => const ClimateTwin(
        score: 100,
        grade: 'A+',
        personality: 'Eco Hero',
        monthlyEmissions: 0.0,
        annualEmissions: 0.0,
        biggestSource: 'None',
        transportEmissions: 0.0,
        energyEmissions: 0.0,
        foodEmissions: 0.0,
        shoppingEmissions: 0.0,
        wasteEmissions: 0.0,
        insights: [],
      );

  ClimateTwin copyWith({
    int? score,
    String? grade,
    String? personality,
    double? monthlyEmissions,
    double? annualEmissions,
    String? biggestSource,
    double? transportEmissions,
    double? energyEmissions,
    double? foodEmissions,
    double? shoppingEmissions,
    double? wasteEmissions,
    List<String>? insights,
  }) {
    return ClimateTwin(
      score: score ?? this.score,
      grade: grade ?? this.grade,
      personality: personality ?? this.personality,
      monthlyEmissions: monthlyEmissions ?? this.monthlyEmissions,
      annualEmissions: annualEmissions ?? this.annualEmissions,
      biggestSource: biggestSource ?? this.biggestSource,
      transportEmissions: transportEmissions ?? this.transportEmissions,
      energyEmissions: energyEmissions ?? this.energyEmissions,
      foodEmissions: foodEmissions ?? this.foodEmissions,
      shoppingEmissions: shoppingEmissions ?? this.shoppingEmissions,
      wasteEmissions: wasteEmissions ?? this.wasteEmissions,
      insights: insights ?? this.insights,
    );
  }
}
