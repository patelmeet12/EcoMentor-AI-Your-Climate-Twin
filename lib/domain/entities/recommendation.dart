class Recommendation {
  final String id;
  final String title;
  final String description;
  final String category; // transportation, energy, food, shopping, waste
  final double impactKg; // Annual CO2 reduction in kg
  final double savingsInr; // Annual savings in INR (₹)
  final String difficulty; // Low, Medium, High
  final String priority; // Low, Medium, High
  final String reasoning;
  final bool isCompleted;

  const Recommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.impactKg,
    required this.savingsInr,
    required this.difficulty,
    required this.priority,
    required this.reasoning,
    this.isCompleted = false,
  });

  Recommendation copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    double? impactKg,
    double? savingsInr,
    String? difficulty,
    String? priority,
    String? reasoning,
    bool? isCompleted,
  }) {
    return Recommendation(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      impactKg: impactKg ?? this.impactKg,
      savingsInr: savingsInr ?? this.savingsInr,
      difficulty: difficulty ?? this.difficulty,
      priority: priority ?? this.priority,
      reasoning: reasoning ?? this.reasoning,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
