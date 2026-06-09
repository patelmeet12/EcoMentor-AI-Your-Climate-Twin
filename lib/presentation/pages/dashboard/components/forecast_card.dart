import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/climate_twin.dart';
import '../../../../domain/entities/user_progress.dart';
import '../../../widgets/glass_card.dart';

/// Card component that presents monthly, semi-annual, and annual carbon projections.
class ForecastCard extends StatelessWidget {
  final ClimateTwin twin;
  final UserProgress progress;
  final bool isDark;

  const ForecastCard({
    super.key,
    required this.twin,
    required this.progress,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final int currentScore = twin.score;
    final String nextYearGrade = twin.grade;
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 500;

    final List<Widget> cols = [
      _buildForecastTimelineCol('Next 30 Days', '${(twin.monthlyEmissions).toStringAsFixed(0)} kg', 'Score: $currentScore', isMobile),
      _buildForecastTimelineCol('Next 6 Months', '${(twin.monthlyEmissions * 6).toStringAsFixed(0)} kg', 'Score: $currentScore', isMobile),
      _buildForecastTimelineCol('Next 1 Year', '${(twin.annualEmissions).toStringAsFixed(0)} kg', 'Grade: $nextYearGrade', isMobile),
    ];

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Carbon Forecast & Outlook',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Projections based on your active lifestyle and completed tasks.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          if (isMobile)
            Column(
              children: cols.map((col) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: col,
              )).toList(),
            )
          else
            Row(children: cols),
        ],
      ),
    );
  }

  Widget _buildForecastTimelineCol(String duration, String projectedEmissions, String metric, bool isMobile) {
    final Widget cardContent = Column(
      children: [
        Text(duration, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        Text(projectedEmissions, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
        const SizedBox(height: 4),
        Text(metric, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );

    if (isMobile) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.1)),
        ),
        child: cardContent,
      );
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.1)),
        ),
        child: cardContent,
      ),
    );
  }
}
