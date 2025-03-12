import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/components/standard_button.dart';
import 'package:uplift/components/standard_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ListView(
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
            StandardButton(title: 'LOG IN', onPressed: () => context.goNamed('/home'),),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () => context.pushNamed('/registration'),
              child: const Text('Register for an account'),
            ),
          ],
        ),
      ),
    );
  }
}
