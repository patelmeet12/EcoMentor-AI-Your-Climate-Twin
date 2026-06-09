import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../providers/twin_provider.dart';

/// Top bar component for both desktop view titles and mobile view credentials.
class ShellTopBar extends ConsumerWidget {
  final bool isDesktop;
  final bool isDark;

  const ShellTopBar({
    super.key,
    required this.isDesktop,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final twinState = ref.watch(twinProvider);

    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24 : 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBg : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            width: 1,
          ),
        ),
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
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
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${twinState.progress.streakDays}d',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.purpleAccent, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${twinState.progress.xpPoints} XP',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
              ],

              if (twinState.hasAssessment)
                isDesktop
                    ? TextButton.icon(
                        onPressed: () => _showResetDialog(context, ref),
                        icon: const Icon(Icons.restart_alt, size: 16, color: AppColors.danger),
                        label: const Text('Reset', style: TextStyle(color: AppColors.danger, fontSize: 13)),
                      )
                    : IconButton(
                        onPressed: () => _showResetDialog(context, ref),
                        icon: const Icon(Icons.restart_alt, color: AppColors.danger),
                        tooltip: 'Reset Data',
                      ),
            ],
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
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
  }
}
