import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/api/cognito_helper.dart';
import 'package:uplift/api/user_api.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/user_model.dart';
import 'package:uplift/screens/recipient_reg_screens/registration_questions.dart';

class RecipientSettingsScreen extends StatefulWidget {
  final VoidCallback? editProfile;
  final VoidCallback? changeEmail;
  final VoidCallback? convertAccount;
  final User profile;
  final Recipient recipient;

  const RecipientSettingsScreen({
    super.key,
    this.editProfile,
    this.changeEmail,
    this.convertAccount,
    required this.profile,
    required this.recipient,
  });

  @override
  State<RecipientSettingsScreen> createState() =>
      _RecipientSettingsScreenState();
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

  Map<String, dynamic> rebuildFormDataFromRecipient(
      User profile, Recipient recipient) {
    final formData = <String, dynamic>{};

    // Basic profile fields
    formData['userId'] = profile.id;
    formData['firstName'] = recipient.firstName;
    formData['lastName'] = recipient.lastName;
    formData['streetAddress1'] = recipient.streetAddress1;
    formData['streetAddress2'] = recipient.streetAddress2;
    formData['city'] = recipient.city;
    formData['state'] = recipient.state;
    formData['zipCode'] = recipient.zipCode?.toString() ?? '';
    formData['lastAboutMe'] = recipient.lastAboutMe;
    formData['lastReasonForHelp'] = recipient.lastReasonForHelp;

    // Custom form questions
    if (recipient.formQuestions != null) {
      for (final q in recipient.formQuestions!) {
        final match = registrationQuestions.firstWhere(
          (rq) => rq['q'] == q['question'],
          orElse: () => {},
        );

        final key = match['key'];
        final type = match['type'];

        if (key != null && key is String) {
          if (type == 'checkbox') {
            formData[key] = (q['answer'] as String)
                .split(', ')
                .map((s) => s.trim())
                .toList();
          } else {
            formData[key] = q['answer'];
          }
        } else {
          debugPrint("⚠️ No matching key for question '${q['question']}'");
        }
      }
    }

    return formData;
  }

  // PROFILE EDIT LOGIC WITH CLOCK
  void _startCooldown() {
    // TODO chatgpt clock logic
    final tagsLastGenerated = widget.recipient.tagsLastGenerated;

    print("lasttime: $tagsLastGenerated");

    final editTime = tagsLastGenerated?.add(const Duration(seconds: 24));
    final currentTime = DateTime.now();

    if (currentTime.isAfter(editTime!)) {
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

  void _goToEditProfile() {
    final formData =
        rebuildFormDataFromRecipient(widget.profile, widget.recipient);
    print("formdata from settings: $formData");
    print("userid type: ${widget.profile.id} ${widget.profile.id.runtimeType}");
    context.goNamed(
      '/recipient_registration',
      extra: {
        'profile': widget.profile,
        'formData': formData,
        'isEditing': true,
      },
    );
  }

  Future<void> updateUserEmail({
    required BuildContext context,
    required String newEmail,
    required VoidCallback onSuccess,
  }) async {
    try {
      // 1. Update in Cognito
      await Amplify.Auth.updateUserAttribute(
        userAttributeKey: CognitoUserAttributeKey.email,
        value: newEmail,
      );

      // 2. Update in Backend
      final attrMap = await getCognitoAttributes();
      final cognitoId = attrMap?['sub'];

      final success = await UserApi.updateEmail(
        userId: widget.profile.id!,
        attrMap: attrMap!,
      );

      Navigator.pop(context);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Email updated in backend')),
        );
        onSuccess(); // e.g. show confirmation prompt
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('⚠️ Backend update failed.')),
        );
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Cognito error: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Unexpected error: $e')),
      );
    }
  }

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
                updateUserEmail(
                    context: context,
                    newEmail: newEmail,
                    onSuccess: () {
                      _showEmailConfirmationDialog(context);
                    });
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
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
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
                    context.goNamed('/redirect');
                  }
                } on AuthException catch (e) {
                  print("Sign out error: ${e.message}");
                }
              },
            ),
            const Divider(),

            ListTile(
                leading: const Icon(
                  Icons.redo,
                  color: Colors.orange,
                ),
                title: const Text("Convert Account",
                    style: TextStyle(color: Colors.orange)),
                subtitle: const Text("Convert account from recipient to donor"),
                onTap: widget.convertAccount ??
                    () {
                      // Show a confirmation dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Are you sure?"),
                          content: const Text(
                              "This will convert your account from recipient to donor. You will no longer have access to your profile information."),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel")),
                            ElevatedButton(
                              onPressed: () {
                                UserApi.convertToDonor(widget.profile);
                                Navigator.pop(context);
                                context.goNamed('/redirect');
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: Text("Convert Account"),
                            ),
                          ],
                        ),
                      );
                    }),
            const Divider(),

            // TODO section below GPT generated
            ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text("Delete Account",
                    style: TextStyle(color: Colors.red)),
                subtitle: const Text("Permanently remove your account"),
                onTap: () => {
                      // Show a confirmation dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Are you sure?"),
                          content: const Text(
                              "This will permanently delete your account."),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel")),
                            ElevatedButton(
                              onPressed: () {
                                UserApi.deleteAccount(widget.profile);
                                context.goNamed('/redirect');
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: Text("Delete"),
                            ),
                          ],
                        ),
                      )
                    })
          ],
        )));
  }
}
