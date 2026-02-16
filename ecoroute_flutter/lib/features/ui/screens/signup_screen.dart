import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/password_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    color: AppColors.darkText,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Volver',
                    style: TextStyle(
                      color: AppColors.darkText,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.eco_outlined,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Crear Cuenta',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Únete a la comunidad EcoRoute',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.lightText,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Nombre completo',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const CustomTextField(
                label: 'Tu nombre',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              const Text(
                'Correo electrónico',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const CustomTextField(
                label: 'tu@email.com',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              const Text(
                'Contraseña',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const PasswordField(label: '********'),
              const SizedBox(height: 16),
              const Text(
                'Confirmar contraseña',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const PasswordField(label: '********'),
              const SizedBox(height: 28),
              CustomButton(
                text: 'Crear Cuenta',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
