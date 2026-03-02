import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/interfaces/chat_repository.dart';
import '../../../core/models/message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  StreamSubscription<List<ChatMessage>>? _subscription;

  ChatBloc(this._chatRepository) : super(ChatLoading()) {
    on<ChatStarted>(_onChatStarted);
    on<MessageSent>(_onMessageSent);
    on<_ChatMessagesUpdated>(_onMessagesUpdated);
  }

  Future<void> _onChatStarted(
    ChatStarted event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    await _subscription?.cancel();
    _subscription = _chatRepository.watchChatMessages().listen(
      (messages) => add(_ChatMessagesUpdated(messages)),
      onError: (error) => emit(ChatError(message: error.toString())),
    );
  }

  Future<void> _onMessageSent(
    MessageSent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _chatRepository.sendMessage(event.text);
      // Recarga inmediata sin esperar los 5 segundos del polling
      final messages = await _chatRepository.watchChatMessages().first;
      emit(ChatLoaded(messages: messages));
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }

  void _onMessagesUpdated(
    _ChatMessagesUpdated event,
    Emitter<ChatState> emit,
  ) {
    emit(ChatLoaded(messages: event.messages));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
