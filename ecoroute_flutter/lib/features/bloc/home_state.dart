part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final User user;
  final UserStats stats;

  HomeLoaded({
    required this.user,
    required this.stats,
  });
}

final class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}