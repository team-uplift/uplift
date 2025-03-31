import 'package:flutter/material.dart';

class WhatChallenges extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const WhatChallenges({
    required this.formData,
    required this.onNext,
    required this.onBack,
    Key? key,
  }) : super(key: key);

  @override
  _WhatChallengesState createState() => _WhatChallengesState();
}

class _WhatChallengesState extends State<WhatChallenges> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.formData["mostDifficultThing"]);
  }

  void _saveAndContinue() {
    widget.formData["mostDifficultThing"] = _controller.text.trim();
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What is the most difficult thing you face day to day?"),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Describe the biggest challenge in your daily life...",
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(onPressed: widget.onBack, child: const Text("Back")),
                ElevatedButton(onPressed: _saveAndContinue, child: const Text("Next")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}