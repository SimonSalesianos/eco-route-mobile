import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/challenges_bloc.dart';
import '../theme/app_colors.dart';
import '../widgets/challenge_card.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

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
          'Retos y Eventos',
          style: TextStyle(
            color: AppColors.darkText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<ChallengesBloc, ChallengesState>(
        builder: (context, state) {
          if (state is ChallengesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChallengesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ChallengesBloc>().add(ChallengesRequested());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is ChallengesLoaded) {
            // Calcular resumen
            final totalPoints = state.challenges.fold<int>(
              0,
              (sum, c) => sum + c.rewardPoints,
            );
            final completed = state.challenges
                .where((c) => c.progressCurrent >= c.progressTotal)
                .length;
            final active = state.challenges.length - completed;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Resumen en cards
                    Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            icon: Icons.star,
                            value: totalPoints.toString(),
                            label: 'Puntos Totales',
                            color: const Color(0xFFFFA726),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryCard(
                            icon: Icons.check_circle,
                            value: completed.toString(),
                            label: 'Completados',
                            color: const Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryCard(
                            icon: Icons.trending_up,
                            value: active.toString(),
                            label: 'Activos',
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Retos Activos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Lista de retos
                    state.challenges.isEmpty
                        ? const Center(
                            child: Text('No hay retos disponibles'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.challenges.length,
                            itemBuilder: (context, index) {
                              final challenge = state.challenges[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: ChallengeCard(challenge: challenge),
                              );
                            },
                          ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.lightText,
            ),
          ),
        ],
      ),
    );
  }
}
