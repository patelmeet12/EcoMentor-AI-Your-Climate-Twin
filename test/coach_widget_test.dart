import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecomentor_ai/main.dart';
import 'package:ecomentor_ai/presentation/providers/twin_provider.dart';

void main() {
  group('CoachPage Widget Tests', () {
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
          'xpPoints': 100,
          'streakDays': 1,
          'achievements': <String>['Green Starter'],
          'lastUpdatedDate': null,
        }),
      });
      prefs = await SharedPreferences.getInstance();
    });

    testWidgets('Renders coach welcomes, handles text submissions and quick replies', (WidgetTester tester) async {
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

      // Settle initial router load
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Navigate to Coach tab
      final coachTabFinder = find.byIcon(Icons.chat_bubble_outline);
      expect(coachTabFinder, findsOneWidget);
      await tester.tap(coachTabFinder);
      
      // Let tab navigation transit settle
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Verify page layout is visible
      expect(find.text('Climate Twin Coach'), findsOneWidget);
      expect(find.textContaining('I am your Climate Twin Coach. 🌍'), findsOneWidget);

      // Verify quick replies exist
      expect(find.text('Explain my score'), findsOneWidget);
      expect(find.text('Give me a weekly goal'), findsOneWidget);

      // Type a custom text message into the chat field
      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);
      await tester.enterText(textFieldFinder, 'Tell me about solar panels');
      
      // Submit custom question by pressing send button
      final sendButtonFinder = find.byIcon(Icons.send);
      expect(sendButtonFinder, findsOneWidget);
      await tester.tap(sendButtonFinder);
      
      // Pump immediate frame to trigger user bubble addition and 'Coach is typing...' state
      await tester.pump();
      expect(find.text('Tell me about solar panels'), findsOneWidget);
      expect(find.text('Coach is typing...'), findsOneWidget);

      // Pump 800ms to resolve simulated typing delay (600ms)
      await tester.pump(const Duration(milliseconds: 800));

      // Coach should output reply mentioning home energy
      expect(find.textContaining('Home energy emissions are heavily linked'), findsOneWidget);

      // Tap on a quick reply button to verify automated query updates
      final quickReplyFinder = find.text('Explain my score');
      await tester.tap(quickReplyFinder);
      
      // Settle quick reply user message addition frame
      await tester.pump();
      expect(find.text('Coach is typing...'), findsOneWidget);

      // Resolve simulated delay
      await tester.pump(const Duration(milliseconds: 800));

      // Verify that the coach explained the score (D or Eco Hero grade based on stats)
      expect(find.textContaining('Your Sustainability Score is'), findsOneWidget);
    });
  });
}
