import 'package:flutter/material.dart';
import 'package:uplift/models/tag_model.dart';
import 'package:uplift/components/recipient_profile_display.dart';



class RecipientProfileScreen extends StatelessWidget {
  
  final Map<String, String> profileData = {
    "Name": "John Doe",
    "Email": "johndoe@example.com",
    "About Me": "I’m a developer who loves open-source projects.",
    "Why I Need Help": "Raising funds for continuing my education.",
    "Verification": "Unverified",
  };

  final List<Tag> tags = [
    const Tag(name: "basketball", weight: 0.0),
    const Tag(name: "chess", weight: 1.0),
    const Tag(name: "tennis", weight: 0.5),
    const Tag(name: "tech", weight: .92),
    const Tag(name: "gaming", weight: .75),
    const Tag(name: "education", weight: .63),
    const Tag(name: "music", weight: .47),
    const Tag(name: "art", weight: .33),
    const Tag(name: "mental health", weight: .18),
    const Tag(name: "food", weight: .05),
  ];

  RecipientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    tags.sort((a,b) => a.weight.compareTo(b.weight));

    return Scaffold(
      appBar: AppBar(title: const Text('Recipient Profile')),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(16),
        child: RecipientProfileDisplay(
          profileFields: profileData, 
          tags: tags, 
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

