import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../providers/twin_provider.dart';
import 'accessibility_controls_card.dart';
import 'nav_item.dart';

/// The sidebar navigation drawer presented to desktop-sized screens.
class DesktopSidebar extends ConsumerWidget {
  final List<NavItem> navItems;
  final String currentLocation;
  final TwinState twinState;
  final bool isDark;
  final bool highContrast;

  const DesktopSidebar({
    super.key,
    required this.navItems,
    required this.currentLocation,
    required this.twinState,
    required this.isDark,
    required this.highContrast,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 260,
      color: isDark ? AppColors.darkBg : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: AppColors.primaryGradient,
                ),
                child: const Icon(Icons.eco, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EcoMentor AI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    'CLIMATE TWIN',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Quick Progress Status
          _buildQuickStatsCard(context, twinState, isDark),
          const SizedBox(height: 24),

          // Nav Links
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              'NAVIGATION',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1),
            ),
          ),
          ...navItems.map((item) {
            final isActive = item.route == currentLocation;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Semantics(
                button: true,
                selected: isActive,
                label: 'Go to ${item.label}',
                child: InkWell(
                  onTap: () => context.go(item.route),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isActive
                          ? AppColors.primary.withOpacity(isDark ? 0.12 : 0.08)
                          : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isActive ? item.activeIcon : item.icon,
                          color: isActive ? AppColors.primary : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            color: isActive ? AppColors.primary : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          const Spacer(),

          // Accessibility Settings Panel
          Divider(color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              'ACCESSIBILITY',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1),
            ),
          ),
          AccessibilityControlsCard(isDark: isDark, highContrast: highContrast),
        ],
      ),
    );
  }

  Widget _buildQuickStatsCard(BuildContext context, TwinState twinState, bool isDark) {
    if (twinState.isLoading || !twinState.hasAssessment) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
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
