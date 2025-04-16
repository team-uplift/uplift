import 'package:flutter/material.dart';
import 'package:uplift/models/tag_model.dart';
import 'package:uplift/components/recipient_profile_display.dart';


// TODO pull profile info from backend
class RecipientProfileScreen extends StatelessWidget {
  final Map<String, dynamic> profile;
  
  // final Map<String, String> profileData = {
  //   "Name": "John Doe",
  //   "Email": "johndoe@example.com",
  //   "About Me": "I’m a developer who loves open-source projects.",
  //   "Why I Need Help": "Raising funds for continuing my education.",
  //   // "Verification": "Unverified",
  // };

// final List<Tag> tags = [
//   Tag(
//     tagName: "basketball",
//     weight: 0.82,
//     createdAt: DateTime.parse("2025-04-01T10:15:00Z"),
//     addedAt: DateTime.parse("2025-04-01T10:15:00Z"),
//     selected: false,
//   ),
//   Tag(
//     tagName: "chess",
//     weight: 0.91,
//     createdAt: DateTime.parse("2025-04-01T11:20:00Z"),
//     addedAt: DateTime.parse("2025-04-01T11:20:00Z"),
//     selected: false,
//   ),
//   Tag(
//     tagName: "tech",
//     weight: 0.95,
//     createdAt: DateTime.parse("2025-04-01T12:30:00Z"),
//     addedAt: DateTime.parse("2025-04-01T12:30:00Z"),
//     selected: false,
//   ),
//   Tag(
//     tagName: "music",
//     weight: 0.76,
//     createdAt: DateTime.parse("2025-04-01T13:45:00Z"),
//     addedAt: DateTime.parse("2025-04-01T13:45:00Z"),
//     selected: false,
//   ),
//   Tag(
//     tagName: "education",
//     weight: 0.88,
//     createdAt: DateTime.parse("2025-04-01T14:50:00Z"),
//     addedAt: DateTime.parse("2025-04-01T14:50:00Z"),
//     selected: false,
//   ),
// ];

// TODO fibbing is bad --> camera upload

  RecipientProfileScreen({super.key, required this.profile});
  

  @override
  Widget build(BuildContext context) {

    print("raw profile: $profile");

    final recipientData = profile['recipientData'] ?? {};

    final Map<String, String> profileData = {
      // "Name": profile['nickname'] ?? 'Unknown',
      "Email": profile['email'] ?? 'Not provided',
      "About Me": recipientData['lastAboutMe'] ?? 'Not provided',
      "Why I Need Help": recipientData['lastReasonForHelp'] ?? 'Not provided',
    };

    print("profile data: ${profileData}");

    for (final q in recipientData['formQuestions']) {
      final question = q['question'] as String;
      final answer = q['answer'] as String;
      profileData[question] = answer;
    }

    print("raw tags: ${recipientData['tags']}");
    print("TAG RAW: ${recipientData['tags'].runtimeType}");
    print("TAG VALUE: ${recipientData['tags']}");

    final List<Tag> tags = (recipientData['tags'] as List)
        .map((tagJson) => Tag.fromJson(Map<String, dynamic>.from(tagJson)))
        .toList();




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

