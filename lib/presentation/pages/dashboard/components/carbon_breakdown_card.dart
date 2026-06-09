import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/climate_twin.dart';
import '../../../widgets/glass_card.dart';

/// Card component displaying a PieChart representation of emission categories.
class CarbonBreakdownCard extends StatelessWidget {
  final ClimateTwin twin;
  final bool isDark;

  const CarbonBreakdownCard({super.key, required this.twin, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final double total = twin.annualEmissions > 0 ? twin.annualEmissions : 1.0;
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 550;

    final List<Map<String, dynamic>> categories = [
      {'name': 'Transport', 'val': twin.transportEmissions, 'color': const Color(0xFF3B82F6)},
      {'name': 'Energy', 'val': twin.energyEmissions, 'color': const Color(0xFFF59E0B)},
      {'name': 'Food', 'val': twin.foodEmissions, 'color': const Color(0xFF10B981)},
      {'name': 'Shopping', 'val': twin.shoppingEmissions, 'color': const Color(0xFF8B5CF6)},
      {'name': 'Waste', 'val': twin.wasteEmissions, 'color': const Color(0xFFEC4899)},
    ];

    // Remove zero emission categories to keep chart clean
    final List<Map<String, dynamic>> activeCategories = categories.where((c) => (c['val'] as double) > 0).toList();

    final Widget pieChartWidget = SizedBox(
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
                  final double val = c['val'] as double;
                  final double pct = (val / total * 100);
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
    );

    final Widget legendWidget = Column(
      children: categories.map((c) {
        final double val = c['val'] as double;
        final String pct = (val / total * 100).toStringAsFixed(0);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: c['color'] as Color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  c['name'] as String,
                  style: const TextStyle(fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${val.toStringAsFixed(0)} kg ($pct%)',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );

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
          if (isMobile) ...[
            Center(child: pieChartWidget),
            const SizedBox(height: 24),
            legendWidget,
          ] else
            Row(
              children: [
                pieChartWidget,
                const SizedBox(width: 32),
                Expanded(child: legendWidget),
              ],
            ),
        ],
      ),
    );
  }
}
