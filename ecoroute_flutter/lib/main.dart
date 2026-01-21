import 'package:flutter/material.dart';
import 'ui/login_screen.dart';

void main() {
  runApp(const EcoRouteApp());
}

class EcoRouteApp extends StatelessWidget {
  const EcoRouteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoRoute',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
    );
  }
}
