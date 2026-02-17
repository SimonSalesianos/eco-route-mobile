import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/interfaces/routes_repository.dart';
import '../../../core/models/eco_route.dart';

part 'routes_event.dart';
part 'routes_state.dart';

class RoutesBloc extends Bloc<RoutesEvent, RoutesState> {
  final RoutesRepository _routesRepository;

  RoutesBloc(this._routesRepository) : super(RoutesLoading()) {
    on<RoutesRequested>(_onRoutesRequested);
  }

  Future<void> _onRoutesRequested(
    RoutesRequested event,
    Emitter<RoutesState> emit,
  ) async {
    emit(RoutesLoading());

    try {
      final routes = await _routesRepository.getRoutes();
      emit(RoutesLoaded(routes: routes));
    } catch (e) {
      emit(RoutesError(message: e.toString()));
    }
  }
}
