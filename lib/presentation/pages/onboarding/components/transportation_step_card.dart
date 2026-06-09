import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'step_title.dart';

/// Card view mapping user transportation variables.
class TransportationStepCard extends StatelessWidget {
  final String vehicleType;
  final double weeklyDistance;
  final double publicTransport;
  final int flightsPerYear;
  final ValueChanged<String?> onVehicleTypeChanged;
  final ValueChanged<double> onWeeklyDistanceChanged;
  final ValueChanged<double> onPublicTransportChanged;
  final ValueChanged<double> onFlightsPerYearChanged;
  final bool isDark;

  const TransportationStepCard({
    super.key,
    required this.vehicleType,
    required this.weeklyDistance,
    required this.publicTransport,
    required this.flightsPerYear,
    required this.onVehicleTypeChanged,
    required this.onWeeklyDistanceChanged,
    required this.onPublicTransportChanged,
    required this.onFlightsPerYearChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepTitle(
            title: 'Transportation habits',
            subtitle: 'How do you commute and travel throughout the year?',
          ),
          const SizedBox(height: 16),

          const Text('Primary Commute Vehicle', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: vehicleType,
            dropdownColor: isDark ? AppColors.darkCard : Colors.white,
            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16)),
            items: const [
              DropdownMenuItem(value: 'None', child: Text('None')),
              DropdownMenuItem(value: 'Gasoline Car', child: Text('Gasoline Car')),
              DropdownMenuItem(value: 'Diesel Car', child: Text('Diesel Car')),
              DropdownMenuItem(value: 'Hybrid Car', child: Text('Hybrid Car')),
              DropdownMenuItem(value: 'Electric Car', child: Text('Electric Car')),
              DropdownMenuItem(value: 'Motorcycle', child: Text('Motorcycle')),
            ],
            onChanged: onVehicleTypeChanged,
          ),
          const SizedBox(height: 16),

          if (vehicleType != 'None') ...[
            Text('Weekly Commute Distance: ${weeklyDistance.round()} km', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Slider(
              min: 0,
              max: 600,
              divisions: 60,
              value: weeklyDistance,
              activeColor: AppColors.primary,
              onChanged: onWeeklyDistanceChanged,
            ),
            const SizedBox(height: 12),
          ],

          Text('Weekly Public Transit usage: ${publicTransport.round()} hours', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Slider(
            min: 0,
            max: 40,
            divisions: 40,
            value: publicTransport,
            activeColor: AppColors.primary,
            onChanged: onPublicTransportChanged,
          ),
          const SizedBox(height: 12),

          Text('Flights per year: $flightsPerYear flights', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Slider(
            min: 0,
            max: 20,
            divisions: 20,
            value: flightsPerYear.toDouble(),
            activeColor: AppColors.primary,
            onChanged: onFlightsPerYearChanged,
          ),
        ],
      ),
    );
  }
}
