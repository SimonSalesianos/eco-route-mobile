import 'package:flutter/material.dart';
import '../../../core/models/eco_route.dart';
import '../../../core/services/active_route_service.dart';
import '../theme/app_colors.dart';
import 'route_active_screen.dart';

class RouteDetailScreen extends StatelessWidget {
  final EcoRoute route;

  const RouteDetailScreen({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Detalle de Ruta',
          style: TextStyle(
            color: AppColors.darkText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.route,
                  color: AppColors.primary,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 24),

            Center(
              child: Text(
                route.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),

            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _difficultyColor(route.difficulty).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _difficultyText(route.difficulty),
                  style: TextStyle(
                    color: _difficultyColor(route.difficulty),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatBox(
                  icon: Icons.straighten,
                  value: '${route.distanceKm} km',
                  label: 'Distancia',
                ),
                _StatBox(
                  icon: Icons.access_time,
                  value: '${route.durationMinutes} min',
                  label: 'Duración',
                ),
                _StatBox(
                  icon: Icons.eco,
                  value: '${route.co2SavedKg} kg',
                  label: 'CO₂ ahorrado',
                  color: const Color(0xFF4CAF50),
                ),
              ],
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Al completar esta ruta acumularás puntos y contribuirás a reducir la huella de carbono.',
                      style: TextStyle(fontSize: 13, color: AppColors.lightText),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ActiveRouteService().start(route); 
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RouteActiveScreen(route: route),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Comenzar Ruta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _difficultyText(RouteDifficulty d) {
    switch (d) {
      case RouteDifficulty.easy:   return 'Fácil';
      case RouteDifficulty.medium: return 'Media';
      case RouteDifficulty.hard:   return 'Difícil';
    }
  }

  Color _difficultyColor(RouteDifficulty d) {
    switch (d) {
      case RouteDifficulty.easy:   return const Color(0xFF4CAF50);
      case RouteDifficulty.medium: return const Color(0xFFFFA726);
      case RouteDifficulty.hard:   return const Color(0xFFF44336);
    }
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? color;

  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color ?? AppColors.primary, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color ?? AppColors.darkText,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.lightText),
        ),
      ],
    );
  }
}
