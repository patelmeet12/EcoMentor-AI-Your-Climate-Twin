import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'step_title.dart';

/// Card view mapping user energy variables.
class EnergyStepCard extends StatelessWidget {
  final double monthlyElectricity;
  final double acUsage;
  final double renewablePct;
  final ValueChanged<double> onMonthlyElectricityChanged;
  final ValueChanged<double> onAcUsageChanged;
  final ValueChanged<double?> onRenewablePctChanged;
  final bool isDark;

  const EnergyStepCard({
    super.key,
    required this.monthlyElectricity,
    required this.acUsage,
    required this.renewablePct,
    required this.onMonthlyElectricityChanged,
    required this.onAcUsageChanged,
    required this.onRenewablePctChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepTitle(
            title: 'Home Energy details',
            subtitle: 'Help us evaluate your home electricity usage and cooling devices.',
          ),
          const SizedBox(height: 16),

          Text('Monthly Electricity Usage: ${monthlyElectricity.round()} kWh', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Slider(
            min: 0,
            max: 800,
            divisions: 80,
            value: monthlyElectricity,
            activeColor: AppColors.primary,
            onChanged: onMonthlyElectricityChanged,
          ),
          const SizedBox(height: 16),

          Text('AC usage per day: ${acUsage.round()} hours', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Slider(
            min: 0,
            max: 24,
            divisions: 24,
            value: acUsage,
            activeColor: AppColors.primary,
            onChanged: onAcUsageChanged,
          ),
          const SizedBox(height: 16),

          const Text('Renewable Energy Sourcing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 6),
          DropdownButtonFormField<double>(
            value: renewablePct,
            dropdownColor: isDark ? AppColors.darkCard : Colors.white,
            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16)),
            items: const [
              DropdownMenuItem(value: 0.0, child: Text('No Solar / Standard Grid (0%)')),
              DropdownMenuItem(value: 0.25, child: Text('Quarterly Solar offset (25%)')),
              DropdownMenuItem(value: 0.50, child: Text('Partial clean energy (50%)')),
              DropdownMenuItem(value: 0.75, child: Text('Strong Solar sourcing (75%)')),
              DropdownMenuItem(value: 1.0, child: Text('Full Net-Zero Clean Sourcing (100%)')),
            ],
            onChanged: onRenewablePctChanged,
          ),
        ],
      ),
    );
  }
}
