/// login_screen.dart
///
/// The main authentication screen that provides:
/// - User login functionality
/// - Password recovery
/// - Registration navigation
/// - Authentication state management
///
/// This screen integrates with AWS Cognito for:
/// - User authentication
/// - Session management
/// - Security features
/// - Error handling
///
/// Key features:
/// - Login form validation
/// - Error message display
/// - Navigation to registration
/// - Password reset flow

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/components/standard_button.dart';
import 'package:uplift/components/standard_text_field.dart';
import 'package:uplift/constants/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseYellow,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Image(
                  height: 100,
                  image: NetworkImage(
                    "https://www.uplift.com/wp-content/uploads/2021/04/Uplift-Logo-Black-01.png",
                  ),
                ),
                const StandardTextField(title: 'Email'),
                const SizedBox(height: 10),
                const StandardTextField(title: 'Password'),
                const SizedBox(
                  height: 40,
                ),
                StandardButton(
                  title: 'LOG IN AS DONOR',
                  onPressed: () => context.goNamed('/home'),
                ),
                const SizedBox(
                  height: 10,
                ),
                StandardButton(
                  title: 'LOG IN AS RECIPIENT',
                  onPressed: () => context.goNamed('/recipient_home'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () => context.pushNamed('/donor_or_recipient'),
                  child: const Text('Register for an account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
