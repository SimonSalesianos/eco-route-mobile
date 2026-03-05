class ActiveChallengeService {
  static final ActiveChallengeService _instance = ActiveChallengeService._internal();
  factory ActiveChallengeService() => _instance;
  ActiveChallengeService._internal();

  final Set<String> _joined     = {};
  final Set<String> _completed  = {};
  final Map<String, int> _points = {};

  bool isJoined(String id)    => _joined.contains(id);
  bool isCompleted(String id) => _completed.contains(id);

  int get totalPoints    => _points.values.fold(0, (a, b) => a + b);
  int get totalCompleted => _completed.length;

  void join(String id) => _joined.add(id);

  void complete(String id, int points) {
    _joined.add(id);
    _completed.add(id);
    _points[id] = points;
  }
}
