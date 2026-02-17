import '../models/eco_route.dart';

abstract class RoutesRepository {
  Future<List<EcoRoute>> getRoutes();
}
