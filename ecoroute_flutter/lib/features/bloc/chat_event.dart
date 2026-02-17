part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

final class ChatStarted extends ChatEvent {}

final class MessageSent extends ChatEvent {
  final String text;

  MessageSent(this.text);
}

final class _ChatMessagesUpdated extends ChatEvent {
  final List<ChatMessage> messages;

  _ChatMessagesUpdated(this.messages);
}