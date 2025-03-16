import 'package:flutter/material.dart';

class QuizModule extends StatelessWidget {
  final String question;
  final List<String> choices;
  const QuizModule({
    super.key,
    required this.question,
    required this.choices
    });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(question),
        ...choices.map((choice) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: ElevatedButton(
              onPressed: () {}, // Add logic for button press
              child: Text(choice),
            ),
        ))
      ],
    );
  }
}
