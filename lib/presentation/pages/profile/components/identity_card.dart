import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/climate_twin.dart';
import '../../../../domain/entities/user_progress.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/twin_avatar.dart';

/// Card component that presents the user's level, XP progress bar, and streak metrics.
class IdentityCard extends StatelessWidget {
  final ClimateTwin twin;
  final UserProgress progress;
  final int level;
  final double levelProgress;
  final int nextLevelXp;
  final bool isDark;

  const IdentityCard({
    super.key,
    required this.twin,
    required this.progress,
    required this.level,
    required this.levelProgress,
    required this.nextLevelXp,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      enableHover: false,
      child: Column(
        children: [
          TwinAvatar(score: twin.score, personality: twin.personality, size: 140),
          const SizedBox(height: 16),
          Text(twin.personality, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            'Level $level Climatic Twin',
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // XP progress bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Level $level', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              Text('${progress.xpPoints} / $nextLevelXp XP', style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: levelProgress,
              minHeight: 10,
              backgroundColor: isDark ? AppColors.darkBg : Colors.grey.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 24),

          // Side stats
          Row(
            children: [
              _buildCompactStatCol('Streak count', '${progress.streakDays} days 🔥'),
              const VerticalDivider(),
              _buildCompactStatCol('Reduced CO₂', '${progress.totalCarbonReduced.toStringAsFixed(0)} kg 🍀'),
              const VerticalDivider(),
              _buildCompactStatCol('Score', '${twin.score}/100 🎯'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatCol(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
