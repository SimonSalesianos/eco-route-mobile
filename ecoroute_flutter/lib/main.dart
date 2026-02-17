import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/interfaces/user_repository.dart';
import 'core/interfaces/stats_repository.dart';
import 'core/interfaces/routes_repository.dart';
import 'core/interfaces/challengues_repository.dart';
import 'core/interfaces/chat_repository.dart';

import 'core/services/user_service.dart';
import 'core/services/stats_service.dart';
import 'core/services/routes_service.dart';
import 'core/services/challenges_service.dart';
import 'core/services/chat_service.dart';

import 'features/bloc/home_bloc.dart';
import 'features/bloc/bloc/routes_bloc.dart';
import 'features/bloc/challenges_bloc.dart';
import 'features/bloc/chat_bloc.dart';

import 'features/ui/screens/login_screen.dart';
import 'features/ui/screens/signup_screen.dart';
import 'features/ui/screens/home_screen.dart';

void main() {
  runApp(const EcoRouteApp());
}

class EcoRouteApp extends StatelessWidget {
  const EcoRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (_) => UserService(),
        ),
        RepositoryProvider<StatsRepository>(
          create: (_) => StatsService(),
        ),
        RepositoryProvider<RoutesRepository>(
          create: (_) => RoutesService(),
        ),
        RepositoryProvider<ChallengesRepository>(
          create: (_) => ChallengesService(),
        ),
        RepositoryProvider<ChatRepository>(
          create: (_) => ChatService(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
            create: (ctx) => HomeBloc(
              ctx.read<UserRepository>(),
              ctx.read<StatsRepository>(),
            ),
          ),
          BlocProvider<RoutesBloc>(
            create: (ctx) => RoutesBloc(
              ctx.read<RoutesRepository>(),
            ),
          ),
          BlocProvider<ChallengesBloc>(
            create: (ctx) => ChallengesBloc(
              ctx.read<ChallengesRepository>(),
            ),
          ),
          BlocProvider<ChatBloc>(
            create: (ctx) => ChatBloc(
              ctx.read<ChatRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'EcoRoute',
          theme: ThemeData(
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: Colors.white,
          ),
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/home': (context) => const HomeScreen(),
          },
        ),
      ),
    );
  }
}
