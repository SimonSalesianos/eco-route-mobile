import '../models/challenge.dart';

abstract class ChallengesRepository {
  Future<List<Challenge>> getActiveChallenges();
}
