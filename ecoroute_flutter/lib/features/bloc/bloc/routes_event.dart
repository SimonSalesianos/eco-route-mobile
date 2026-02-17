part of 'routes_bloc.dart';

@immutable
sealed class RoutesEvent {}

final class RoutesRequested extends RoutesEvent {}