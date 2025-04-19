import 'package:flutter/material.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/tag_model.dart';
import 'package:uplift/components/recipient_profile_display.dart';
import 'package:uplift/models/user_model.dart';


// TODO pull profile info from backend
class RecipientProfileScreen extends StatelessWidget {
  final User profile;
  final Recipient recipient;
  
// TODO fibbing is bad --> camera upload

  RecipientProfileScreen({super.key, required this.profile, required this.recipient});
  

  @override
  Widget build(BuildContext context) {

    print("raw profile: $profile");

    // final recipientData = profile['recipientData'] ?? {};

    final Map<String, String> profileData = {
      // "Name": profile['nickname'] ?? 'Unknown',
      "Email": profile.email,
      "About Me": recipient.lastAboutMe ?? 'Not provided',
      "Why I Need Help": recipient.lastReasonForHelp ?? 'Not provided',
    };

    print("profile data: ${profileData}");

    for (final q in recipient.formQuestions!) {
      final question = q['question'];
      final answer = q['answer'];
      profileData[question] = answer;
    }

    final List<Tag> tags = recipient.tags!;


    tags.sort((a,b) => a.weight.compareTo(b.weight));

    return Scaffold(
      appBar: AppBar(title: const Text('Recipient Profile')),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(16),
        child: RecipientProfileDisplay(
          profileFields: profileData, 
          tags: tags,
          // profileFields: profileData, 
          onVerifyPressed: () {
            print("flow for camers");
          }, 
        ),
      ),
      
    );
  }
  // const RecipientProfileScreen({super.key});

  // @override
  // State<RecipientProfileScreen> createState() => _RecipientProfileScreenState();
}


// TODO add editing funcitonality
// TODO make camera button functional for user to take photo of documents
// TODO maybe use just the camera roll and not allow photos to be taken?

