part of 'routes_bloc.dart';

@immutable
sealed class RoutesState {}

final class RoutesLoading extends RoutesState {}

final class RoutesLoaded extends RoutesState {
  final List<EcoRoute> routes;

  RoutesLoaded({required this.routes});
}

final class RoutesError extends RoutesState {
  final String message;

  RoutesError({required this.message});
}