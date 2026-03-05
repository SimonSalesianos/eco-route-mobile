import 'package:flutter/material.dart';

import '../../../core/models/eco_route.dart';
import '../../../core/services/active_route_service.dart';
import '../screens/route_active_screen.dart';
import '../screens/route_detail_screen.dart';
import '../theme/app_colors.dart';

class RouteCard extends StatefulWidget {
  final EcoRoute route;

  const RouteCard({super.key, required this.route});

  @override
  State<RouteCard> createState() => _RouteCardState();
}

class _RouteCardState extends State<RouteCard> {
  @override
  Widget build(BuildContext context) {
    final isActive = ActiveRouteService().isActive(widget.route.id);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.route,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.route.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _difficultyText(widget.route.difficulty),
                      style: TextStyle(
                        fontSize: 12,
                        color: _difficultyColor(widget.route.difficulty),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '● En progreso',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _InfoChip(icon: Icons.straighten, label: '${widget.route.distanceKm} km'),
              const SizedBox(width: 8),
              _InfoChip(icon: Icons.access_time, label: '${widget.route.durationMinutes} min'),
              const SizedBox(width: 8),
              _InfoChip(
                icon: Icons.eco,
                label: '${widget.route.co2SavedKg} kg CO₂',
                color: const Color(0xFF4CAF50),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (ActiveRouteService().isActive(widget.route.id)) {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RouteActiveScreen(route: widget.route),
                    ),
                  );
                } else {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RouteDetailScreen(route: widget.route),
                    ),
                  );
                }
                if (mounted) setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isActive
                    ? const Color(0xFF4CAF50)
                    : AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isActive) ...[
                    const Icon(Icons.directions_bike, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    isActive ? 'En progreso' : 'Iniciar Ruta',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _difficultyText(RouteDifficulty difficulty) {
    switch (difficulty) {
      case RouteDifficulty.easy:   return 'Fácil';
      case RouteDifficulty.medium: return 'Media';
      case RouteDifficulty.hard:   return 'Difícil';
    }
  }

  Color _difficultyColor(RouteDifficulty difficulty) {
    switch (difficulty) {
      case RouteDifficulty.easy:   return const Color(0xFF4CAF50);
      case RouteDifficulty.medium: return const Color(0xFFFFA726);
      case RouteDifficulty.hard:   return const Color(0xFFF44336);
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? AppColors.lightText).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color ?? AppColors.lightText),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color ?? AppColors.lightText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
