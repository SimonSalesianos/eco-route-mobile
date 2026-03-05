import 'package:flutter/material.dart';
import 'package:flutter_application_tmdb_proyecto/features/ui/screens/active_challenge_service.dart';
import '../../../core/models/challenge.dart';
import '../theme/app_colors.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final Challenge challenge;

  const ChallengeDetailScreen({super.key, required this.challenge});

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  late bool _joined;

  @override
  void initState() {
    super.initState();
    _joined = ActiveChallengeService().isJoined(widget.challenge.id);
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.challenge;
    final isCompleted = ActiveChallengeService().isCompleted(c.id);

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
          'Detalle del Reto',
          style: TextStyle(color: AppColors.darkText, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _difficultyColor(c.difficulty).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.emoji_events,
                  color: _difficultyColor(c.difficulty),
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Título
            Center(
              child: Text(
                c.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),

            // Descripción
            Center(
              child: Text(
                c.description,
                style: const TextStyle(fontSize: 14, color: AppColors.lightText),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Dificultad + días
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _difficultyColor(c.difficulty).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _difficultyText(c.difficulty),
                    style: TextStyle(
                      color: _difficultyColor(c.difficulty),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.access_time, size: 16, color: AppColors.lightText),
                const SizedBox(width: 4),
                Text(
                  '${c.remainingDays} días restantes',
                  style: const TextStyle(fontSize: 13, color: AppColors.lightText),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Stats
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _DetailStat(
                    icon: Icons.people,
                    label: 'Participantes objetivo',
                    value: '${c.progressTotal}',
                  ),
                  const Divider(height: 24),
                  _DetailStat(
                    icon: Icons.star,
                    label: 'Puntos de recompensa',
                    value: '${c.rewardPoints} pts',
                    color: const Color(0xFFFFA726),
                  ),
                  const Divider(height: 24),
                  _DetailStat(
                    icon: Icons.eco,
                    label: 'Progreso actual',
                    value: '${c.progressCurrent}/${c.progressTotal}',
                    color: const Color(0xFF4CAF50),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Estado completado
            if (isCompleted)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
                    SizedBox(width: 8),
                    Text(
                      '¡Reto completado!',
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            else if (_joined)
              // Botón completar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ActiveChallengeService().complete(c.id, c.rewardPoints); // ✅
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('¡Reto completado! +${c.rewardPoints} puntos'),
                        backgroundColor: const Color(0xFF4CAF50),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Marcar como completado',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else
              // Botón unirse
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ActiveChallengeService().join(c.id);
                    setState(() => _joined = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Te has unido al reto!'),
                        backgroundColor: AppColors.primary,
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
                    'Unirse al reto',
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

  String _difficultyText(ChallengeDifficulty d) {
    switch (d) {
      case ChallengeDifficulty.easy:   return 'Fácil';
      case ChallengeDifficulty.medium: return 'Media';
      case ChallengeDifficulty.hard:   return 'Difícil';
    }
  }

  Color _difficultyColor(ChallengeDifficulty d) {
    switch (d) {
      case ChallengeDifficulty.easy:   return const Color(0xFF4CAF50);
      case ChallengeDifficulty.medium: return const Color(0xFFFFA726);
      case ChallengeDifficulty.hard:   return const Color(0xFFF44336);
    }
  }
}

class _DetailStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _DetailStat({
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
        Text(
          label,
          style: const TextStyle(color: AppColors.lightText, fontSize: 14),
        ),
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
