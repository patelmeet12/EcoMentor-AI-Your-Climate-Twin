import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/simulate_carbon_usecase.dart';
import 'twin_provider.dart';

/// Represents the active state inside the Future Impact Simulator.
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

/// Provider for future simulations.
final simulationProvider = StateNotifierProvider<SimulationNotifier, SimulationState>((ref) {
  final TwinState twinState = ref.watch(twinProvider);
  return SimulationNotifier(twinState);
});

/// Controller that monitors simulator state updates.
class SimulationNotifier extends StateNotifier<SimulationState> {
  final TwinState _twinState;
  final SimulateCarbonUseCase _simulateCarbon = SimulateCarbonUseCase();

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
    final Map<String, bool> initialToggles = <String, bool>{};
    for (final rec in _twinState.recommendations) {
      if (!rec.isCompleted) {
        initialToggles[rec.id] = false;
      }
    }
    state = state.copyWith(toggledActions: initialToggles);
  }

  /// Toggles an action offset inside the simulation playground.
  void toggleAction(String actionId) {
    final Map<String, bool> updatedToggles = Map<String, bool>.from(state.toggledActions);
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

    // Delegate calculation of simulated values to the usecase
    final Map<String, dynamic> simulationResult = _simulateCarbon(
      baseEmissions: _twinState.twin.annualEmissions,
      reducedEmissionsOffset: reducedKg,
    );

    state = state.copyWith(
      toggledActions: updatedToggles,
      simulatedEmissions: simulationResult['emissions'] as double,
      simulatedScore: simulationResult['score'] as int,
      simulatedGrade: simulationResult['grade'] as String,
      totalReducedKg: reducedKg,
      totalSavingsInr: savings,
    );
  }
}
