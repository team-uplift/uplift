/// splash_redirect.dart
///
/// used to redirect user after Amplify authenticator. directs users
/// to appropriate homepage or registration
/// includes:
/// - _handleRedirect
///

import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/api/cognito_helper.dart';
import 'package:uplift/api/user_api.dart';
import 'package:uplift/utils/logger.dart';

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

  /// fetches user from backend then uses that info to route to appropriate screen
  Future<void> _handleRedirect() async {
    try {
      // Get current user attributes
      final attrMap = await getCognitoAttributes();
      final cognitoId = attrMap?['sub'];

      // Check if user exists in backend
      final user = await UserApi.fetchUserById(cognitoId);

      // Redirect
      if (user == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          context
              .goNamed('/donor_or_recipient'); // triggers re-registration flow
        });
      } else {
        if (user.recipient == true) {
          log.info("route to recipient dashboard");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.goNamed('/recipient_home', extra: user);
          });
        } else {
          log.info("route to donor dashboard");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.goNamed('/home', extra: user);
          });
        }
      }
    } catch (e) {
      log.severe("Error during redirect: $e");
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
