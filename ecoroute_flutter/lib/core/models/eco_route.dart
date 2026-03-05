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

  factory EcoRoute.fromJson(Map<String, dynamic> json) {
    return EcoRoute(
      id:              json['id'].toString(),
      name:            json['name'] as String,
      distanceKm:      (json['distance_km'] as num).toDouble(),
      durationMinutes: json['duration_minutes'] as int,
      co2SavedKg:      (json['co2_saved_kg'] as num).toDouble(),
      difficulty:      _parseDifficulty(json['difficulty'] as String),
    );
  }

  static RouteDifficulty _parseDifficulty(String value) {
    switch (value.toLowerCase()) {
      case 'easy':   return RouteDifficulty.easy;
      case 'medium': return RouteDifficulty.medium;
      case 'hard':   return RouteDifficulty.hard;
      default:       return RouteDifficulty.easy;
    }
  }
}
