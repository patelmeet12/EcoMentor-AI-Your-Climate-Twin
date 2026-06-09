import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/user_progress.dart';
import '../../../widgets/glass_card.dart';

/// Card component that wraps the grid list of unlockable badge achievements.
class MedalsPanel extends StatelessWidget {
  final UserProgress progress;
  final List<Map<String, dynamic>> badges;
  final bool isDark;

  const MedalsPanel({
    super.key,
    required this.progress,
    required this.badges,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      enableHover: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Climatic Achievements & Medals', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Unlock badges by finishing carbon recommendations and keeping streaks.', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 20),

          // Medals Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> badge = badges[index];
              final bool isUnlocked = progress.achievements.contains(badge['id']);
              final Color iconColor = badge['color'] as Color;

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBg.withOpacity(0.5) : Colors.grey.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isUnlocked
                        ? iconColor.withOpacity(0.4)
                        : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                    width: isUnlocked ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Semantics(
                      label: '${badge['title']} badge is ${isUnlocked ? 'unlocked' : 'locked'}',
                      child: Icon(
                        isUnlocked ? (badge['icon'] as IconData) : Icons.lock_outline,
                        size: 32,
                        color: isUnlocked ? iconColor : Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      badge['title'] as String,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? null : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      badge['desc'] as String,
                      style: const TextStyle(fontSize: 9.5, color: Colors.grey),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
