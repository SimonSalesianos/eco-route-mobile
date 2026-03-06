import 'package:flutter/material.dart';
import 'package:flutter_application_tmdb_proyecto/features/ui/screens/active_challenge_service.dart';

import '../../../core/models/challenge.dart';
import '../screens/challenge_detail_screen.dart';
import '../theme/app_colors.dart';

class ChallengeCard extends StatefulWidget {
  final Challenge challenge;
  final VoidCallback? onReturn;

  const ChallengeCard({
    super.key,
    required this.challenge,
    this.onReturn,
  });

  @override
  State<ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard> {
  @override
  Widget build(BuildContext context) {
    final c = widget.challenge;
    final isJoined    = ActiveChallengeService().isJoined(c.id);
    final isCompleted = ActiveChallengeService().isCompleted(c.id);
    final progress    = c.progressCurrent / c.progressTotal;

    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChallengeDetailScreen(challenge: c),
          ),
        );
        widget.onReturn?.call(); 
        if (mounted) setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted
                ? const Color(0xFF4CAF50)
                : isJoined
                    ? AppColors.primary.withOpacity(0.4)
                    : Colors.grey.shade200,
          ),
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
                    color: _difficultyColor(c.difficulty).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    color: _difficultyColor(c.difficulty),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        c.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.lightText,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20)
                else if (isJoined)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Unido',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _difficultyColor(c.difficulty).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _difficultyText(c.difficulty),
                    style: TextStyle(
                      fontSize: 11,
                      color: _difficultyColor(c.difficulty),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.access_time, size: 14, color: AppColors.lightText),
                const SizedBox(width: 4),
                Text(
                  '${c.remainingDays} días restantes',
                  style: const TextStyle(fontSize: 12, color: AppColors.lightText),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progreso',
                  style: TextStyle(fontSize: 12, color: AppColors.lightText),
                ),
                Text(
                  '${c.progressCurrent}/${c.progressTotal}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.darkText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _difficultyColor(c.difficulty),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFFFA726), size: 16),
                const SizedBox(width: 4),
                Text(
                  '${c.rewardPoints} puntos',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFFFA726),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
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
