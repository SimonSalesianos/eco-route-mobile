import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_constants.dart';
import '../interfaces/chat_repository.dart';
import '../models/message.dart';
import 'secure_storage_service.dart';

class ChatService implements ChatRepository {
  final http.Client _client;
  final SecureStorageService _storage;

  ChatService({http.Client? client, SecureStorageService? storage})
      : _client = client ?? http.Client(),
        _storage = storage ?? SecureStorageService();

  @override
  Stream<List<ChatMessage>> watchChatMessages() async* {
    while (true) {
      try {
        final messages = await _fetchMessagesOnce();
        yield messages;
      } catch (e) {
        throw Exception('Error al obtener mensajes: $e');
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  Future<List<ChatMessage>> _fetchMessagesOnce() async {
    final uri = Uri.parse(ApiConstants.chatMessages);
    final token = await _storage.getToken();

    if (token == null) throw Exception('No hay token almacenado');

    final response = await _client.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = json.decode(response.body) as List<dynamic>;
      return data.map((messageJson) {
        final map = messageJson as Map<String, dynamic>;

        final authorName = (map['author_name'] as String?) ?? 'Usuario';
        final authorInitials = (map['author_initials'] as String?)
            ?? (authorName.isNotEmpty ? authorName[0].toUpperCase() : '?');

        return ChatMessage(
          id: map['id'].toString(),
          authorName: authorName,
          authorInitials: authorInitials,
          text: (map['text'] ?? map['content'] ?? '') as String,
          createdAt: DateTime.parse(
            (map['created_at'] ?? map['updated_at']).toString(),
          ),
          isMine: map['is_mine'] as bool? ?? false,
        );
      }).toList();
    } else {
      throw Exception('Error ${response.statusCode} al obtener mensajes');
    }
  }

  @override
Future<void> sendMessage(String text) async {
  final uri = Uri.parse(ApiConstants.chatMessages);
  final token = await _storage.getToken();

  if (token == null) throw Exception('No hay token almacenado');

  final response = await _client.post(
    uri,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: json.encode({
      'content': text, 
    }),
  );

  if (!(response.statusCode >= 200 && response.statusCode < 300)) {
    throw Exception('Error ${response.statusCode} al enviar mensaje');
  }
}

}
