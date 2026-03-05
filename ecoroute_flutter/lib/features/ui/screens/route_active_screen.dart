import 'package:flutter/material.dart';
import '../../../core/models/eco_route.dart';
import '../../../core/services/active_route_service.dart';
import '../theme/app_colors.dart';

class RouteActiveScreen extends StatelessWidget {
  final EcoRoute route;

  const RouteActiveScreen({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Ruta en progreso',
          style: TextStyle(
            color: AppColors.darkText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
              child: const Center(
                child: Icon(Icons.directions_bike, size: 60, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '¡En marcha!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              route.name,
              style: const TextStyle(fontSize: 16, color: AppColors.lightText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _ActiveStat(
                    icon: Icons.straighten,
                    label: 'Distancia',
                    value: '${route.distanceKm} km',
                  ),
                  const Divider(height: 24),
                  _ActiveStat(
                    icon: Icons.access_time,
                    label: 'Tiempo estimado',
                    value: '${route.durationMinutes} min',
                  ),
                  const Divider(height: 24),
                  _ActiveStat(
                    icon: Icons.eco,
                    label: 'CO₂ que ahorrarás',
                    value: '${route.co2SavedKg} kg',
                    color: const Color(0xFF4CAF50),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Volver al menú SIN finalizar
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((r) => r.isFirst);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Volver al menú',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Finalizar SÍ borra la ruta activa
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ActiveRouteService().finish();
                  Navigator.of(context).popUntil((r) => r.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF44336),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Finalizar Ruta',
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
}

class _ActiveStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _ActiveStat({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color ?? AppColors.primary, size: 22),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: AppColors.lightText, fontSize: 14)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: color ?? AppColors.darkText,
          ),
        ),
      ],
    );
  }
}
