/// recipient_profile_screen.dart
///
/// formats data to be passed in recipient profile display object to generate
/// card for display. this is the screen called by the nav bar.
/// Includes:
/// - _showFraudWarning
/// - _pickImageSource
/// - _verifyIncome
/// - _buildProfileData
///

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/api/recipient_api.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/tag_model.dart';
import 'package:uplift/components/recipient_profile_display.dart';
import 'package:uplift/models/user_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:uplift/constants/constants.dart';

class RecipientProfileScreen extends StatefulWidget {
  final User profile;
  final Recipient recipient;

  const RecipientProfileScreen(
      {super.key, required this.profile, required this.recipient});

  @override
  State<RecipientProfileScreen> createState() => _RecipientProfileScreenState();
}

class _RecipientProfileScreenState extends State<RecipientProfileScreen> {
  late Recipient _recipient;

  @override
  void initState() {
    super.initState();
    _recipient = widget.recipient;
  }


  /// displays a fraud warning when a user goes to verify their income
  ///
  /// returns true if they continue to camera, false if they cancel
  Future<bool> _showFraudWarning() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Important Information'),
        content: const Text(
            'Submitting false income information is fraud. We only accept official IRS 1040 tax documents for verification.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text('Continue'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// allows user to pick image source to verify their income by taking a photo
  /// or using their camera roll
  Future<ImageSource?> _pickImageSource() async {
    return await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  /// allows user to upload photo to back end for income verification
  Future<void> _verifyIncome() async {
    final proceed = await _showFraudWarning(); // fraud warning pop up
    if (!proceed) return;

    final source = await _pickImageSource(); // camera pop up
    if (source == null) return;

    final pickedFile =
        await ImagePicker().pickImage(source: source); //image chosen by user
    if (pickedFile == null) return;

    final success = await RecipientApi.uploadIncomeVerificationImage(
      widget.recipient.id,
      File(pickedFile.path),
    );

    if (context.mounted) {
      if (success) {
        // if verified reload page
        context.goNamed('/redirect');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Verification Successful")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Verification failed")),
        );
      }
    }
  }

  /// formats data to be read by profile builder by making title/ value pairs
  ///
  /// returns a Map<String, String>
  Map<String, String> _buildProfileData() {
    final Map<String, String> profileData = {};

    final fullName =
        "${widget.recipient.firstName ?? ''} ${widget.recipient.lastName ?? ''}"
            .trim();
    profileData["Name"] = fullName;

    final addressLine1 = widget.recipient.streetAddress1 ?? '';
    final addressLine2 = widget.recipient.streetAddress2;
    final city = widget.recipient.city ?? '';
    final state = widget.recipient.state ?? '';
    final zip = widget.recipient.zipCode ?? '';
    final address = [
      addressLine1,
      if (addressLine2 != null && addressLine2.toString().isNotEmpty)
        addressLine2,
      "$city, $state ${zip.isNotEmpty ? zip : ''}"
    ].join('\n');
    profileData["Address"] = address;

    profileData["Email"] = widget.profile.email;
    profileData["About Me"] = widget.recipient.lastAboutMe ?? 'Not provided';
    profileData["Why I Need Help"] =
        widget.recipient.lastReasonForHelp ?? 'Not provided';

    for (final q in widget.recipient.formQuestions!) {
      final question = q['question'];
      final answer = q['answer'];
      profileData[question] = answer;
    }

    if (widget.recipient.incomeLastVerified != null) {
      profileData["Income Verification"] = "✅ Verified";
    } else {
      profileData["Income Verification"] = "❌ Not Verified";
    }

    return profileData;
  }

  @override
  Widget build(BuildContext context) {
    final profileData = _buildProfileData();
    final List<Tag> tags = widget.recipient.tags!
      ..sort((a, b) => b.weight.compareTo(a.weight));

    return Scaffold(
      backgroundColor: AppColors.baseYellow,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: RecipientProfileDisplay(
          profileFields: profileData,
          tags: tags,
          recipient: widget.recipient,
          onVerifyPressed: () {
            _verifyIncome();
          },
        ),
      ),
    );
  }
}
