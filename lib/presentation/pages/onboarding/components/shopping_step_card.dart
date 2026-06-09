import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'step_title.dart';

/// Card view mapping user shopping variables.
class ShoppingStepCard extends StatelessWidget {
  final String shoppingFrequency;
  final String electronicsPurchase;
  final ValueChanged<String?> onShoppingFrequencyChanged;
  final ValueChanged<String?> onElectronicsPurchaseChanged;
  final bool isDark;

  const ShoppingStepCard({
    super.key,
    required this.shoppingFrequency,
    required this.electronicsPurchase,
    required this.onShoppingFrequencyChanged,
    required this.onElectronicsPurchaseChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepTitle(
          title: 'Consumer behavior',
          subtitle: 'Tell us about your shopping frequencies and electronics hardware purchases.',
        ),
        const SizedBox(height: 24),

        const Text('General Shopping Frequency (Clothes, goods, etc.)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: shoppingFrequency,
          dropdownColor: isDark ? AppColors.darkCard : Colors.white,
          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16)),
          items: const [
            DropdownMenuItem(value: 'Low', child: Text('Low Frequency')),
            DropdownMenuItem(value: 'Medium', child: Text('Medium Frequency')),
            DropdownMenuItem(value: 'High', child: Text('High Frequency')),
          ],
          onChanged: onShoppingFrequencyChanged,
        ),
        const SizedBox(height: 24),

        const Text('Electronics Hardware Purchases', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: electronicsPurchase,
          dropdownColor: isDark ? AppColors.darkCard : Colors.white,
          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16)),
          items: const [
            DropdownMenuItem(value: 'Rarely', child: Text('Rarely')),
            DropdownMenuItem(value: 'Occasionally', child: Text('Occasionally')),
            DropdownMenuItem(value: 'Frequently', child: Text('Frequently')),
          ],
          onChanged: onElectronicsPurchaseChanged,
        ),
      ],
    );
  }
}
