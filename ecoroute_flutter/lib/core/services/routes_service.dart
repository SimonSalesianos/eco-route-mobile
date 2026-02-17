import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_constants.dart';
import '../interfaces/routes_repository.dart';
import '../models/eco_route.dart';
import 'secure_storage_service.dart';

class RoutesService implements RoutesRepository {
  final http.Client _client;
  final SecureStorageService _storage;

  RoutesService({http.Client? client, SecureStorageService? storage})
      : _client = client ?? http.Client(),
        _storage = storage ?? SecureStorageService();

  @override
  Future<List<EcoRoute>> getRoutes() async {
    final uri = Uri.parse(ApiConstants.routes);
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
        final data = json.decode(response.body) as List<dynamic>;

        return data.map((routeJson) {
          final map = routeJson as Map<String, dynamic>;

          return EcoRoute(
            id: map['id'].toString(),
            name: map['name'] as String,
            distanceKm: (map['distance_km'] as num).toDouble(),
            durationMinutes: map['duration_minutes'] as int,
            co2SavedKg: (map['co2_saved_kg'] as num).toDouble(),
            difficulty: _difficultyFromString(map['difficulty'] as String),
          );
        }).toList();
      } else {
        throw Exception('Error ${response.statusCode} al obtener rutas');
      }
    } catch (e) {
      throw Exception('Error al obtener las rutas');
    }
  }

  RouteDifficulty _difficultyFromString(String value) {
    switch (value.toLowerCase()) {
      case 'easy':
        return RouteDifficulty.easy;
      case 'medium':
        return RouteDifficulty.medium;
      case 'hard':
        return RouteDifficulty.hard;
      default:
        return RouteDifficulty.easy;
    }
  }
}
