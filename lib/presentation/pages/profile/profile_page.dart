import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/twin_avatar.dart';
import '../../providers/twin_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final twinState = ref.watch(twinProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (twinState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final twin = twinState.twin;
    final progress = twinState.progress;

    // Calculate level based on XP (e.g. Level = XP / 400 + 1)
    final int level = (progress.xpPoints / 400).floor() + 1;
    final int nextLevelXp = level * 400;
    final int prevLevelXp = (level - 1) * 400;
    final double levelProgress = ((progress.xpPoints - prevLevelXp) / 400.0).clamp(0.0, 1.0);

    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 900;

    final badges = [
      {
        'id': 'Green Starter',
        'title': 'Green Starter',
        'desc': 'Completed onboarding lifestyle assessment.',
        'icon': Icons.eco,
        'color': Colors.teal,
      },
      {
        'id': 'Carbon Reducer',
        'title': 'Carbon Reducer',
        'desc': 'Completed your first carbon-reduction recommendation.',
        'icon': Icons.bolt,
        'color': Colors.amber,
      },
      {
        'id': 'Eco Explorer',
        'title': 'Eco Explorer',
        'desc': 'Replaced habits to achieve a Sustainability Score >= 70.',
        'icon': Icons.explore,
        'color': Colors.cyan,
      },
      {
        'id': 'Sustainability Hero',
        'title': 'Sustainability Hero',
        'desc': 'Optimized habits to reach a score >= 85.',
        'icon': Icons.shield_rounded,
        'color': Colors.purpleAccent,
      },
      {
        'id': 'Planet Guardian',
        'title': 'Planet Guardian',
        'desc': 'Successfully checked off 3 or more carbon tasks.',
        'icon': Icons.spa,
        'color': Colors.blueAccent,
      },
      {
        'id': 'Streak Master',
        'title': 'Streak Master',
        'desc': 'Maintained a consistent daily green streak for 3 days.',
        'icon': Icons.local_fire_department,
        'color': Colors.orange,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title block
            Text(
              'Climate Twin & Achievements',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage your environmental twin, monitor credentials, and review earned badges.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Top Profile summary
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildTwinIdentityCard(twin, progress, level, levelProgress, nextLevelXp, isDark)),
                  const SizedBox(width: 24),
                  Expanded(flex: 4, child: _buildMedalsPanel(progress, badges, isDark)),
                ],
              )
            else ...[
              _buildTwinIdentityCard(twin, progress, level, levelProgress, nextLevelXp, isDark),
              const SizedBox(height: 24),
              _buildMedalsPanel(progress, badges, isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTwinIdentityCard(
    dynamic twin,
    dynamic progress,
    int level,
    double levelProgress,
    int nextLevelXp,
    bool isDark,
  ) {
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

  Widget _buildMedalsPanel(dynamic progress, List<Map<String, dynamic>> badges, bool isDark) {
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
              childAspectRatio: 1.25,
            ),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              final badge = badges[index];
              final isUnlocked = progress.achievements.contains(badge['id']);
              final iconColor = badge['color'] as Color;

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
