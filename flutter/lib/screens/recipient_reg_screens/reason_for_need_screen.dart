import 'package:flutter/material.dart';

class ReasonForNeed extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const ReasonForNeed({
    required this.formData,
    required this.onNext,
    required this.onBack,
    super.key,
  });

  @override
  _ReasonForNeedState createState() => _ReasonForNeedState();
}

class _ReasonForNeedState extends State<ReasonForNeed> {
  late TextEditingController _reason;

  @override
  void initState() {
    super.initState();
    _reason = TextEditingController(text: widget.formData["reasonForNeed"]);
  }

  void _saveAndContinue() {
    widget.formData["reasonForNeed"] = _reason.text.trim();
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Why are you seeking support?"),
        const SizedBox(height: 16),
        TextField(
          controller: _reason,
          maxLines: 6,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Describe your situation and needs...",
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(onPressed: widget.onBack, child: const Text("Back")),
            ElevatedButton(onPressed: _saveAndContinue, child: const Text("Next")),
          ],
        )
      ],
    );
  }
}
