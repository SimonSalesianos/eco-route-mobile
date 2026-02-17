enum RouteDifficulty { easy, medium, hard }

class EcoRoute {
  final String id;
  final String name;
  final double distanceKm;
  final int durationMinutes;
  final double co2SavedKg;
  final RouteDifficulty difficulty;

  const EcoRoute({
    required this.id,
    required this.name,
    required this.distanceKm,
    required this.durationMinutes,
    required this.co2SavedKg,
    required this.difficulty,
  });
}
