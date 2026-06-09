import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../providers/coach_provider.dart';

/// Component representing a single chat bubble in the Coach conversation history.
class CoachBubble extends StatelessWidget {
  final CoachMessage message;
  final bool isDark;

  const CoachBubble({super.key, required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final alignment = message.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = message.isUser
        ? AppColors.primary
        : (isDark ? AppColors.darkBg : Colors.grey.withOpacity(0.1));
    final textColor = message.isUser ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);

    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: message.isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: message.isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Text(
          message.text.replaceAll('**', ''),
          style: TextStyle(
            color: textColor,
            fontSize: 13.5,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}
