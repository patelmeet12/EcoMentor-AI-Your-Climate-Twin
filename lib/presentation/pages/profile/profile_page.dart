import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/twin_provider.dart';
import 'components/identity_card.dart';
import 'components/medals_panel.dart';

/// The main page that displays the user's Climate Twin credentials and unlockable badge achievements.
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

    const badges = AppConstants.badges;

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
                  Expanded(
                    flex: 3,
                    child: IdentityCard(
                      twin: twin,
                      progress: progress,
                      level: level,
                      levelProgress: levelProgress,
                      nextLevelXp: nextLevelXp,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 4,
                    child: MedalsPanel(
                      progress: progress,
                      badges: badges,
                      isDark: isDark,
                    ),
                  ),
                ],
              )
            else ...[
              IdentityCard(
                twin: twin,
                progress: progress,
                level: level,
                levelProgress: levelProgress,
                nextLevelXp: nextLevelXp,
                isDark: isDark,
              ),
              const SizedBox(height: 24),
              MedalsPanel(
                progress: progress,
                badges: badges,
                isDark: isDark,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

