import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecomentor_ai/main.dart';
import 'package:ecomentor_ai/presentation/providers/twin_provider.dart';

void main() {
  testWidgets('EcoMentor AI onboarding wizard smoke test', (WidgetTester tester) async {
    // Inject mock shared preferences for testing
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MyApp(),
      ),
    );

    // Wait for frames to settle
    await tester.pumpAndSettle();

    // Verify welcoming step renders properly
    expect(find.text('EcoMentor AI'), findsOneWidget);
    expect(find.text('YOUR CLIMATE TWIN'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
