import 'package:flutter/material.dart';

/// Renders a standard header title and description block inside questionnaire cards.
class StepTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const StepTitle({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }
}
