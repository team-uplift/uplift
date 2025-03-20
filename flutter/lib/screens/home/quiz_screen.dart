import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/components/quiz_module.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

List<Map<String, dynamic>> questions = [
  {
    'q': 'What is the capital of France?',
    'a': ['Paris', 'London', 'Berlin']
  },
  {
    'q': 'Which planet is known as the Red Planet?',
    'a': ['Earth', 'Mars', 'Jupiter']
  },
  {
    'q': 'How many continents are there on Earth?',
    'a': ['Five', 'Six', 'Seven']
  }
];

int questionNumber = 0;

class _QuizPageState extends State<QuizPage> {
  void updateQuestionNumber() {
    if (questionNumber < questions.length - 1) {
      setState(() {
        questionNumber++;
      });
    } else {
      context.goNamed('/recipient_list');
      setState(() {
        questionNumber = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: QuizModule(
          question: questions[questionNumber]['q'],
          choices: questions[questionNumber]['a'],
          onPress: updateQuestionNumber,
        ),
      ),
    );
  }
}
