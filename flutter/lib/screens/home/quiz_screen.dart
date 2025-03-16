import 'package:flutter/material.dart';
import 'package:uplift/components/quiz_module.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: QuizModule(question: 'This is question1', choices: [
            "answer 1",
            "answer 2",
            "answer 3",
          ])),
    );
  }
}
