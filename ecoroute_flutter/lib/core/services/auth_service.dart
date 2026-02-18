import 'dart:convert';

import 'package:flutter_application_tmdb_proyecto/core/config/api_constants.dart';
import 'package:flutter_application_tmdb_proyecto/core/services/secure_storage_service.dart';
import 'package:http/http.dart' as http;

import '../config/api_constants.dart';
import 'secure_storage_service.dart';

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
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = json.decode(response.body) as Map<String, dynamic>;

      final token = data['access_token'] as String;
      await _storage.saveToken(token);
    } else {
      throw Exception('Credenciales incorrectas o error en el login');
    }
  }
}