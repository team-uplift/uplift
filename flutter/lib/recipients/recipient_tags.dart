import 'package:flutter/material.dart';
import 'package:uplift/components/drawer_widget.dart';

class RecipientTags extends StatefulWidget {
  const RecipientTags({super.key});

  @override
  State<RecipientTags> createState() => _RecipientTagsState();
}

class _RecipientTagsState extends State<RecipientTags> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Text('TAGS PAGE'),
        ],
      ),
    );
  }
}