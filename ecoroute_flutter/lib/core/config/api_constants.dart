
class ApiConstants {
  // Emulador Android
  static const String baseUrl = 'http://10.0.2.2:8000/api/';

  // Si usas dispositivo físico, cambia por tu IP local:
  // static const String baseUrl = 'http://192.168.1.X:8000/api/';

  static const String login            = '${baseUrl}login';
  static const String currentUser      = '${baseUrl}user/current';
  static const String currentStats     = '${baseUrl}stats/current';
  static const String routes           = '${baseUrl}routes';
  static const String challengesActive = '${baseUrl}challenges/active';
  static const String chatMessages     = '${baseUrl}chat/messages';
}
