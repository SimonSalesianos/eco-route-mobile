part of 'challenges_bloc.dart';

@immutable
sealed class ChallengesState {}

final class ChallengesLoading extends ChallengesState {}

final class ChallengesLoaded extends ChallengesState {
  final List<Challenge> challenges;

  ChallengesLoaded({required this.challenges});
}

final class ChallengesError extends ChallengesState {
  final String message;

  ChallengesError({required this.message});
}