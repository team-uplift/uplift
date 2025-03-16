import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/constants/constants.dart';

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
              child: Image.network(
                  "https://image.similarpng.com/file/similarpng/original-picture/2021/05/Modern-logo-design-template-on-transparent-PNG.png"),
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
                context.goNamed('/login');
              },
            )
          ],
        ),
      ),
    );
  }
}
