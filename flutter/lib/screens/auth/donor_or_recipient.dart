/// donor_or_recipient.dart
///
/// A screen that allows new users to choose their role in the app:
/// - Donor registration flow
/// - Recipient registration flow
/// - User type storage
///
/// This screen serves as the initial role selection point after
/// authentication, directing users to the appropriate registration
/// process based on their selection.
///
/// Key features:
/// - Role selection buttons
/// - Donor data storage
/// - Navigation to registration flows
/// - Error handling for API calls
///
/// includes:
/// - _storeDonor
///

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:uplift/api/cognito_helper.dart';
import 'package:uplift/components/standard_button.dart';
import 'package:uplift/constants/constants.dart';

// ignore: unused_element
bool _isLoading = false;

class DonorOrRecipient extends StatefulWidget {
  const DonorOrRecipient({super.key});

  @override
  State<DonorOrRecipient> createState() => _DonorOrRecipientState();
}

class _DonorOrRecipientState extends State<DonorOrRecipient> {
  /// stores a donor when a donor is created
  Future<void> storeDonor() async {
    setState(() {
      _isLoading = true;
    });
    // map to easier to parse dict
    final attrMap = await getCognitoAttributes();

    final payload = {
      'cognitoId': attrMap?['sub'],
      'email': attrMap?['email'],
      'recipient': false,
    };

    http.Response? storeUserResponse;

    // store user
    try {
      storeUserResponse = await http.post(
        Uri.parse(
            'http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift/users'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );
      debugPrint('Got response with code: ${storeUserResponse.statusCode}');
    } on TimeoutException catch (e) {
      debugPrint('Request timed out: $e');
    } on SocketException catch (e) {
      debugPrint('Socket exception: $e');
    } catch (e) {
      debugPrint('Other exception: $e');
    }

    if (storeUserResponse?.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SizedBox(
          height: 40,
          child: FittedBox(
              fit: BoxFit.contain,
              child: Image.asset('assets/uplift_black.png')),
        ),
        backgroundColor: AppColors.baseGreen,
      ),
      backgroundColor: AppColors.baseYellow,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            color: AppColors.warmWhite,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Register As A...",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  StandardButton(
                    title: 'Donor',
                    onPressed: () {
                      storeDonor();
                      context.goNamed('/home');
                    },
                  ),
                  const SizedBox(height: 10),
                  StandardButton(
                    title: 'RECIPIENT',
                    onPressed: () => context.goNamed('/recipient_registration'),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
