import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'step_title.dart';

/// Card view mapping user food variables.
class FoodStepCard extends StatelessWidget {
  final String dietType;
  final ValueChanged<String> onDietTypeChanged;
  final bool isDark;

  const FoodStepCard({
    super.key,
    required this.dietType,
    required this.onDietTypeChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dietOptions = [
      {'title': 'Vegan', 'desc': '100% plant-based diet. Excludes dairy, meat, and eggs.', 'icon': Icons.nature_people},
      {'title': 'Vegetarian', 'desc': 'Excludes meat/poultry, but consumes dairy and eggs.', 'icon': Icons.grass},
      {'title': 'Mixed Diet', 'desc': 'Standard meals. Consumes meat, dairy, and vegetables.', 'icon': Icons.restaurant_menu},
      {'title': 'High Meat Consumption', 'desc': 'Meat forms the main source of most daily meals.', 'icon': Icons.kebab_dining},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepTitle(
          title: 'Diet choices',
          subtitle: 'Select the option that best reflects your regular diet.',
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: dietOptions.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> opt = dietOptions[index];
              final String title = opt['title'] as String;
              final bool isSelected = dietType == title ||
                  (dietType == 'Mixed' && title == 'Mixed Diet') ||
                  (dietType == 'High Meat' && title == 'High Meat Consumption');

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Semantics(
                  button: true,
                  selected: isSelected,
                  child: InkWell(
                    onTap: () {
                      if (title == 'Mixed Diet') {
                        onDietTypeChanged('Mixed');
                      } else if (title == 'High Meat Consumption') {
                        onDietTypeChanged('High Meat');
                      } else {
                        onDietTypeChanged(title);
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                          width: isSelected ? 2 : 1,
                        ),
                        color: isSelected ? AppColors.primary.withOpacity(0.08) : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Icon(opt['icon'] as IconData, color: isSelected ? AppColors.primary : Colors.grey, size: 24),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isSelected ? AppColors.primary : null),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  opt['desc'] as String,
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
