import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../providers/twin_provider.dart';

/// Renders a quick status preview showing streak, XP, and climate twin grade.
class QuickStatsCard extends StatelessWidget {
  final TwinState twinState;
  final bool isDark;

  const QuickStatsCard({
    super.key,
    required this.twinState,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (twinState.isLoading || !twinState.hasAssessment) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatMini(context, 'Streak', '${twinState.progress.streakDays}🔥'),
              _buildStatMini(context, 'XP Points', '${twinState.progress.xpPoints}'),
              _buildStatMini(context, 'Grade', twinState.twin.grade),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatMini(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
