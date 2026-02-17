import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_constants.dart';
import '../interfaces/challengues_repository.dart';
import '../models/challenge.dart';
import 'secure_storage_service.dart';

class ChallengesService implements ChallengesRepository {
  final http.Client _client;
  final SecureStorageService _storage;

  ChallengesService({http.Client? client, SecureStorageService? storage})
      : _client = client ?? http.Client(),
        _storage = storage ?? SecureStorageService();

  @override
  Future<List<Challenge>> getActiveChallenges() async {
    final uri = Uri.parse(ApiConstants.challengesActive);
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

        return data.map((challengeJson) {
          final map = challengeJson as Map<String, dynamic>;

          return Challenge(
            id: map['id'].toString(),
            title: map['title'] as String,
            description: map['description'] as String,
            difficulty: _difficultyFromString(map['difficulty'] as String),
            remainingDays: map['remaining_days'] as int,
            progressCurrent: map['progress_current'] as int,
            progressTotal: map['progress_total'] as int,
            rewardPoints: map['reward_points'] as int,
          );
        }).toList();
      } else {
        throw Exception(
          'Error ${response.statusCode} al obtener retos activos',
        );
      }
    } catch (e) {
      throw Exception('Error al obtener los retos activos');
    }
  }

  ChallengeDifficulty _difficultyFromString(String value) {
    switch (value.toLowerCase()) {
      case 'easy':
        return ChallengeDifficulty.easy;
      case 'medium':
        return ChallengeDifficulty.medium;
      case 'hard':
        return ChallengeDifficulty.hard;
      default:
        return ChallengeDifficulty.easy;
    }
  }
}
