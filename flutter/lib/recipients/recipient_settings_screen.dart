import 'package:flutter/material.dart';

class RecipientSettingsScreen extends StatefulWidget {
  const RecipientSettingsScreen({super.key});

  @override
  State<RecipientSettingsScreen> createState() => _RecipientSettingsScreenState();
}

class _RecipientSettingsScreenState extends State<RecipientSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Text('SETTINGS PAGE'),
        ],
      ),
    );
  }
}