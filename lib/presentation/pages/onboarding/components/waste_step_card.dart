import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'step_title.dart';

/// Card view mapping user waste variables.
class WasteStepCard extends StatelessWidget {
  final String recyclingHabits;
  final String plasticConsumption;
  final bool composting;
  final ValueChanged<String?> onRecyclingHabitsChanged;
  final ValueChanged<String?> onPlasticConsumptionChanged;
  final ValueChanged<bool?> onCompostingChanged;
  final bool isDark;

  const WasteStepCard({
    super.key,
    required this.recyclingHabits,
    required this.plasticConsumption,
    required this.composting,
    required this.onRecyclingHabitsChanged,
    required this.onPlasticConsumptionChanged,
    required this.onCompostingChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepTitle(
            title: 'Waste & Circularity',
            subtitle: 'Detail your household recycling, plastic consumption, and organic waste habits.',
          ),
          const SizedBox(height: 16),

          const Text('Recycling habits', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: recyclingHabits,
            dropdownColor: isDark ? AppColors.darkCard : Colors.white,
            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16)),
            items: const [
              DropdownMenuItem(value: 'Regularly', child: Text('Regularly')),
              DropdownMenuItem(value: 'Occasionally', child: Text('Occasionally')),
              DropdownMenuItem(value: 'Never', child: Text('Never')),
            ],
            onChanged: onRecyclingHabitsChanged,
          ),
          const SizedBox(height: 16),

          const Text('Plastic Packaging Usage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: plasticConsumption,
            dropdownColor: isDark ? AppColors.darkCard : Colors.white,
            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16)),
            items: const [
              DropdownMenuItem(value: 'Low', child: Text('Low Consumption')),
              DropdownMenuItem(value: 'Medium', child: Text('Medium Consumption')),
              DropdownMenuItem(value: 'High', child: Text('High Consumption')),
            ],
            onChanged: onPlasticConsumptionChanged,
          ),
          const SizedBox(height: 24),

          // Composting switch
          CheckboxListTile(
            value: composting,
            activeColor: AppColors.primary,
            title: const Text('Organic Composting at Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: const Text('We compost vegetable peels, waste food, and coffee grounds at home.', style: TextStyle(fontSize: 12, color: Colors.grey)),
            onChanged: onCompostingChanged,
            controlAffinity: ListTileControlAffinity.trailing,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
