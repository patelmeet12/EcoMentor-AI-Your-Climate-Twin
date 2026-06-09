import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomentor_ai/core/theme/app_theme.dart';
import 'package:ecomentor_ai/presentation/providers/twin_provider.dart';
import 'components/recommendations_list.dart';
import 'components/twin_profile_card.dart';
import 'components/carbon_breakdown_card.dart';
import 'components/forecast_card.dart';

/// Renders the primary user metrics, carbon breakdown charts, forecast outlooks,
/// and checkable personalized recommendations checklist.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final twinState = ref.watch(twinProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (twinState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (!twinState.hasAssessment) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/onboarding');
      });
      return const SizedBox.shrink();
    }

    final twin = twinState.twin;
    final progress = twinState.progress;
    final recommendations = twinState.recommendations;

    final double width = MediaQuery.of(context).size.width;
    final bool isTwoColumn = width >= 1000;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark),
            const SizedBox(height: 24),
            if (isTwoColumn)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 11,
                    child: Column(
                      children: [
                        TwinProfileCard(twin: twin, isDark: isDark),
                        const SizedBox(height: 24),
                        CarbonBreakdownCard(twin: twin, isDark: isDark),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 13,
                    child: Column(
                      children: [
                        RecommendationsList(recommendations: recommendations, isDark: isDark),
                        const SizedBox(height: 24),
                        ForecastCard(twin: twin, progress: progress, isDark: isDark),
                      ],
                    ),
                  ),
                ],
              )
            else ...[
              TwinProfileCard(twin: twin, isDark: isDark),
              const SizedBox(height: 24),
              CarbonBreakdownCard(twin: twin, isDark: isDark),
              const SizedBox(height: 24),
              RecommendationsList(recommendations: recommendations, isDark: isDark),
              const SizedBox(height: 24),
              ForecastCard(twin: twin, progress: progress, isDark: isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Climate Twin Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Track completed actions and optimize your carbon habits.',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
