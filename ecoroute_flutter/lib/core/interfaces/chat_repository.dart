import '../models/message.dart';

abstract class ChatRepository {
  Stream<List<ChatMessage>> watchChatMessages();
  Future<void> sendMessage(String text);
}
