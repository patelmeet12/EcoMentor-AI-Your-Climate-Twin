import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/pages/coach/coach_page.dart';
import '../../presentation/pages/dashboard/dashboard_page.dart';
import '../../presentation/pages/onboarding/onboarding_page.dart';
import '../../presentation/pages/profile/profile_page.dart';
import '../../presentation/pages/shell/shell_page.dart';
import '../../presentation/pages/simulator/simulator_page.dart';
import '../presentation/providers/twin_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final twinState = ref.watch(twinProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // If still initializing, stay on splash redirection checkpoint
      if (twinState.isLoading) return null;

      final hasDoneOnboarding = twinState.hasAssessment;
      final isGoingToOnboarding = state.matchedLocation == '/onboarding';

      if (!hasDoneOnboarding && !isGoingToOnboarding) {
        return '/onboarding';
      }
      if (hasDoneOnboarding && isGoingToOnboarding) {
        return '/dashboard';
      }
      if (state.matchedLocation == '/') {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => ShellPage(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/simulator',
            builder: (context, state) => const SimulatorPage(),
          ),
          GoRoute(
            path: '/coach',
            builder: (context, state) => const CoachPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
});
