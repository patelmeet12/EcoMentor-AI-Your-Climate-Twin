import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecomentor_ai/main.dart';
import 'package:ecomentor_ai/presentation/providers/twin_provider.dart';

void main() {
  group('ProfilePage Widget Tests', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'assessment_data': jsonEncode({
          'vehicleType': 'Electric Car',
          'fuelType': 'Electric',
          'weeklyDistance': 50.0,
          'publicTransportUsage': 0.0,
          'flightsPerYear': 0,
          'monthlyElectricity': 100.0,
          'acUsage': 1.0,
          'renewableEnergyUsage': 0.8,
          'dietType': 'Vegan',
          'shoppingFrequency': 'Low',
          'electronicsPurchase': 'Rarely',
          'recyclingHabits': 'Regularly',
          'plasticConsumption': 'Low',
          'composting': true,
        }),
        'user_progress_data': jsonEncode({
          'completedActionIds': <String>[],
          'totalCarbonReduced': 0.0,
          'xpPoints': 450, // Level 2: 450 XP (since Level = XP / 400 + 1)
          'streakDays': 2,
          'achievements': <String>['Green Starter', 'Eco Explorer'],
          'lastUpdatedDate': null,
        }),
      });
      prefs = await SharedPreferences.getInstance();
    });

    testWidgets('Renders identity card and unlocked achievements', (WidgetTester tester) async {
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

      // Pump several frames to let redirection and state settle
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Navigate to Profile tab by tapping on the navigation icon
      final profileTabFinder = find.byIcon(Icons.emoji_events_outlined);
      expect(profileTabFinder, findsOneWidget);
      await tester.tap(profileTabFinder);
      
      // Let navigation transit settle
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Check header title
      expect(find.text('Climate Twin & Achievements'), findsOneWidget);

      // Check level display
      expect(find.text('Level 2'), findsOneWidget);
      expect(find.textContaining('450 / 800 XP'), findsOneWidget);

      // Verify personality rendering (Electric and vegan profile should score high -> Eco Hero)
      expect(find.text('Eco Hero'), findsOneWidget);

      // Check achievements and medals
      expect(find.text('Green Starter'), findsOneWidget);
      expect(find.text('Eco Explorer'), findsOneWidget);
    });
  });
}
