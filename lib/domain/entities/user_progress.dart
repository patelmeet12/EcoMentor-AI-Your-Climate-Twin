class UserProgress {
  final List<String> completedActionIds;
  final double totalCarbonReduced; // in kg CO2
  final int xpPoints;
  final int streakDays;
  final List<String> achievements; // list of achievements ids/names
  final String? lastUpdatedDate; // YYYY-MM-DD for streak tracking

  const UserProgress({
    required this.completedActionIds,
    required this.totalCarbonReduced,
    required this.xpPoints,
    required this.streakDays,
    required this.achievements,
    this.lastUpdatedDate,
  });

  factory UserProgress.empty() => const UserProgress(
        completedActionIds: [],
        totalCarbonReduced: 0.0,
        xpPoints: 0,
        streakDays: 0,
        achievements: [],
        lastUpdatedDate: null,
      );

  UserProgress copyWith({
    List<String>? completedActionIds,
    double? totalCarbonReduced,
    int? xpPoints,
    int? streakDays,
    List<String>? achievements,
    String? lastUpdatedDate,
  }) {
    return UserProgress(
      completedActionIds: completedActionIds ?? this.completedActionIds,
      totalCarbonReduced: totalCarbonReduced ?? this.totalCarbonReduced,
      xpPoints: xpPoints ?? this.xpPoints,
      streakDays: streakDays ?? this.streakDays,
      achievements: achievements ?? this.achievements,
      lastUpdatedDate: lastUpdatedDate ?? this.lastUpdatedDate,
    );
  }
}
