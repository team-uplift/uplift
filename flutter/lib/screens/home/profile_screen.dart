import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/components/drawer_widget.dart';
import 'package:uplift/components/settings_card.dart';
import 'package:uplift/constants/constants.dart';
import 'package:uplift/screens/home/account_settings_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.baseBlue,
                
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Profile",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Manage your account settings and preferences",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Profile Information
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SettingsCard(
                    title: "Personal Information",
                    description: "Update your name, email, and contact details",
                    icon: Icons.person_outline,
                    onTap: ()=>context.pushNamed('/personal_info'),
                  ),
                  const SizedBox(height: 16),
                  SettingsCard(
                    title: "Account Settings",
                    description: "Manage your password and account preferences",
                    icon: Icons.settings_outlined,
                    onTap: ()=>context.pushNamed('/account_settings'),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
