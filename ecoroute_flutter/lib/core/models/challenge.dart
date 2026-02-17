enum ChallengeDifficulty { easy, medium, hard }

class Challenge {
  final String id;
  final String title;
  final String description;
  final ChallengeDifficulty difficulty;
  final int remainingDays;
  final int progressCurrent;
  final int progressTotal;
  final int rewardPoints;

  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.remainingDays,
    required this.progressCurrent,
    required this.progressTotal,
    required this.rewardPoints,
  });
}
