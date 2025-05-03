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
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/api/recipient_api.dart';
import 'package:uplift/components/donor_visible_info_card.dart';
import 'package:uplift/components/question_carousel.dart';
import 'package:uplift/components/recipient_tag_section.dart';
import 'package:uplift/components/verify_card.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/tag_model.dart';
import 'package:uplift/models/user_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:uplift/constants/constants.dart';
import 'package:uplift/services/income_verification_service.dart';

class RecipientProfileScreen extends StatefulWidget {
  final User profile;
  final Recipient recipient;
  final VoidCallback onVerifyPressed;

  const RecipientProfileScreen(
      {super.key,
      required this.profile,
      required this.recipient,
      required this.onVerifyPressed});

  @override
  State<RecipientProfileScreen> createState() => _RecipientProfileScreenState();
}

class _RecipientProfileScreenState extends State<RecipientProfileScreen> {
  late Recipient _recipient;
  final api = RecipientApi();
  final _verificationService = IncomeVerificationService(RecipientApi());

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
        backgroundColor: AppColors.warmWhite,
        title: const Text('Important Information'),
        content: const Text(
            'Submitting false income information is fraud. We only accept official IRS 1040 tax documents for verification.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.baseRed,
              foregroundColor: AppColors.warmWhite,
            ),
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

    final success = await api.uploadIncomeVerificationImage(
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
    profileData["name"] = fullName;

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
    profileData["address"] = address;

    profileData["email"] = widget.profile.email;
    profileData["aboutMe"] = widget.recipient.lastAboutMe ?? 'Not provided';
    profileData["whyINeedHelp"] =
        widget.recipient.lastReasonForHelp ?? 'Not provided';

    return profileData;
  }

  // will be useful if we plan on moving basicinfocard back to this screen
  // Map<String, String> _buildNameAddressData() {
  //   final Map<String, String> basicInfoData = {};

  //   final fullName =
  //       "${widget.recipient.firstName ?? ''} ${widget.recipient.lastName ?? ''}"
  //           .trim();
  //   basicInfoData["fullName"] = fullName;

  //   final addressLine1 = widget.recipient.streetAddress1 ?? '';
  //   final addressLine2 = widget.recipient.streetAddress2;
  //   final city = widget.recipient.city ?? '';
  //   final state = widget.recipient.state ?? '';
  //   final zip = widget.recipient.zipCode ?? '';
  //   final address = [
  //     addressLine1,
  //     if (addressLine2 != null && addressLine2.toString().isNotEmpty)
  //       addressLine2,
  //     "$city, $state ${zip.isNotEmpty ? zip : ''}"
  //   ].join('\n');
  //   basicInfoData["address"] = address;

  //   basicInfoData["email"] = widget.profile.email;

  //   return basicInfoData;
  // }

  @override
  Widget build(BuildContext context) {
    final isVerified = widget.recipient.incomeLastVerified != null;
    final profileData = _buildProfileData();
    final List<Tag> tags = widget.recipient.tags!
      ..sort((a, b) => b.weight.compareTo(a.weight));
    final qas = widget.recipient.formQuestions!
        .map((q) => QuestionAnswer(
              question: q['question']!,
              answer: q['answer']!,
            ))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.baseYellow,
      body: SafeArea(
        child: ListView(
            // padding: const EdgeInsets.all(10),
            children: [
              if (!isVerified)
                VerifyCard(
                    title: "Income Verification",
                    isVerified: isVerified,
                    onVerifyPressed: widget.onVerifyPressed),
              const SizedBox(height: 10),
              ProfileTagsSection(tags: tags),
              const SizedBox(height: 10),
              VisibleInfoCard(
                aboutMe: profileData["aboutMe"],
                reasonForNeed: profileData["whyINeedHelp"],
              ),
              QuestionCarousel(items: qas)
            ]),
      ),
    );
  }
}
