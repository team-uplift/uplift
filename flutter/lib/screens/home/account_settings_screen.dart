import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/constants.dart';
import 'package:uplift/api/user_api.dart';
import 'package:uplift/models/user_model.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

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
                // gradient: LinearGradient(
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                //   colors: [
                //     Theme.of(context).primaryColor,
                //     Theme.of(context).primaryColor.withOpacity(0.8),
                //   ],
                // ),
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
                  _buildSettingCard(
                    "Change Password",
                    "Update your account password",
                    Icons.lock_outline,
                    () {
                      // TODO: Implement password change
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSettingCard(
                    "Email Preferences",
                    "Manage your email notifications",
                    Icons.email_outlined,
                    () {
                      // TODO: Implement email preferences
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSettingCard(
                    "Two-Factor Authentication",
                    "Add an extra layer of security",
                    Icons.security_outlined,
                    () {
                      // TODO: Implement 2FA
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSettingCard(
                    "Delete Account",
                    "Permanently delete your account",
                    Icons.delete_outline,
                    _handleDeleteAccount,
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard(
    String title,
    String description,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDestructive
                      ? Colors.red.withOpacity(0.1)
                      : Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: isDestructive
                      ? Colors.red
                      : Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDestructive ? Colors.red : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
