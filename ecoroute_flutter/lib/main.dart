import 'package:flutter/material.dart';
import 'features/ui/screens/login_screen.dart';

void main() {
  runApp(const EcoRouteApp());
}

class EcoRouteApp extends StatelessWidget {
  const EcoRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),   
    );
  }
}
