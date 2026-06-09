import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// A custom text input and action row component for submitting queries to the Coach.
class CoachInputRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const CoachInputRow({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Semantics(
            textField: true,
            label: 'Enter a custom question to the coach',
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Type your climate questions here...',
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Semantics(
          button: true,
          label: 'Send message',
          child: Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onSend,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(14.0),
                child: Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
