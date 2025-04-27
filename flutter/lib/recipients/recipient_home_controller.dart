/// recipient_home_controller.dart
///
/// used to control all recipient dashboard. loads every page with top and
/// bottom nav bars and passes correct index for navbar
/// Includes:
/// - _loadScreens
/// - _loadProfile
/// - _onItemTapped
///

import 'package:flutter/material.dart';
import 'package:uplift/api/cognito_helper.dart';
import 'package:uplift/components/bottom_nav_bar.dart';
import 'package:uplift/constants/constants.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/user_model.dart';
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

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  /// initializes all screens necessary for recipient dashboard
  void _loadScreens() {
    _screens = [
      RecipientProfileScreen(profile: userProfile, recipient: recipientProfile),
      RecipientHistoryScreen(profile: userProfile, recipient: recipientProfile),
      RecipientSettingsScreen(
          profile: userProfile, recipient: recipientProfile),
    ];
  }

  /// fetches the user via api call using cognitoid
  Future<void> _loadProfile() async {
    final attrMap = await getCognitoAttributes();
    final cognitoId = attrMap?['sub'];
    final user = await UserApi.fetchUserById(cognitoId!);

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _screens[_selectedItem],
      bottomNavigationBar: BottomNavBar(
        selectedItem: _selectedItem,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

