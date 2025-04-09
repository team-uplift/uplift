import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// TODO chatgpt thank you for this boilerplate to edit down
class SplashRedirector extends StatefulWidget {
  const SplashRedirector({super.key});

  @override
  State<SplashRedirector> createState() => _SplashRedirectorState();
}

class _SplashRedirectorState extends State<SplashRedirector> {
  @override
  void initState() {
    super.initState();
    _handleRedirect();
  }

  Future<void> _handleRedirect() async {
    try {
      // Get current user attributes
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final attrMap = {
        for (final attr in attributes) attr.userAttributeKey.key: attr.value,
      };

      final cognitoId = attrMap['sub'];
      

      print("Cognito ID: $cognitoId");

      // Check if user exists in backend
      final res = await http.get(
        Uri.parse('http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift/users/cognito/$cognitoId'),
        headers: {'Content-Type': 'application/json'},
      );


      // Redirect
      if (res.statusCode == 404) {
        print("route to registration");
        WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.goNamed('/donor_or_recipient');
        });
      } else if (res.statusCode == 200) {
        final user = jsonDecode(res.body);

        if (user['recipient'] == true) {
          print("route to recipient dashboard");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.goNamed('/recipient_home', extra: user);
          });

        } else {
          print("route to donor dashboard");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.goNamed('/home', extra: user);
          });
        }
      } else {
        print("Unexpected status: ${res.statusCode}");
        // context.goNamed('/error');
      }
    } catch (e) {
      print("Error during redirect: $e");
      await Amplify.Auth.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
