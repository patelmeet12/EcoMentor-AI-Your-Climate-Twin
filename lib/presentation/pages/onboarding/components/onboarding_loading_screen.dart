import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Loading and carbon DNA calculation screen displayed during onboarding submission.
class OnboardingLoadingScreen extends StatelessWidget {
  const OnboardingLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.darkBg, const Color(0xFF0F172A)]
                : [AppColors.lightBg, const Color(0xFFEFF6FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Analyzing Carbon DNA...',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Formulating your unique digital Climate Twin',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
