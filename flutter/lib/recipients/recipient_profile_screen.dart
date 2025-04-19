import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/api/recipient_api.dart';
import 'package:uplift/components/address_block.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/tag_model.dart';
import 'package:uplift/components/recipient_profile_display.dart';
import 'package:uplift/models/user_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


// TODO pull profile info from backend
class RecipientProfileScreen extends StatefulWidget {
  final User profile;
  final Recipient recipient;

  const RecipientProfileScreen({super.key, required this.profile, required this.recipient});

  @override
  State<RecipientProfileScreen> createState() => _RecipientProfileScreenState();
}

class _RecipientProfileScreenState extends State<RecipientProfileScreen> {
  late Recipient _recipient;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _recipient = widget.recipient;
  }

  Future<void> _verifyIncome() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
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
  // final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (source != null) {
      final pickedFile = await ImagePicker().pickImage(source: source);
      
      if (pickedFile != null) {
        final success = await RecipientApi.uploadIncomeVerificationImage(
          widget.recipient.id.toString(),
          File(pickedFile.path),
        );

        if (success) {
          if (context.mounted) {
            Navigator.pop(context);
            context.goNamed('/recipient_home');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Verification failed")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final Map<String, String> profileData = {};

    final fullName = "${widget.recipient.firstName ?? ''} ${widget.recipient.lastName ?? ''}".trim();
    profileData["Name"] = fullName;

    final addressLine1 = widget.recipient.streetAddress1 ?? '';
    final addressLine2 = widget.recipient.streetAddress2;
    final city = widget.recipient.city ?? '';
    final state = widget.recipient.state ?? '';
    final zip = widget.recipient.zipCode ?? '';
    final address = [
      addressLine1,
      if (addressLine2 != null && addressLine2.toString().isNotEmpty) addressLine2,
      "$city, $state ${zip.isNotEmpty ? zip : ''}"
    ].join('\n');
    profileData["Address"] = address;

    // 3. Then whatever else you want to add
    profileData["Email"] = widget.profile.email;
    profileData["About Me"] = widget.recipient.lastAboutMe ?? 'Not provided';
    profileData["Why I Need Help"] = widget.recipient.lastReasonForHelp ?? 'Not provided';


    for (final q in widget.recipient.formQuestions!) {
      final question = q['question'];
      final answer = q['answer'];
      profileData[question] = answer;
    }

    if (widget.recipient.incomeLastVerified != null) {
      profileData["Income Verification"] = "✅ Verified \nLying about your income is fraud. No fibbing.";
    } else {
      profileData["Income Verification"] = "❌ Not Verified \nLying about your income is fraud. No fibbing.";
    }


    final List<Tag> tags = widget.recipient.tags!;


    tags.sort((a,b) => a.weight.compareTo(b.weight));

    return Scaffold(
      appBar: AppBar(title: const Text('Recipient Profile')),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(16),
        child: RecipientProfileDisplay(
          profileFields: profileData, 
          tags: tags,
          recipient: widget.recipient,
          // profileFields: profileData, 
          onVerifyPressed: () {
            _verifyIncome();
          }, 
        ),
      ),
      
    );
  }
}


// TODO add editing funcitonality
// TODO make camera button functional for user to take photo of documents
// TODO maybe use just the camera roll and not allow photos to be taken?

