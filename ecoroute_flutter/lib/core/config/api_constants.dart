class ApiConstants {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static const String login = '${baseUrl}auth/login';
  static const String currentUser = '${baseUrl}user/current';
  static const String currentStats = '${baseUrl}stats/current';
  static const String routes = '${baseUrl}routes';
  static const String challengesActive = '${baseUrl}challenges/active';
  static const String chatMessages = '${baseUrl}chat/messages';
}