import 'package:flutter/material.dart';

class RecipientSettings extends StatefulWidget {
  const RecipientSettings({super.key});

  @override
  State<RecipientSettings> createState() => _RecipientSettingsState();
}

class _RecipientSettingsState extends State<RecipientSettings> {
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