import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/components/standard_button.dart';
import 'package:uplift/components/standard_text_field.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            children: [
              const StandardTextField(title: 'First Name'),
              const SizedBox(height: 10),
              const StandardTextField(title: 'Last Name'),
              const SizedBox(height: 10),
              const StandardTextField(title: 'Email'),
              const SizedBox(height: 10),
              const StandardTextField(title: 'Password'),
              const SizedBox(height: 10),
              const StandardTextField(title: 'Confirm Password'),
              const SizedBox(height: 40),
              const StandardButton(title: 'REGISTER'),
              const SizedBox(height: 20),
              TextButton(onPressed: ()=> context.go('/login'), child: const Text('Already have an account? Log in.'),),
            ],
          ),
        ),
      ),
    );
  }
}
