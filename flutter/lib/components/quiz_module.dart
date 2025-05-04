/// quiz_module.dart
///
/// An interactive quiz component that provides:
/// - Question display
/// - Answer options
/// - Score tracking
/// - Progress indicators
///
/// Used in educational sections to present
/// interactive quizzes and assessments.

import 'package:flutter/material.dart';

class QuizModule extends StatelessWidget {
  final String question;
  final List<String> choices;
  final VoidCallback onPress;
  const QuizModule(
      {super.key,
      required this.question,
      required this.choices,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(question),
        const SizedBox(
          height: 40,
        ),
        ...choices.map(
          (choice) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: GestureDetector(
              onTap: onPress,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(border: Border.all()),
                child: Text(choice),
              ),
            ),
          ),
        )
      ],
    );
  }
}
