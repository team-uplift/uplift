import 'package:flutter/material.dart';
import 'package:uplift/components/drawer_widget.dart';

class RecipientHistory extends StatefulWidget {
  const RecipientHistory({super.key});

  @override
  State<RecipientHistory> createState() => _RecipientHistoryState();
}

class _RecipientHistoryState extends State<RecipientHistory> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Text('HISTORY PAGE'),
        ],
      ),
    );
  }
}