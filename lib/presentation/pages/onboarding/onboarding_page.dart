import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomentor_ai/core/theme/app_theme.dart';
import 'package:ecomentor_ai/presentation/providers/twin_provider.dart';
import 'package:ecomentor_ai/domain/entities/assessment.dart';
import 'components/onboarding_loading_screen.dart';
import 'components/welcome_step_card.dart';
import 'components/transportation_step_card.dart';
import 'components/energy_step_card.dart';
import 'components/food_step_card.dart';
import 'components/shopping_step_card.dart';
import 'components/waste_step_card.dart';

/// Parent onboarding wizard page. Guides users through the lifestyle questionnaire.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isCalculating = false;

  // Temp form fields
  String _vehicleType = 'None';
  double _weeklyDistance = 50.0;
  double _publicTransport = 2.0;
  int _flightsPerYear = 1;

  double _monthlyElectricity = 150.0;
  double _acUsage = 2.0;
  double _renewablePct = 0.0;

  String _dietType = 'Mixed';

  String _shoppingFrequency = 'Medium';
  String _electronicsPurchase = 'Occasionally';

  String _recyclingHabits = 'Occasionally';
  String _plasticConsumption = 'Medium';
  bool _composting = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 5) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _calculateAndSaveTwin();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _calculateAndSaveTwin() async {
    setState(() => _isCalculating = true);
    await Future.delayed(const Duration(seconds: 2));

    final Assessment assessment = Assessment(
      vehicleType: _vehicleType,
      fuelType: _vehicleType == 'None' ? 'None' : 'Gasoline',
      weeklyDistance: _weeklyDistance,
      publicTransportUsage: _publicTransport,
      flightsPerYear: _flightsPerYear,
      monthlyElectricity: _monthlyElectricity,
      acUsage: _acUsage,
      renewableEnergyUsage: _renewablePct,
      dietType: _dietType,
      shoppingFrequency: _shoppingFrequency,
      electronicsPurchase: _electronicsPurchase,
      recyclingHabits: _recyclingHabits,
      plasticConsumption: _plasticConsumption,
      composting: _composting,
    );

    await ref.read(twinProvider.notifier).saveAssessment(assessment);
    if (mounted) context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isCalculating) {
      return const OnboardingLoadingScreen();
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark ? [AppColors.darkBg, const Color(0xFF0F172A)] : [AppColors.lightBg, const Color(0xFFEFF6FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildProgressHeader(isDark),
              Expanded(
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 680),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Card(
                      elevation: isDark ? 0 : 4,
                      color: isDark ? AppColors.darkCard : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            WelcomeStepCard(isDark: isDark),
                            TransportationStepCard(
                              vehicleType: _vehicleType,
                              weeklyDistance: _weeklyDistance,
                              publicTransport: _publicTransport,
                              flightsPerYear: _flightsPerYear,
                              onVehicleTypeChanged: (val) => setState(() => _vehicleType = val ?? 'None'),
                              onWeeklyDistanceChanged: (val) => setState(() => _weeklyDistance = val),
                              onPublicTransportChanged: (val) => setState(() => _publicTransport = val),
                              onFlightsPerYearChanged: (val) => setState(() => _flightsPerYear = val.toInt()),
                              isDark: isDark,
                            ),
                            EnergyStepCard(
                              monthlyElectricity: _monthlyElectricity,
                              acUsage: _acUsage,
                              renewablePct: _renewablePct,
                              onMonthlyElectricityChanged: (val) => setState(() => _monthlyElectricity = val),
                              onAcUsageChanged: (val) => setState(() => _acUsage = val),
                              onRenewablePctChanged: (val) => setState(() => _renewablePct = val ?? 0.0),
                              isDark: isDark,
                            ),
                            FoodStepCard(
                              dietType: _dietType,
                              onDietTypeChanged: (val) => setState(() => _dietType = val),
                              isDark: isDark,
                            ),
                            ShoppingStepCard(
                              shoppingFrequency: _shoppingFrequency,
                              electronicsPurchase: _electronicsPurchase,
                              onShoppingFrequencyChanged: (val) => setState(() => _shoppingFrequency = val ?? 'Medium'),
                              onElectronicsPurchaseChanged: (val) => setState(() => _electronicsPurchase = val ?? 'Occasionally'),
                              isDark: isDark,
                            ),
                            WasteStepCard(
                              recyclingHabits: _recyclingHabits,
                              plasticConsumption: _plasticConsumption,
                              composting: _composting,
                              onRecyclingHabitsChanged: (val) => setState(() => _recyclingHabits = val ?? 'Occasionally'),
                              onPlasticConsumptionChanged: (val) => setState(() => _plasticConsumption = val ?? 'Medium'),
                              onCompostingChanged: (val) => setState(() => _composting = val ?? false),
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _buildControlRow(isDark),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressHeader(bool isDark) {
    if (_currentStep == 0) return const SizedBox(height: 32);
    final double progress = _currentStep / 5.0;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Step $_currentStep of 5',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                ),
                Text(
                  '${(progress * 100).toInt()}% Complete',
                  style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: isDark ? AppColors.darkCardBorder : Colors.grey.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlRow(bool isDark) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 680),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _prevStep,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
            )
          else
            const SizedBox.shrink(),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
            onPressed: _nextStep,
            icon: Icon(_currentStep == 5 ? Icons.check : Icons.arrow_forward),
            label: Text(_currentStep == 0
                ? 'Get Started'
                : _currentStep == 5
                    ? 'Generate Twin'
                    : 'Next'),
          ),
        ],
      ),
    );
  }
}
