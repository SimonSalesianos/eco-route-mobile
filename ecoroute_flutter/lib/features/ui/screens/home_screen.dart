import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _MenuCardData(
        title: 'Explorar Rutas',
        subtitle: 'Descubre rutas ecológicas',
        icon: Icons.map_outlined,
        color: const Color(0xFF00C853),
      ),
      _MenuCardData(
        title: 'Nueva Ruta',
        subtitle: 'Crea tu propia ruta',
        icon: Icons.near_me_outlined,
        color: const Color(0xFF2979FF),
      ),
      _MenuCardData(
        title: 'Estadísticas',
        subtitle: 'Tu impacto ambiental',
        icon: Icons.bar_chart_rounded,
        color: const Color(0xFF00BFA5),
      ),
      _MenuCardData(
        title: 'Comunidad',
        subtitle: 'Conecta con otros',
        icon: Icons.groups_outlined,
        color: const Color(0xFF00BCD4),
      ),
      _MenuCardData(
        title: 'Logros',
        subtitle: 'Tus recompensas',
        icon: Icons.emoji_events_outlined,
        color: const Color(0xFFFFA000),
      ),
      _MenuCardData(
        title: 'Configuración',
        subtitle: 'Ajusta tu perfil',
        icon: Icons.settings_outlined,
        color: const Color(0xFF607D8B),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Menú Principal',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.98,
                ),
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return _MenuCard(card: card);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCardData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  _MenuCardData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class _MenuCard extends StatelessWidget {
  final _MenuCardData card;

  const _MenuCard({required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: card.color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              card.icon,
              color: card.color,
              size: 24,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            card.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            card.subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.lightText,
            ),
          ),
        ],
      ),
    );
  }
}
