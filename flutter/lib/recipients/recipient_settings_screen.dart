import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;


class RecipientSettingsScreen extends StatefulWidget {
  final VoidCallback? editProfile;
  // final VoidCallback? logout;
  // final VoidCallback? deleteAccount;
  final VoidCallback? changeEmail;
  final VoidCallback? convertAccount;
  final Map<String, dynamic> profile;

  const RecipientSettingsScreen({
    super.key,
    this.editProfile,
    // this.logout,
    // this.deleteAccount,
    this.changeEmail,
    this.convertAccount,
    required this.profile,
  });

  @override
  State<RecipientSettingsScreen> createState() => _RecipientSettingsScreenState();
}

class _RecipientSettingsScreenState extends State<RecipientSettingsScreen> {
  bool canEdit = false;
  Duration timeRemaining = Duration.zero;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  // PROFILE EDIT LOGIC WITH CLOCK
  void _startCooldown() {
    // TODO chatgpt clock logic
    final tagsLastGenerated = DateTime.parse(
      widget.profile['recipientData']['tagsLastGenerated'],
    );

    print("lasttime: $tagsLastGenerated");

    final editTime = tagsLastGenerated.add(const Duration(hours: 24));
    final currentTime = DateTime.now();

    if (currentTime.isAfter(editTime)) {
      setState(() {
        canEdit = true;
        timeRemaining = Duration.zero;
      });
      return;
    }

    setState(() {
      canEdit = false;
      timeRemaining = editTime.difference(currentTime);
    });

    // Update timer every second
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = editTime.difference(DateTime.now());
      if (remaining.isNegative || remaining.inSeconds <= 0) {
        timer.cancel();
        setState(() {
          canEdit = true;
          timeRemaining = Duration.zero;
        });
      } else {
        setState(() {
          timeRemaining = remaining;
        });
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return "${hours.toString().padLeft(2, '0')}h "
           "${minutes.toString().padLeft(2, '0')}m "
           "${seconds.toString().padLeft(2, '0')}s";
  }

  
  void _goToEditProfile() {}


  // UPDATING EMAIL LOGIC --> chatgpt
  void _showEmailUpdateDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Email"),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'New Email',
              hintText: 'you@example.com',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final newEmail = emailController.text.trim();
                

                try {
                  // 1. Update email in Cognito
                  await Amplify.Auth.updateUserAttribute(
                    userAttributeKey: CognitoUserAttributeKey.email,
                    value: newEmail,
                  );

                  // 2. Fetch Cognito ID to identify the user in your DB
                  final attributes = await Amplify.Auth.fetchUserAttributes();
                  final attrMap = {
                    for (final attr in attributes) attr.userAttributeKey.key: attr.value,
                  };
                  final cognitoId = attrMap['sub'];

                  // 3. Update the email in your backend
                  final response = await http.put(
                    Uri.parse('http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift/users/$cognitoId'),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({
                      'email': newEmail,
                    }),
                  );

                  if (!mounted) return;

                  Navigator.pop(context); // Close dialog

                  if (response.statusCode == 200 || response.statusCode == 204) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Email updated in backend')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('⚠️ Backend update failed: ${response.statusCode}')),
                    );
                  }

                  // 4. Optionally ask for confirmation code
                  _showEmailConfirmationDialog(context);

                } on AuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('❌ Cognito error: ${e.message}')),
                  );
                } catch (e) {
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('❌ Unexpected error: $e')),
                  );
                }

              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void _showEmailConfirmationDialog(BuildContext context) {
    final codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Verify Email"),
        content: TextField(
          controller: codeController,
          decoration: const InputDecoration(
            labelText: 'Confirmation Code',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              
              try {
                await Amplify.Auth.confirmUserAttribute(
                  userAttributeKey: CognitoUserAttributeKey.email,
                  confirmationCode: codeController.text.trim(),
                );

                if (!mounted) return;
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Email verified!")),
                );
              } on AuthException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Verification failed: ${e.message}")),
                );
              }
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }




  // DELETING ACCOUNT LOGIC
  Future<void> _deleteAccount() async {
    final userId = widget.profile['id'];
    print("userid: $userId");

    try {
      final response = await http.delete(
        Uri.parse('http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift/users/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      print("get donation response: ${response.body}");

      if (response.statusCode == 400) {
        print("delete unsuccessful");
      } else {
        await Amplify.Auth.deleteUser();
      }
    } catch (e) {
      print('error with delete request: $e');
    }
  }

  
  
   



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Edit Profile"),
              subtitle: !canEdit
                  ? Text(
                      "Available in ${_formatDuration(timeRemaining)}",
                      style: const TextStyle(color: Colors.grey),
                    )
                  : null,
              onTap: canEdit ? _goToEditProfile : null,
              enabled: canEdit,
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Change Email"),
              subtitle: const Text("Update your associated email address"),
              onTap: () => _showEmailUpdateDialog(context),
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              subtitle: const Text("Log out of your account"),
              onTap: () async {
                try {
                  await Amplify.Auth.signOut(
                    options: const SignOutOptions(globalSignOut: true),
                  );
                  
                  // Clear GoRouter navigation history and force redirect to Authenticator root
                  if (context.mounted) {
                    context.go('/redirect');
                  }
                } on AuthException catch (e) {
                  print("Sign out error: ${e.message}");
                }
              },
            ),
            const Divider(),


            ListTile(
              leading: const Icon(Icons.redo, color: Colors.orange,),
              title: const Text("Convert Account", style: TextStyle(color: Colors.orange)),
              subtitle: const Text("Convert account from recipient to donor"),
              onTap: widget.convertAccount ?? () {
                // Show a confirmation dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Are you sure?"),
                    content: const Text("This will convert your account from recipient to donor. You will no longer have access to your profile information."),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                      ElevatedButton(
                        onPressed: () {
                          // TODO implement account deletion and route to home
                          Navigator.pop(context);
                          print("Account converted");
                          context.goNamed('/login');
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: Text("Convert Account"),
                      ),
                    ],
                  ),
                );
              }
            ),
            const Divider(),

            // TODO section below GPT generated
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text("Delete Account", style: TextStyle(color: Colors.red)),
              subtitle: const Text("Permanently remove your account"),
              onTap: () => {
                // Show a confirmation dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Are you sure?"),
                    content: const Text("This will permanently delete your account."),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                      ElevatedButton(
                        onPressed: () {
                          // TODO implement account deletion and route to home
                          _deleteAccount();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: Text("Delete"),
                      ),
                    ],
                  ),
                )
              }
            )
          ],
        )
      )
    );
  }
}

// TODO add conversion button from donor to recipient