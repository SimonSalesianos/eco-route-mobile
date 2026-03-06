import 'package:flutter/material.dart';
import 'package:flutter_application_tmdb_proyecto/features/ui/screens/active_challenge_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/active_route_service.dart';
import '../../bloc/home_bloc.dart';
import '../theme/app_colors.dart';
import '../widgets/stats_card.dart';
import '../widgets/home_menu_card.dart';
import 'routes_screen.dart';
import 'challenges_screen.dart';
import 'chat_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final localPoints      = ActiveChallengeService().totalPoints;
    final localCompleted   = ActiveChallengeService().totalCompleted;
    final localRoutes      = ActiveRouteService().completedRoutes;

    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoggedOut) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            TextButton.icon(
              onPressed: () {
                context.read<HomeBloc>().add(HomeLogoutRequested());
              },
              icon: const Icon(Icons.logout, color: Colors.red, size: 18),
              label: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is HomeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<HomeBloc>().add(HomeStarted()),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                );
              }

              if (state is HomeLoaded) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¡Hola, ${state.user.fullName}!',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Aquí está tu resumen de actividad',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.lightText,
                          ),
                        ),
                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: StatsCard(
                                icon: Icons.route,
                                value: (state.stats.totalRoutes + localRoutes).toString(),
                                label: 'Rutas\nCompletadas',
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: StatsCard(
                                icon: Icons.eco,
                                value: '${state.stats.totalCo2SavedKg.toStringAsFixed(0)} kg',
                                label: 'CO₂\nAhorrado',
                                color: const Color(0xFF4CAF50),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: StatsCard(
                                icon: Icons.emoji_events,
                                value: (state.stats.totalAchievements + localCompleted).toString(),
                                label: 'Logros\nObtenidos',
                                color: const Color(0xFFFFA726),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: StatsCard(
                                icon: Icons.star,
                                value: localPoints.toString(),
                                label: 'Puntos\nGanados',
                                color: const Color(0xFFFFA726),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        const Text(
                          'Menú Principal',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkText,
                          ),
                        ),
                        const SizedBox(height: 16),

                        HomeMenuCard(
                          icon: Icons.explore,
                          title: 'Explorar Rutas',
                          subtitle: 'Descubre nuevas rutas ecológicas',
                          color: AppColors.primary,
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RoutesScreen(),
                              ),
                            );
                            if (mounted) setState(() {}); 
                          },
                        ),
                        const SizedBox(height: 12),
                        HomeMenuCard(
                          icon: Icons.emoji_events_outlined,
                          title: 'Retos y Eventos',
                          subtitle: 'Participa en desafíos sostenibles',
                          color: const Color(0xFFFFA726),
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ChallengesScreen(),
                              ),
                            );
                            if (mounted) setState(() {}); 
                          },
                        ),
                        const SizedBox(height: 12),
                        HomeMenuCard(
                          icon: Icons.chat_bubble_outline,
                          title: 'Chat de Comunidad',
                          subtitle: 'Conecta con otros EcoWarriors',
                          color: const Color(0xFF42A5F5),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ChatScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
