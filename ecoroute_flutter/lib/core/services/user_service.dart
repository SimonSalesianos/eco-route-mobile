import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_constants.dart';
import '../interfaces/user_repository.dart';
import '../models/user.dart';
import 'secure_storage_service.dart';

class UserService implements UserRepository {
  final http.Client _client;
  final SecureStorageService _storage;

  UserService({http.Client? client, SecureStorageService? storage})
      : _client = client ?? http.Client(),
        _storage = storage ?? SecureStorageService();

  @override
  Future<User> getCurrentUser() async {
    final uri = Uri.parse(ApiConstants.currentUser);
    final token = await _storage.getToken();
    
    if (token == null) {
      throw Exception('No hay token almacenado');
    }

    try {
      final response = await _client.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        return User(
          id: data['id'].toString(),
          fullName: data['full_name'] as String,
          email: data['email'] as String,
        );
      } else {
        throw Exception('Error ${response.statusCode} al obtener el usuario');
      }
    } catch (e) {
      throw Exception('Error al obtener el usuario actual');
    }
  }
}
