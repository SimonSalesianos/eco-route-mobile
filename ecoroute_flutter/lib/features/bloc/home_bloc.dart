import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/interfaces/user_repository.dart';
import '../../../core/interfaces/stats_repository.dart';
import '../../../core/models/user.dart';
import '../../../core/models/stats.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository _userRepository;
  final StatsRepository _statsRepository;

  HomeBloc(this._userRepository, this._statsRepository)
      : super(HomeLoading()) {
    on<HomeStarted>(_onHomeStarted);
  }

  Future<void> _onHomeStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      final user = await _userRepository.getCurrentUser();
      final stats = await _statsRepository.getUserStats();
      emit(HomeLoaded(user: user, stats: stats));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}