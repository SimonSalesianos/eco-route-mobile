import '../models/stats.dart';

abstract class StatsRepository {
  Future<UserStats> getUserStats();
}
