import 'package:flutter/material.dart';

/// Core application constants.
class AppConstants {
  // SharedPreferences Keys
  static const String keyAssessment = 'assessment_data';
  static const String keyProgress = 'user_progress_data';

  // Currency & Defaults
  static const String defaultCurrencySymbol = '₹';

  // Transportation Carbon Factors (kg CO2 per km)
  static const double factorGasolineCar = 0.18;
  static const double factorDieselCar = 0.17;
  static const double factorHybridCar = 0.09;
  static const double factorElectricCar = 0.05;
  static const double factorMotorcycle = 0.08;
  static const double factorPublicTransport = 0.03; // per km
  static const double factorFlights = 500.0; // per flight
  static const double avgPublicSpeedKmh = 25.0; // km/h

  // Energy Carbon Factors
  static const double factorGridElectricity = 0.85; // kg CO2 per kWh
  static const double factorAcHour = 0.6; // kg CO2 per hour

  // Food Carbon Factors (kg CO2 per year)
  static const double factorDietVegan = 800.0;
  static const double factorDietVegetarian = 1200.0;
  static const double factorDietMixed = 2000.0;
  static const double factorDietHighMeat = 3000.0;

  // Shopping Carbon Factors (kg CO2 per year)
  static const double factorShoppingLow = 200.0;
  static const double factorShoppingMedium = 600.0;
  static const double factorShoppingHigh = 1200.0;
  static const double factorElectronicsRare = 100.0;
  static const double factorElectronicsOccasional = 200.0;
  static const double factorElectronicsFrequent = 600.0;

  // Waste Carbon Factors
  static const double factorWasteBase = 500.0;
  static const double factorWasteRecycleReg = -150.0;
  static const double factorWasteRecycleOcc = -50.0;
  static const double factorPlasticHigh = 100.0;
  static const double factorPlasticLow = -50.0;
  static const double factorCompostOffset = -100.0;

  // Core Score Thresholds
  static const double thresholdNetZero = 1500.0;
  static const double thresholdMaxFootprint = 15000.0;

  // Static badge definitions
  static const List<Map<String, dynamic>> badges = [
    {
      'id': 'Green Starter',
      'title': 'Green Starter',
      'desc': 'Completed onboarding lifestyle assessment.',
      'icon': Icons.eco,
      'color': Colors.teal,
    },
    {
      'id': 'Carbon Reducer',
      'title': 'Carbon Reducer',
      'desc': 'Completed your first carbon-reduction recommendation.',
      'icon': Icons.bolt,
      'color': Colors.amber,
    },
    {
      'id': 'Eco Explorer',
      'title': 'Eco Explorer',
      'desc': 'Replaced habits to achieve a Sustainability Score >= 70.',
      'icon': Icons.explore,
      'color': Colors.cyan,
    },
    {
      'id': 'Sustainability Hero',
      'title': 'Sustainability Hero',
      'desc': 'Optimized habits to reach a score >= 85.',
      'icon': Icons.shield_rounded,
      'color': Colors.purpleAccent,
    },
    {
      'id': 'Planet Guardian',
      'title': 'Planet Guardian',
      'desc': 'Successfully checked off 3 or more carbon tasks.',
      'icon': Icons.spa,
      'color': Colors.blueAccent,
    },
    {
      'id': 'Streak Master',
      'title': 'Streak Master',
      'desc': 'Maintained a consistent daily green streak for 3 days.',
      'icon': Icons.local_fire_department,
      'color': Colors.orange,
    },
  ];
}
