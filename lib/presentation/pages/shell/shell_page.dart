import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/theme_provider.dart';
import '../../providers/twin_provider.dart';
import 'components/desktop_sidebar.dart';
import 'components/nav_item.dart';
import 'components/shell_top_bar.dart';

/// Navigation layout wrapper containing the responsive layout sidebars, topbar, and bottom bar.
class ShellPage extends ConsumerWidget {
  final Widget child;

  const ShellPage({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      const NavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard', route: '/dashboard'),
      const NavItem(icon: Icons.alt_route_outlined, activeIcon: Icons.alt_route, label: 'Simulator', route: '/simulator'),
      const NavItem(icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble, label: 'Coach', route: '/coach'),
      const NavItem(icon: Icons.emoji_events_outlined, activeIcon: Icons.emoji_events, label: 'Twin & Badges', route: '/profile'),
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
                DesktopSidebar(
                  navItems: navItems,
                  currentLocation: location,
                  twinState: twinState,
                  isDark: isDark,
                  highContrast: highContrast,
                ),
                VerticalDivider(width: 1, color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
              ],
              // Main content area
              Expanded(
                child: Column(
                  children: [
                    // Top Bar
                    ShellTopBar(isDesktop: isDesktop, isDark: isDark),
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
}

