import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_constants.dart';
import '../interfaces/stats_repository.dart';
import '../models/stats.dart';
import 'secure_storage_service.dart';

class StatsService implements StatsRepository {
  final http.Client _client;
  final SecureStorageService _storage;

  StatsService({http.Client? client, SecureStorageService? storage})
      : _client = client ?? http.Client(),
        _storage = storage ?? SecureStorageService();

  @override
  Future<UserStats> getUserStats() async {
    final uri = Uri.parse(ApiConstants.currentStats);
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

        return UserStats(
          totalRoutes: data['total_routes'] as int,
          totalCo2SavedKg: (data['total_co2_saved_kg'] as num).toDouble(),
          totalAchievements: data['total_achievements'] as int,
        );
      } else {
        throw Exception('Error ${response.statusCode} al obtener estadísticas');
      }
    } catch (e) {
      throw Exception('Error al obtener las estadísticas del usuario');
    }
  }
}
