import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecomentor_ai/main.dart';
import 'package:ecomentor_ai/presentation/providers/twin_provider.dart';

void main() {
  group('DashboardPage Widget Tests', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'assessment_data': jsonEncode({
          'vehicleType': 'Gasoline Car',
          'fuelType': 'Gasoline',
          'weeklyDistance': 100.0,
          'publicTransportUsage': 2.0,
          'flightsPerYear': 1,
          'monthlyElectricity': 300.0,
          'acUsage': 4.0,
          'renewableEnergyUsage': 0.1,
          'dietType': 'Mixed',
          'shoppingFrequency': 'Medium',
          'electronicsPurchase': 'Occasionally',
          'recyclingHabits': 'Occasionally',
          'plasticConsumption': 'Medium',
          'composting': false,
        }),
        'user_progress_data': jsonEncode({
          'completedActionIds': <String>[],
          'totalCarbonReduced': 0.0,
          'xpPoints': 100,
          'streakDays': 1,
          'achievements': <String>['Green Starter'],
          'lastUpdatedDate': null,
        }),
      });
      prefs = await SharedPreferences.getInstance();
    });

    testWidgets('Renders all dashboard cards and handles checkbox toggle', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MyApp(),
        ),
      );

      // Pump several frames to let GoRouter redirection and Riverpod state initialization settle.
      // We avoid pumpAndSettle() here because TwinAvatar has a looping repeat animation.
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Check header title
      expect(find.text('Your Climate Twin Dashboard'), findsOneWidget);

      // Verify TwinProfileCard components (e.g. Twin's Personality & Grade)
      expect(find.textContaining('Twin Sustainability Grade:'), findsOneWidget);
      expect(find.text('GRID DEPENDENT'), findsOneWidget);

      // Verify CarbonBreakdownCard renders
      expect(find.text('Carbon Footprint Breakdown'), findsOneWidget);

      // Verify Forecast Card renders
      expect(find.text('Carbon Forecast & Outlook'), findsOneWidget);

      // Find first recommendation CheckboxListTile in the checklist
      final checkboxFinder = find.byType(CheckboxListTile).first;
      expect(checkboxFinder, findsOneWidget);

      // Tap on the recommendation CheckboxListTile to toggle it
      await tester.tap(checkboxFinder);
      
      // Pump frames to let state update settle
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Ensure state updates are reflected and didn't crash
      expect(find.text('400 XP'), findsOneWidget);
    });
  });
}
