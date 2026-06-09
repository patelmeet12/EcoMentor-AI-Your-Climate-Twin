import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/score_gauge.dart';
import '../../widgets/twin_avatar.dart';
import '../../providers/twin_provider.dart';
import '../../../domain/entities/climate_twin.dart';
import '../../../domain/entities/recommendation.dart';
import '../../../domain/entities/user_progress.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final twinState = ref.watch(twinProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (twinState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (!twinState.hasAssessment) {
      // Security fallback if routing fails
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/onboarding');
      });
      return const SizedBox.shrink();
    }

    final twin = twinState.twin;
    final progress = twinState.progress;
    final recommendations = twinState.recommendations;

    final width = MediaQuery.of(context).size.width;
    final isTwoColumn = width >= 1000;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            _buildHeader(twinState, isDark),
            const SizedBox(height: 24),

            // Responsive Layout
            if (isTwoColumn)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: Twin Profile & Charts
                  Expanded(
                    flex: 11,
                    child: Column(
                      children: [
                        _buildTwinCard(context, twin, isDark),
                        const SizedBox(height: 24),
                        _buildBreakdownChart(context, twin, isDark),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Right Column: Recommendations & Forecast
                  Expanded(
                    flex: 13,
                    child: Column(
                      children: [
                        _buildRecommendationsList(ref, recommendations, isDark),
                        const SizedBox(height: 24),
                        _buildForecastCard(context, twin, progress, isDark),
                      ],
                    ),
                  ),
                ],
              )
            else ...[
              // Single column vertical list for mobile/tablet
              _buildTwinCard(context, twin, isDark),
              const SizedBox(height: 24),
              _buildBreakdownChart(context, twin, isDark),
              const SizedBox(height: 24),
              _buildRecommendationsList(ref, recommendations, isDark),
              const SizedBox(height: 24),
              _buildForecastCard(context, twin, progress, isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(TwinState state, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
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
        ),
      ],
    );
  }

  Widget _buildTwinCard(BuildContext context, ClimateTwin twin, bool isDark) {
    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TwinAvatar(score: twin.score, personality: twin.personality, size: 140),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    twin.personality.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Twin Sustainability Grade: ${twin.grade}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  twin.insights.isNotEmpty
                      ? twin.insights.first
                      : 'Transportation constitutes a major portion of your footprints. Complete recommendations to improve your grade.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ScoreGauge(score: twin.score, grade: twin.grade, size: 110),
        ],
      ),
    );
  }

  Widget _buildBreakdownChart(BuildContext context, ClimateTwin twin, bool isDark) {
    final double total = twin.annualEmissions > 0 ? twin.annualEmissions : 1.0;

    final categories = [
      {'name': 'Transport', 'val': twin.transportEmissions, 'color': const Color(0xFF3B82F6)},
      {'name': 'Energy', 'val': twin.energyEmissions, 'color': const Color(0xFFF59E0B)},
      {'name': 'Food', 'val': twin.foodEmissions, 'color': const Color(0xFF10B981)},
      {'name': 'Shopping', 'val': twin.shoppingEmissions, 'color': const Color(0xFF8B5CF6)},
      {'name': 'Waste', 'val': twin.wasteEmissions, 'color': const Color(0xFFEC4899)},
    ];

    // Remove zero emission categories to keep chart clean
    final activeCategories = categories.where((c) => (c['val'] as double) > 0).toList();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Carbon Footprint Breakdown',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Annual emissions totaling ${twin.annualEmissions.toStringAsFixed(0)} kg CO₂.',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              // Pie Chart
              SizedBox(
                width: 140,
                height: 140,
                child: activeCategories.isEmpty
                    ? Container(
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                        child: const Center(child: Icon(Icons.check, color: Colors.white)),
                      )
                    : PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 32,
                          sections: activeCategories.map((c) {
                            final val = c['val'] as double;
                            final pct = (val / total * 100);
                            return PieChartSectionData(
                              value: val,
                              title: pct >= 8 ? '${pct.toStringAsFixed(0)}%' : '',
                              color: c['color'] as Color,
                              radius: 38,
                              titleStyle: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
              ),
              const SizedBox(width: 32),
              // Legend list
              Expanded(
                child: Column(
                  children: categories.map((c) {
                    final val = c['val'] as double;
                    final pct = (val / total * 100).toStringAsFixed(0);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(width: 12, height: 12, decoration: BoxDecoration(color: c['color'] as Color, shape: BoxShape.circle)),
                              const SizedBox(width: 8),
                              Text(c['name'] as String, style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                          Text(
                            '${val.toStringAsFixed(0)} kg ($pct%)',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsList(WidgetRef ref, List<Recommendation> recommendations, bool isDark) {
    final pending = recommendations.where((r) => !r.isCompleted).toList();
    final completed = recommendations.where((r) => r.isCompleted).toList();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personalized Actions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Select recommendations to check them off.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Chip(
                backgroundColor: AppColors.primary.withOpacity(0.12),
                label: Text('${completed.length}/${recommendations.length} Done', style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                side: BorderSide.none,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (pending.isEmpty && completed.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('No recommendations generated yet.', style: TextStyle(color: Colors.grey))),
            )
          else ...[
            // Active recommendations
            ...pending.map((r) => _buildRecommendationRow(ref, r, false, isDark)),
            if (completed.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Text('COMPLETED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
              ),
              ...completed.map((r) => _buildRecommendationRow(ref, r, true, isDark)),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildRecommendationRow(WidgetRef ref, Recommendation rec, bool isCompleted, bool isDark) {
    Color diffColor;
    if (rec.difficulty.toLowerCase() == 'low') {
      diffColor = AppColors.success;
    } else if (rec.difficulty.toLowerCase() == 'medium') {
      diffColor = AppColors.warning;
    } else {
      diffColor = AppColors.danger;
    }

    return Card(
      color: isDark ? AppColors.darkBg.withOpacity(0.4) : Colors.grey.withOpacity(0.04),
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isCompleted
              ? AppColors.primary.withOpacity(0.2)
              : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
        ),
      ),
      child: CheckboxListTile(
        value: isCompleted,
        activeColor: AppColors.primary,
        onChanged: (val) {
          ref.read(twinProvider.notifier).toggleRecommendation(rec.id);
        },
        title: Text(
          rec.title,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? Colors.grey : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(rec.description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _buildBadgeMini('Offset: -${rec.impactKg.toStringAsFixed(0)} kg CO₂', AppColors.primary.withOpacity(0.12), AppColors.primary),
                _buildBadgeMini('Savings: ₹${rec.savingsInr.toStringAsFixed(0)}/yr', Colors.blue.withOpacity(0.12), Colors.blue),
                _buildBadgeMini(rec.difficulty, diffColor.withOpacity(0.12), diffColor),
                if (!isCompleted)
                  _buildBadgeMini('XP: +100', Colors.purple.withOpacity(0.12), Colors.purpleAccent),
              ],
            ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget _buildBadgeMini(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: text)),
    );
  }

  Widget _buildForecastCard(BuildContext context, ClimateTwin twin, UserProgress progress, bool isDark) {
    // Forecast predictions
    // If no action is completed, forecast is same as current emissions.
    // If some actions are completed, they reduce the footprint over time.
    // Let's assume completed actions reduce current footprint by their active offsets.
    double totalActiveOffsets = 0;
    // Calculate total completed actions impact
    // We already accounted for them in progress.totalCarbonReduced!
    // Forecast represents projected carbon savings and scores based on current rate.
    final currentScore = twin.score;
    
    // Future projections:
    // next 30 days emissions = (twin.annualEmissions - progress.totalCarbonReduced) / 12
    // next 6 months emissions = (twin.annualEmissions - progress.totalCarbonReduced) / 2
    // next year emissions = (twin.annualEmissions - progress.totalCarbonReduced)
    // If they continue completing actions, their score improves.
    
    final double nextYearEmissions = (twin.annualEmissions - progress.totalCarbonReduced).clamp(1500.0, 20000.0);
    final nextYearScore = twin.score; // simplified projection for dashboard card
    final nextYearGrade = twin.grade;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Carbon Forecast & Outlook',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Projections based on your active lifestyle and completed tasks.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildForecastTimelineCol('Next 30 Days', '${(twin.monthlyEmissions).toStringAsFixed(0)} kg', 'Score: $currentScore'),
              _buildForecastTimelineCol('Next 6 Months', '${(twin.monthlyEmissions * 6).toStringAsFixed(0)} kg', 'Score: $currentScore'),
              _buildForecastTimelineCol('Next 1 Year', '${(twin.annualEmissions).toStringAsFixed(0)} kg', 'Grade: $nextYearGrade'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForecastTimelineCol(String duration, String projectedEmissions, String metric) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Text(duration, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(projectedEmissions, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 4),
            Text(metric, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
