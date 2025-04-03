import 'package:flutter/material.dart';
import 'package:uplift/models/tag_model.dart';
import 'package:uplift/components/tag_card.dart';


class RecipientTagsScreen extends StatefulWidget {
  const RecipientTagsScreen({super.key});

  @override
  _RecipientTagsScreenState createState() => _RecipientTagsScreenState();
}

class _RecipientTagsScreenState extends State<RecipientTagsScreen>{


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


  // void _sortTagsByWeight() {
  //   setState(() {
  //     tags.sort((a, b) => a.weight.compareTo(b.weight));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Profile Tags')),
      body: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: tags.map((tag) => TagCard(tag: tag)).toList(),
      )
    );
  }
}

