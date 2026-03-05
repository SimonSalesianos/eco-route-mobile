import '../models/eco_route.dart';

class ActiveRouteService {
  static final ActiveRouteService _instance = ActiveRouteService._internal();
  factory ActiveRouteService() => _instance;
  ActiveRouteService._internal();

  EcoRoute? activeRoute;
  int completedRoutes = 0; // ✅ contador local

  bool isActive(String routeId) => activeRoute?.id == routeId;

  void start(EcoRoute route) => activeRoute = route;

  void finish() {
    if (activeRoute != null) {
      completedRoutes++; // ✅ suma al finalizar
      activeRoute = null;
    }
  }
}
