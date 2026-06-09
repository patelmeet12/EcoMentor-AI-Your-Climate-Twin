import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/twin_avatar.dart';
import '../../providers/twin_provider.dart';
import '../../providers/simulation_provider.dart';
import '../../../domain/entities/recommendation.dart';

class SimulatorPage extends ConsumerWidget {
  const SimulatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final twinState = ref.watch(twinProvider);
    final simState = ref.watch(simulationProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (twinState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final twin = twinState.twin;
    final recommendations = twinState.recommendations;
    final activeRecommendations = recommendations.where((r) => !r.isCompleted).toList();

    final width = MediaQuery.of(context).size.width;
    final isTwoColumn = width >= 900;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title block
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
                  // Left: Simulation toggles
                  Expanded(
                    flex: 11,
                    child: _buildSimulationControls(ref, activeRecommendations, simState, isDark),
                  ),
                  const SizedBox(width: 24),
                  // Right: Comparison dashboard
                  Expanded(
                    flex: 13,
                    child: _buildSimulationResults(context, twin.annualEmissions, twin.score, twin.grade, twin.personality, simState, isDark),
                  ),
                ],
              )
            else ...[
              // Vertical stack
              _buildSimulationControls(ref, activeRecommendations, simState, isDark),
              const SizedBox(height: 24),
              _buildSimulationResults(context, twin.annualEmissions, twin.score, twin.grade, twin.personality, simState, isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSimulationControls(
    WidgetRef ref,
    List<Recommendation> activeRecs,
    SimulationState simState,
    bool isDark,
  ) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lifestyle Optimizations',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Toggle green practices to preview their collective impact.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          if (activeRecs.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Text(
                  'No active recommendations to simulate. You have completed all carbon-reduction tasks!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activeRecs.length,
              itemBuilder: (context, index) {
                final rec = activeRecs[index];
                final isToggled = simState.toggledActions[rec.id] ?? false;

                return Card(
                  color: isDark ? AppColors.darkBg.withOpacity(0.4) : Colors.grey.withOpacity(0.04),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isToggled
                          ? AppColors.primary
                          : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                      width: isToggled ? 2.0 : 1.0,
                    ),
                  ),
                  child: SwitchListTile(
                    value: isToggled,
                    onChanged: (val) {
                      ref.read(simulationProvider.notifier).toggleAction(rec.id);
                    },
                    activeColor: AppColors.primary,
                    title: Text(
                      rec.title,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isToggled ? AppColors.primary : null),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(rec.description, style: const TextStyle(fontSize: 11.5, color: Colors.grey)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text('-${rec.impactKg.toStringAsFixed(0)} kg CO₂', style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 12),
                            Text('₹${rec.savingsInr.toStringAsFixed(0)}/yr savings', style: const TextStyle(fontSize: 10, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSimulationResults(
    BuildContext context,
    double originalEmissions,
    int originalScore,
    String originalGrade,
    String originalPersonality,
    SimulationState sim,
    bool isDark,
  ) {
    return Column(
      children: [
        // Side by Side comparison cards
        Row(
          children: [
            // Current State
            Expanded(
              child: GlassCard(
                opacity: 0.4,
                enableHover: false,
                child: Column(
                  children: [
                    const Text('CURRENT TWIN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                    const SizedBox(height: 12),
                    TwinAvatar(score: originalScore, personality: originalPersonality, size: 90),
                    const SizedBox(height: 16),
                    Text(originalGrade, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    Text('Score: $originalScore', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text(
                      '${originalEmissions.toStringAsFixed(0)} kg CO₂/yr',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Simulated State
            Expanded(
              child: GlassCard(
                opacity: 0.8,
                enableHover: false,
                child: Column(
                  children: [
                    const Text('SIMULATED TWIN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1)),
                    const SizedBox(height: 12),
                    TwinAvatar(score: sim.simulatedScore, personality: originalPersonality, size: 90),
                    const SizedBox(height: 16),
                    Text(
                      sim.simulatedGrade,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    Text('Score: ${sim.simulatedScore}', style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                    const SizedBox(height: 8),
                    Text(
                      '${sim.simulatedEmissions.toStringAsFixed(0)} kg CO₂/yr',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Forecast summary metrics
        GlassCard(
          enableHover: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Forecasted Optimization Metrics', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildForecastMetricsRow('Total Carbon Reduced', '-${sim.totalReducedKg.toStringAsFixed(0)} kg CO₂ / year', AppColors.primary),
              const Divider(),
              _buildForecastMetricsRow('Score Growth', '+${(sim.simulatedScore - originalScore).clamp(0, 100)} Points', Colors.purpleAccent),
              const Divider(),
              _buildForecastMetricsRow('Estimated Cash Saved', '₹${sim.totalSavingsInr.toStringAsFixed(0)} / year', Colors.blue),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForecastMetricsRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
