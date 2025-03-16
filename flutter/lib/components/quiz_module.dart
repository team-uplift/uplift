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
        Container(
          child: Text(question),
        ),
        for choice in choices {

        }
      ],
    );
  }
}
