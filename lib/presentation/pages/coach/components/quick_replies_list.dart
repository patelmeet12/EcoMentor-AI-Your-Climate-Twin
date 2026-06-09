import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../providers/coach_provider.dart';

/// Horizontal list component housing quick-response suggestion chips.
class QuickRepliesList extends StatelessWidget {
  final List<String> replies;
  final WidgetRef ref;
  final bool isDark;
  final VoidCallback onSelect;

  const QuickRepliesList({
    super.key,
    required this.replies,
    required this.ref,
    required this.isDark,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: replies.length,
        itemBuilder: (context, index) {
          final String replyText = replies[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Semantics(
              button: true,
              label: 'Quick response: $replyText',
              child: ActionChip(
                backgroundColor: isDark ? AppColors.darkBg : Colors.white,
                side: BorderSide(color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                label: Text(replyText, style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                onPressed: () {
                  ref.read(coachProvider.notifier).sendMessage(replyText);
                  onSelect();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
