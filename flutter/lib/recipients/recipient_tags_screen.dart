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
    const Tag(name: "basketball", weight: 0.0),
    const Tag(name: "chess", weight: 1.0),
    const Tag(name: "tennis", weight: 0.5),
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

