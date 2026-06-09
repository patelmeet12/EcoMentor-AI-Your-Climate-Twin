import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/calculations.dart';
import 'twin_provider.dart';

class SimulationState {
  final Map<String, bool> toggledActions; // id -> isToggled
  final double simulatedEmissions;
  final int simulatedScore;
  final String simulatedGrade;
  final double totalReducedKg;
  final double totalSavingsInr;

  const SimulationState({
    required this.toggledActions,
    required this.simulatedEmissions,
    required this.simulatedScore,
    required this.simulatedGrade,
    required this.totalReducedKg,
    required this.totalSavingsInr,
  });

  SimulationState copyWith({
    Map<String, bool>? toggledActions,
    double? simulatedEmissions,
    int? simulatedScore,
    String? simulatedGrade,
    double? totalReducedKg,
    double? totalSavingsInr,
  }) {
    return SimulationState(
      toggledActions: toggledActions ?? this.toggledActions,
      simulatedEmissions: simulatedEmissions ?? this.simulatedEmissions,
      simulatedScore: simulatedScore ?? this.simulatedScore,
      simulatedGrade: simulatedGrade ?? this.simulatedGrade,
      totalReducedKg: totalReducedKg ?? this.totalReducedKg,
      totalSavingsInr: totalSavingsInr ?? this.totalSavingsInr,
    );
  }
}

final simulationProvider = StateNotifierProvider<SimulationNotifier, SimulationState>((ref) {
  final twinState = ref.watch(twinProvider);
  return SimulationNotifier(twinState);
});

class SimulationNotifier extends StateNotifier<SimulationState> {
  final TwinState _twinState;

  SimulationNotifier(this._twinState)
      : super(SimulationState(
          toggledActions: {},
          simulatedEmissions: _twinState.twin.annualEmissions,
          simulatedScore: _twinState.twin.score,
          simulatedGrade: _twinState.twin.grade,
          totalReducedKg: 0.0,
          totalSavingsInr: 0.0,
        )) {
    _initializeToggles();
  }

  void _initializeToggles() {
    final initialToggles = <String, bool>{};
    for (final rec in _twinState.recommendations) {
      if (!rec.isCompleted) {
        initialToggles[rec.id] = false;
      }
    }
    state = state.copyWith(toggledActions: initialToggles);
  }

  void toggleAction(String actionId) {
    final updatedToggles = Map<String, bool>.from(state.toggledActions);
    if (updatedToggles.containsKey(actionId)) {
      updatedToggles[actionId] = !updatedToggles[actionId]!;
    } else {
      updatedToggles[actionId] = true;
    }

    double reducedKg = 0.0;
    double savings = 0.0;

    for (final rec in _twinState.recommendations) {
      if (updatedToggles[rec.id] == true) {
        reducedKg += rec.impactKg;
        savings += rec.savingsInr;
      }
    }

    final simulatedEmissions = _twinState.twin.annualEmissions - reducedKg;
    final simulatedScore = CarbonCalculations.calculateSustainabilityScore(simulatedEmissions);
    final simulatedGrade = CarbonCalculations.calculateGrade(simulatedScore);

    state = state.copyWith(
      toggledActions: updatedToggles,
      simulatedEmissions: simulatedEmissions < 0 ? 0.0 : simulatedEmissions,
      simulatedScore: simulatedScore,
      simulatedGrade: simulatedGrade,
      totalReducedKg: reducedKg,
      totalSavingsInr: savings,
    );
  }
}
