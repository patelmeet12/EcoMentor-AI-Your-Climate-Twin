import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/theme_provider.dart';
import '../../providers/twin_provider.dart';

class ShellPage extends ConsumerWidget {
  final Widget child;

  const ShellPage({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final highContrast = ref.watch(highContrastProvider);
    final textScale = ref.watch(textScaleProvider);
    final twinState = ref.watch(twinProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 900;

    // Current location to highlight navigation
    final GoRouterState routerState = GoRouterState.of(context);
    final location = routerState.matchedLocation;

    final navItems = [
      _NavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard', route: '/dashboard'),
      _NavItem(icon: Icons.alt_route_outlined, activeIcon: Icons.alt_route, label: 'Simulator', route: '/simulator'),
      _NavItem(icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble, label: 'Coach', route: '/coach'),
      _NavItem(icon: Icons.emoji_events_outlined, activeIcon: Icons.emoji_events, label: 'Twin & Badges', route: '/profile'),
    ];

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
      child: Scaffold(
        body: Container(
          // Subtle background gradient that matches twin mood colors
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      AppColors.darkBg,
                      const Color(0xFF0F172A),
                      AppColors.darkBg,
                    ]
                  : [
                      AppColors.lightBg,
                      const Color(0xFFEFF6FF),
                      AppColors.lightBg,
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              if (isDesktop) ...[
                // Desktop Sidebar
                _buildSidebar(context, ref, navItems, location, twinState, isDark, highContrast),
                VerticalDivider(width: 1, color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
              ],
              // Main content area
              Expanded(
                child: Column(
                  children: [
                    // Top Bar
                    _buildTopBar(context, ref, isDesktop, twinState, isDark),
                    Expanded(
                      child: SafeArea(
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: !isDesktop
            ? BottomNavigationBar(
                currentIndex: navItems.indexWhere((item) => item.route == location).clamp(0, navItems.length - 1),
                onTap: (index) => context.go(navItems[index].route),
                type: BottomNavigationBarType.fixed,
                backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                items: navItems.map((item) {
                  return BottomNavigationBarItem(
                    icon: Icon(item.icon),
                    activeIcon: Icon(item.activeIcon),
                    label: item.label,
                  );
                }).toList(),
              )
            : null,
      ),
    );
  }

  Widget _buildSidebar(
    BuildContext context,
    WidgetRef ref,
    List<_NavItem> navItems,
    String currentLocation,
    TwinState twinState,
    bool isDark,
    bool highContrast,
  ) {
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
          _buildAccessibilityControls(ref, isDark, highContrast),
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

  Widget _buildAccessibilityControls(WidgetRef ref, bool isDark, bool highContrast) {
    return Column(
      children: [
        // Dark Mode Toggle
        _buildAccessibilityRow(
          icon: isDark ? Icons.dark_mode : Icons.light_mode,
          label: 'Theme Mode',
          widget: Switch(
            value: isDark,
            onChanged: (val) {
              ref.read(themeModeProvider.notifier).state = val ? ThemeMode.dark : ThemeMode.light;
            },
            activeColor: AppColors.primary,
          ),
        ),
        // High Contrast Toggle
        _buildAccessibilityRow(
          icon: Icons.remove_red_eye_outlined,
          label: 'High Contrast',
          widget: Switch(
            value: highContrast,
            onChanged: (val) {
              ref.read(highContrastProvider.notifier).state = val;
            },
            activeColor: AppColors.primary,
          ),
        ),
        // Text Size Toggle
        _buildAccessibilityRow(
          icon: Icons.text_fields,
          label: 'Text Size',
          widget: DropdownButton<double>(
            value: ref.watch(textScaleProvider),
            dropdownColor: isDark ? AppColors.darkCard : Colors.white,
            underline: const SizedBox.shrink(),
            onChanged: (val) {
              if (val != null) {
                ref.read(textScaleProvider.notifier).state = val;
              }
            },
            items: const [
              DropdownMenuItem(value: 0.85, child: Text('Small', style: TextStyle(fontSize: 12))),
              DropdownMenuItem(value: 1.0, child: Text('Normal', style: TextStyle(fontSize: 12))),
              DropdownMenuItem(value: 1.2, child: Text('Large', style: TextStyle(fontSize: 12))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccessibilityRow({required IconData icon, required String label, required Widget widget}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
          widget,
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, WidgetRef ref, bool isDesktop, TwinState twinState, bool isDark) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBg : Colors.white,
        border: Border(bottom: BorderSide(color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!isDesktop) ...[
            // Mobile logo/title
            Row(
              children: [
                const Icon(Icons.eco, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'EcoMentor AI',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                ),
              ],
            ),
          ] else ...[
            Text(
              'EcoMentor Twin Interface',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
          ],

          Row(
            children: [
              // Show Streak and XP on mobile/tablet top bar
              if (!isDesktop && twinState.hasAssessment) ...[
                Chip(
                  avatar: const Icon(Icons.local_fire_department, color: Colors.amber, size: 16),
                  label: Text('${twinState.progress.streakDays}d'),
                  backgroundColor: Colors.transparent,
                  side: BorderSide.none,
                ),
                Chip(
                  avatar: const Icon(Icons.star, color: Colors.purpleAccent, size: 16),
                  label: Text('${twinState.progress.xpPoints} XP'),
                  backgroundColor: Colors.transparent,
                  side: BorderSide.none,
                ),
                const SizedBox(width: 8),
              ],
              
              if (twinState.hasAssessment)
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogCtx) => AlertDialog(
                        title: const Text('Reset All Climate Data?'),
                        content: const Text('This will delete your Climate Twin and reset your questionnaire answers. This cannot be undone.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel')),
                          FilledButton(
                            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
                            onPressed: () {
                              ref.read(twinProvider.notifier).resetData();
                              Navigator.pop(dialogCtx);
                              context.go('/onboarding');
                            },
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.restart_alt, size: 16, color: AppColors.danger),
                  label: const Text('Reset', style: TextStyle(color: AppColors.danger, fontSize: 13)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  _NavItem({required this.icon, required this.activeIcon, required this.label, required this.route});
}
