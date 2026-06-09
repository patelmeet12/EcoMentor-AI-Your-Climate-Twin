import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/climate_twin.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/score_gauge.dart';
import '../../../widgets/twin_avatar.dart';

/// Card component that presents the user's Climate Twin mood, personality, and score.
class TwinProfileCard extends StatelessWidget {
  final ClimateTwin twin;
  final bool isDark;

  const TwinProfileCard({super.key, required this.twin, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 680;

    if (isMobile) {
      return GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TwinAvatar(score: twin.score, personality: twin.personality, size: 120),
                const SizedBox(width: 24),
                ScoreGauge(score: twin.score, grade: twin.grade, size: 100),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                twin.personality.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Twin Sustainability Grade: ${twin.grade}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              twin.insights.isNotEmpty
                  ? twin.insights.first
                  : 'Transportation constitutes a major portion of your footprint. Complete recommendations to improve your grade.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TwinAvatar(score: twin.score, personality: twin.personality, size: 140),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    twin.personality.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Twin Sustainability Grade: ${twin.grade}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  twin.insights.isNotEmpty
                      ? twin.insights.first
                      : 'Transportation constitutes a major portion of your footprint. Complete recommendations to improve your grade.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ScoreGauge(score: twin.score, grade: twin.grade, size: 110),
        ],
      ),
    );
  }
}
