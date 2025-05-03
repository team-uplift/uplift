import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/constants/constants.dart';

void logout(dynamic context) async {
  try {
    await Amplify.Auth.signOut(
      options: const SignOutOptions(globalSignOut: true),
    );

    // Clear GoRouter navigation history and force redirect to Authenticator root
    if (context.mounted) {
      context.go('/redirect');
    }
  } on AuthException catch (e) {
    debugPrint("Sign out error: ${e.message}");
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.baseGreen,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.baseGreen,
              ),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 100,
                    maxHeight: 100,
                  ),
                  child: Image.asset(
                    "assets/uplift_black.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                context.goNamed('/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle_rounded),
              title: const Text("Profile"),
              onTap: () {
                context.goNamed('/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () {
                context.goNamed('/dashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                logout(context);
                context.goNamed('/redirect');
              },
            )
          ],
        ),
      ),
    );
  }
}
