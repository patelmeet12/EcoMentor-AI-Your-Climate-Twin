import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/recommendation.dart';
import '../../../widgets/glass_card.dart';
import '../../../providers/twin_provider.dart';

/// Card component that wraps the list of active/completed sustainability recommendations checklist.
class RecommendationsList extends ConsumerWidget {
  final List<Recommendation> recommendations;
  final bool isDark;

  const RecommendationsList({
    super.key,
    required this.recommendations,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Recommendation> pending = recommendations.where((r) => !r.isCompleted).toList();
    final List<Recommendation> completed = recommendations.where((r) => r.isCompleted).toList();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Personalized Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text('Select recommendations to check them off.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Chip(
                backgroundColor: AppColors.primary.withOpacity(0.12),
                label: Text(
                  '${completed.length}/${recommendations.length} Done',
                  style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                ),
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
            ...pending.map((r) => _buildRecommendationRow(ref, r, false, isDark)),
            if (completed.isNotEmpty) ...[
              const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Divider()),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Text(
                  'COMPLETED',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
                ),
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
}
