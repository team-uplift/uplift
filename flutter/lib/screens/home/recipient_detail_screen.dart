import 'package:flutter/material.dart';

class RecipientDetailPage extends StatefulWidget {
  const RecipientDetailPage({super.key});

  @override
  State<RecipientDetailPage> createState() => _RecipientDetailPageState();
}

class _RecipientDetailPageState extends State<RecipientDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recipient Detail"),),
    );
  }
}