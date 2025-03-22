import 'package:flutter/material.dart';


// TODO more boilerplate chatgpt for starting point

class AboutMe extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AboutMe({
    required this.formData,
    required this.onNext,
    required this.onBack,
    Key? key,
  }) : super(key: key);

  @override
  _AboutMeState createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  late TextEditingController _aboutMe;

  @override
  void initState() {
    super.initState();
    _aboutMe = TextEditingController(text: widget.formData["aboutMe"]);
  }

  void _saveAndContinue() {
    widget.formData["aboutMe"] = _aboutMe.text.trim();
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Tell us about yourself"),
        const SizedBox(height: 16),
        TextField(
          controller: _aboutMe,
          maxLines: 6,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Write a few sentences about who you are...",
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