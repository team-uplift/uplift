import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/constants.dart';
import 'package:uplift/api/user_api.dart';
import 'package:uplift/models/user_model.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../../components/settings_card.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  Future<User?> _getCurrentUser() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final attrMap = {
        for (final attr in attributes) attr.userAttributeKey.key: attr.value,
      };
      final cognitoId = attrMap['sub'];

      if (cognitoId == null) {
        throw Exception('Failed to get user authentication information');
      }

      return await UserApi.fetchUserById(cognitoId);
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  Future<void> _handleDeleteAccount() async {
    final user = await _getCurrentUser();
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to get user information')),
        );
      }
      return;
    }

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Delete Account"),
          content: const Text(
            "Are you sure you want to delete your account? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await UserApi.deleteAccount(user);
                  if (mounted) {
                    context.goNamed('/redirect');
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting account: $e')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Delete"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Settings"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
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
                    "Account Settings",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Manage your account preferences and security",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Settings Options
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SettingsCard(
                    title: "Change Password",
                    description: "Update your account password",
                    icon: Icons.lock_outline,
                    onTap: () {
                      context.pushNamed('/change_password');
                    },
                  ),
                  // const SizedBox(height: 16),
                  // SettingsCard(
                  //   title: "Email Preferences",
                  //   description: "Manage your email notifications",
                  //   icon: Icons.email_outlined,
                  //   onTap: () {
                  //   },
                  // ),
                  // const SizedBox(height: 16),
                  // SettingsCard(
                  //   title: "Two-Factor Authentication",
                  //   description: "Add an extra layer of security",
                  //   icon: Icons.security_outlined,
                  //   onTap: () {
                  //   },
                  // ),

                  const SizedBox(height: 16),

                  SettingsCard(
                    title: "Delete Account",
                    description: "Permanently delete your account",
                    icon: Icons.delete_outline,
                    onTap: _handleDeleteAccount,
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
