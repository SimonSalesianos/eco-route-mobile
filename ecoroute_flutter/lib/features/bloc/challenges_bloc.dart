import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/interfaces/challengues_repository.dart';
import '../../../core/models/challenge.dart';

part 'challenges_event.dart';
part 'challenges_state.dart';

class ChallengesBloc extends Bloc<ChallengesEvent, ChallengesState> {
  final ChallengesRepository _challengesRepository;

  ChallengesBloc(this._challengesRepository) : super(ChallengesLoading()) {
    on<ChallengesRequested>(_onChallengesRequested);
  }

  Future<void> _onChallengesRequested(
    ChallengesRequested event,
    Emitter<ChallengesState> emit,
  ) async {
    emit(ChallengesLoading());

    try {
      final challenges = await _challengesRepository.getActiveChallenges();
      emit(ChallengesLoaded(challenges: challenges));
    } catch (e) {
      emit(ChallengesError(message: e.toString()));
    }
  }
}
