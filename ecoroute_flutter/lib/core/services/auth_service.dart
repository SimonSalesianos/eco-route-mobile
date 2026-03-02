import 'dart:convert';

import 'package:flutter_application_tmdb_proyecto/core/config/api_constants.dart';
import 'package:flutter_application_tmdb_proyecto/core/services/secure_storage_service.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final http.Client _client;
  final SecureStorageService _storage;

  AuthService({
    http.Client? client,
    SecureStorageService? storage,
  })  : _client = client ?? http.Client(),
        _storage = storage ?? SecureStorageService();

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(ApiConstants.login);
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = json.decode(response.body) as Map<String, dynamic>;

      final token = data['token'] as String;
      await _storage.saveToken(token);

      final userId = data['user']?['id'] ?? data['user_id'];
      if (userId != null) {
        await _storage.saveUserId(
          userId is int ? userId : int.parse(userId.toString()),
        );
      }
    } else {
      throw Exception('Credenciales incorrectas o error en el login');
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}register');

    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = json.decode(response.body) as Map<String, dynamic>;

      final token = data['token'] as String;
      await _storage.saveToken(token);

      final userId = data['user']['id'];
      await _storage.saveUserId(
        userId is int ? userId : int.parse(userId.toString()),
      );
    } else if (response.statusCode == 422) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      throw Exception(data['message'] ?? 'Error de validación en el registro');
    } else {
      throw Exception('Error ${response.statusCode} al registrar usuario');
    }
  }

  Future<void> logout() async {
    await _storage.clearAll();
  }
}
