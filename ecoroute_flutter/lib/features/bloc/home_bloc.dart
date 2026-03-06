import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/interfaces/user_repository.dart';
import '../../../core/interfaces/stats_repository.dart';
import '../../../core/models/user.dart';
import '../../../core/models/stats.dart';
import '../../../core/services/secure_storage_service.dart'; 

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository _userRepository;
  final StatsRepository _statsRepository;
  final SecureStorageService _storage = SecureStorageService(); 

  HomeBloc(this._userRepository, this._statsRepository)
      : super(HomeLoading()) {
    on<HomeStarted>(_onHomeStarted);
    on<HomeLogoutRequested>(_onLogoutRequested);
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

  Future<void> _onLogoutRequested(
    HomeLogoutRequested event,
    Emitter<HomeState> emit,
  ) async {
    await _storage.clearAll(); 
    emit(HomeLoggedOut());
  }
}
