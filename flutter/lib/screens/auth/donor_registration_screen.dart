import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/components/standard_button.dart';
import 'package:uplift/components/standard_text_field.dart';
import 'package:uplift/constants/constants.dart';

class DonorRegistrationPage extends StatefulWidget {
  const DonorRegistrationPage({super.key});

  @override
  State<DonorRegistrationPage> createState() => _DonorRegistrationPageState();
}

class _DonorRegistrationPageState extends State<DonorRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseYellow,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Donor Registration",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                  StandardButton(title: 'REGISTER', onPressed: (){},),
                  const SizedBox(height: 20),
                  TextButton(onPressed: ()=> context.go('/login'), child: const Text('Already have an account? Log in.'),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
