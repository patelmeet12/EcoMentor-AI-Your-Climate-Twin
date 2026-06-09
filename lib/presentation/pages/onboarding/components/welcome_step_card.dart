import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Card view presenting the onboarding introduction.
class WelcomeStepCard extends StatelessWidget {
  final bool isDark;

  const WelcomeStepCard({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.12),
          ),
          child: const Icon(Icons.eco, size: 64, color: AppColors.primary),
        ),
        const SizedBox(height: 24),
        Text(
          'EcoMentor AI',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          'YOUR CLIMATE TWIN',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: 2.5,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Welcome to EcoMentor. Complete this lifestyle assessment to build your Climate Twin—a digital representation of your carbon footprint. Receive intelligent recommendations to track and optimize your habits!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
