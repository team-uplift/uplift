/// splash_redirect.dart
///
/// used to redirect user after Amplify authenticator. directs users
/// to appropriate homepage or registration
/// includes:
/// - _handleRedirect
///

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/api/cognito_helper.dart';
import 'package:uplift/api/user_api.dart';
import 'package:uplift/constants/constants.dart';
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

  Future<void> playQuickSplash(BuildContext context) async {
    final overlay = Overlay.of(context);
    final audioPlayer = AudioPlayer();
    final fadeController = AnimationController(
      vsync: Navigator.of(context), // still needs proper vsync (or separate widget)
      duration: const Duration(seconds: 2),
    );

    final fadeAnimation = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeInOut,
    );

    final scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(
        parent: fadeController,
        curve: Curves.easeOutBack, // gives a little bounce pop
      ),
    );

    final overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: Container(
            color: AppColors.baseYellow,
            child: Center(
              child: FadeTransition(
                opacity: fadeAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: Image.asset(
                    'assets/uplift_black.png',
                    width: 200,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(overlayEntry);

    await Future.delayed(const Duration(milliseconds: 50)); // let overlay mount

    try {
      await audioPlayer.play(AssetSource('audio/jingle.mp3'));
    } catch (e) {
      safePrint("Audio error: $e");
    }

    final completer = Completer<void>();
    fadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        completer.complete();
      }
    });

    fadeController.forward(); // Start animation

    await Future.wait([
      completer.future,
      audioPlayer.onPlayerComplete.first,
    ]);

    overlayEntry.remove();
    fadeController.dispose();
    await audioPlayer.dispose();

    await Future.delayed(const Duration(milliseconds: 200)); // let screen clean up
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
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!mounted) return;
            await playQuickSplash(context);
            if (!mounted) return;
            context.goNamed('/recipient_home', extra: user);
          });
        } else {
          log.info("route to donor dashboard");
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!mounted) return;
            await playQuickSplash(context);
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
