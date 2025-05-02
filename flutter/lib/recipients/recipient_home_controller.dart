/// recipient_home_controller.dart
///
/// used to control all recipient dashboard. loads every page with top and
/// bottom nav bars and passes correct index for navbar
/// Includes:
/// - _loadScreens
/// - _loadProfile
/// - _onItemTapped
///
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/api/cognito_helper.dart';
import 'package:uplift/api/recipient_api.dart';
import 'package:uplift/components/bottom_nav_bar.dart';
import 'package:uplift/constants/constants.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/user_model.dart';
import 'package:uplift/services/income_verification_service.dart';
import 'package:uplift/utils/logger.dart';
import 'recipient_history_screen.dart';
import 'recipient_profile_screen.dart';
import 'recipient_settings_screen.dart';
import 'package:uplift/api/user_api.dart';

class RecipientHome extends StatefulWidget {
  const RecipientHome({super.key});

  @override
  State<RecipientHome> createState() => _RecipientHomeState();
}

class _RecipientHomeState extends State<RecipientHome> {
  int _selectedItem = 0;
  late User userProfile;
  late Recipient recipientProfile;
  bool _isLoading = true;
  late final List<Widget> _screens;
  final _verificationService = IncomeVerificationService(RecipientApi());

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  /// initializes all screens necessary for recipient dashboard
  void _loadScreens() {
    _screens = [
      RecipientProfileScreen(profile: userProfile, recipient: recipientProfile, onVerifyPressed: _handleVerifyTap,),
      RecipientHistoryScreen(profile: userProfile, recipient: recipientProfile),
      RecipientSettingsScreen(
          profile: userProfile, recipient: recipientProfile, onVerifyPressed: _handleVerifyTap),
    ];
  }

  /// fetches the user via api call using cognitoid
  Future<void> _loadProfile() async {
    final attrMap = await getCognitoAttributes();
    final cognitoId = attrMap?['sub'];
    final api = UserApi();

    final user = await api.fetchUserById(cognitoId!);

    if (user != null) {
      setState(() {
        userProfile = user;
        recipientProfile = user.recipientData!;
        _isLoading = false;
        _loadScreens();
      });
    } else {
      log.severe("Profile not found with cognito id");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  Future<void> _handleVerifyTap() async {
    final success = await _verificationService.verifyIncome(
      context: context,
      recipientId: recipientProfile.id,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
          Text(success ? 'Verification Successful' : 'Verification Failed'),
      ),
    );
    if (success) context.goNamed('/redirect');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 40,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Image.asset('assets/uplift_black.png'),
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.baseGreen,
      ),
      body: Stack(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
          AnimatedOpacity(
            opacity: _isLoading ? 0 : 1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: _isLoading
                ? const SizedBox()  // Don't show anything when loading
                : _screens[_selectedItem],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedItem: _selectedItem,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

