import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../providers/simulation_provider.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/twin_avatar.dart';

/// Card component that presents side-by-side comparative avatars and projected calculations.
class SimulatorResultsCard extends StatelessWidget {
  final double originalEmissions;
  final int originalScore;
  final String originalGrade;
  final String originalPersonality;
  final SimulationState sim;
  final bool isDark;

  const SimulatorResultsCard({
    super.key,
    required this.originalEmissions,
    required this.originalScore,
    required this.originalGrade,
    required this.originalPersonality,
    required this.sim,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
