import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class RecipientSettingsScreen extends StatelessWidget {
  final VoidCallback? editProfile;
  final VoidCallback? logout;
  final VoidCallback? deleteAccount;
  final VoidCallback? changeEmail;

  const RecipientSettingsScreen({
    super.key,
    this.editProfile,
    this.logout,
    this.deleteAccount,
    this.changeEmail,
  });

  
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
              subtitle: const Text("Update your About Me and Reason for Need"),
              onTap: editProfile ?? () {
                // TODO flow to 2nd page of registration with filled out stuff
                print("Edit profile chosen");
              }
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Change Email"),
              subtitle: const Text("Update your associated email address"),
              onTap: changeEmail ?? () {
                // TODO allow user to change email here
                print("Change Email tapped");
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              subtitle: const Text("Log out of your account"),
              onTap: logout ?? () {
                // TODO implement logout here. for now route to login page
                context.goNamed('/login');
                print("Logout tapped");
              },
            ),
            const Divider(),

            // TODO section below GPT generated
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text("Delete Account", style: TextStyle(color: Colors.red)),
              subtitle: const Text("Permanently remove your account"),
              onTap: deleteAccount ?? () {
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
                          Navigator.pop(context);
                          print("Account deleted");
                          context.goNamed('/login');
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: Text("Delete"),
                      ),
                    ],
                  ),
                );
              }
            )
          ],
        )
      )
    );
  }
}