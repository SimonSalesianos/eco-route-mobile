part of 'challenges_bloc.dart';

@immutable
sealed class ChallengesEvent {}

final class ChallengesRequested extends ChallengesEvent {}