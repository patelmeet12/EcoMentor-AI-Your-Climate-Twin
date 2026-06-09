/// Abstract base class representing application errors.
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

/// Represents cache read/write issues in SharedPreferences.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Represents failures in carbon or scoring math operations.
class CalculationFailure extends Failure {
  const CalculationFailure(super.message);
}
