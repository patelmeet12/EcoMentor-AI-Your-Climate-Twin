import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/recommendation.dart';
import '../../../widgets/glass_card.dart';
import '../../../providers/simulation_provider.dart';

/// Card component that wraps the list of active optimization switches.
class SimulatorControlsCard extends StatelessWidget {
  final List<Recommendation> activeRecommendations;
  final SimulationState simState;
  final WidgetRef ref;
  final bool isDark;

  const SimulatorControlsCard({
    super.key,
    required this.activeRecommendations,
    required this.simState,
    required this.ref,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
          if (activeRecommendations.isEmpty)
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
              itemCount: activeRecommendations.length,
              itemBuilder: (context, index) {
                final Recommendation rec = activeRecommendations[index];
                final bool isToggled = simState.toggledActions[rec.id] ?? false;

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
}
