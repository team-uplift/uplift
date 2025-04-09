import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:uplift/components/standard_button.dart';
import 'package:uplift/constants/constants.dart';

bool _isLoading = false;

class DonorOrRecipient extends StatefulWidget {
  const DonorOrRecipient({super.key});

  @override
  State<DonorOrRecipient> createState() => _DonorOrRecipientState();
}

class _DonorOrRecipientState extends State<DonorOrRecipient> {
  Future<void> storeDonor() async {
    setState(() {
      _isLoading = true;
    });
    // get amplify user info
    final attributes = await Amplify.Auth.fetchUserAttributes();

    // map to easier to parse dict
    final attrMap = {
      for (final attr in attributes) attr.userAttributeKey.key: attr.value,
    };

    final payload = {
      'cognitoId': attrMap['sub'],
      'email': attrMap['email'],
      'recipient': false,
    };

    debugPrint('Payload being sent: ${jsonEncode(payload)}');

    http.Response? storeUserResponse;

    // store user
    try {
      storeUserResponse = await http.post(
        Uri.parse(
            'http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift/users'),
        headers: {
          'Content-Type': 'application/json',
          // 'Accept': 'application/json',
        },
        // build this out
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
      backgroundColor: AppColors.baseYellow,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Register As A...",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
                const SizedBox(
                  height: 20,
                ),
                StandardButton(
                    title: 'DONOR',
                    onPressed: () {
                      storeDonor();
                      context.goNamed('/home');
                    }),
                const SizedBox(
                  height: 10,
                ),
                StandardButton(
                  title: 'RECIPIENT',
                  onPressed: () => context.goNamed('/recipient_registration'),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
