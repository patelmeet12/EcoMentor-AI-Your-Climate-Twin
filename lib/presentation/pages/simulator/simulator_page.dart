import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecomentor_ai/core/theme/app_theme.dart';
import 'package:ecomentor_ai/presentation/providers/twin_provider.dart';
import 'package:ecomentor_ai/presentation/providers/simulation_provider.dart';
import 'package:ecomentor_ai/domain/entities/recommendation.dart';
import 'components/simulator_controls_card.dart';
import 'components/simulator_results_card.dart';

/// Playground screen that displays active carbon checklist switches
/// and models forecasted before/after carbon twin statistics.
class SimulatorPage extends ConsumerWidget {
  const SimulatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final twinState = ref.watch(twinProvider);
    final simState = ref.watch(simulationProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (twinState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final twin = twinState.twin;
    final recommendations = twinState.recommendations;
    final List<Recommendation> activeRecommendations = recommendations.where((r) => !r.isCompleted).toList();

    final double width = MediaQuery.of(context).size.width;
    final bool isTwoColumn = width >= 900;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Future Impact Simulator',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Toggle recommendations to simulate a green transition and forecast savings.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 24),
            if (isTwoColumn)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 11,
                    child: SimulatorControlsCard(
                      activeRecommendations: activeRecommendations,
                      simState: simState,
                      ref: ref,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 13,
                    child: SimulatorResultsCard(
                      originalEmissions: twin.annualEmissions,
                      originalScore: twin.score,
                      originalGrade: twin.grade,
                      originalPersonality: twin.personality,
                      sim: simState,
                      isDark: isDark,
                    ),
                  ),
                ],
              )
            else ...[
              SimulatorControlsCard(
                activeRecommendations: activeRecommendations,
                simState: simState,
                ref: ref,
                isDark: isDark,
              ),
              const SizedBox(height: 24),
              SimulatorResultsCard(
                originalEmissions: twin.annualEmissions,
                originalScore: twin.score,
                originalGrade: twin.grade,
                originalPersonality: twin.personality,
                sim: simState,
                isDark: isDark,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
