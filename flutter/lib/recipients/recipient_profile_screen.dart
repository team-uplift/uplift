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

final List<Tag> tags = [
  Tag(
    tagName: "basketball",
    weight: 0.82,
    createdAt: DateTime.parse("2025-04-01T10:15:00Z"),
    addedAt: DateTime.parse("2025-04-01T10:15:00Z"),
    selected: false,
  ),
  Tag(
    tagName: "chess",
    weight: 0.91,
    createdAt: DateTime.parse("2025-04-01T11:20:00Z"),
    addedAt: DateTime.parse("2025-04-01T11:20:00Z"),
    selected: false,
  ),
  Tag(
    tagName: "tech",
    weight: 0.95,
    createdAt: DateTime.parse("2025-04-01T12:30:00Z"),
    addedAt: DateTime.parse("2025-04-01T12:30:00Z"),
    selected: false,
  ),
  Tag(
    tagName: "music",
    weight: 0.76,
    createdAt: DateTime.parse("2025-04-01T13:45:00Z"),
    addedAt: DateTime.parse("2025-04-01T13:45:00Z"),
    selected: false,
  ),
  Tag(
    tagName: "education",
    weight: 0.88,
    createdAt: DateTime.parse("2025-04-01T14:50:00Z"),
    addedAt: DateTime.parse("2025-04-01T14:50:00Z"),
    selected: false,
  ),
];


  RecipientProfileScreen({super.key, required this.profile});
  

  @override
  Widget build(BuildContext context) {

    final recipientData = profile['recipientData'];

    final Map<String, String> profileData = {
      // "Name": profile['nickname'] ?? 'Unknown',
      "Email": profile['recipientData']['email'] ?? 'Not provided',
      "About Me": profile['lastAboutMe'] ?? 'Not provided',
      "Why I Need Help": profile['lastReasonForHelp'] ?? 'Not provided',
    };

    final List<Map<String, dynamic>> formQuestions = 
      (recipientData['formQuestions'] as List)
        .map((q) => {
          'question': q['question'],
          'answer': q['answer'],
        })
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

