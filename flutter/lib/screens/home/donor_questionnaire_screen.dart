import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DonorQuestionnaire extends StatefulWidget {
  const DonorQuestionnaire({super.key});

  @override
  State<DonorQuestionnaire> createState() => _DonorQuestionnaireState();
}

// /uplift/recipients/matching

class _DonorQuestionnaireState extends State<DonorQuestionnaire> {
  int _currentQuestionIndex = 0;
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What motivates you to help others?',
      'icon': Icons.favorite_outline,
      'color': Colors.red,
      'options': [
        'Making a positive impact in someone\'s life',
        'Being part of a caring community',
        'Personal experience with hardship',
        'Religious or spiritual beliefs'
      ],
    },
    {
      'question': 'How often would you like to donate?',
      'icon': Icons.calendar_today_outlined,
      'color': Colors.blue,
      'options': ['One-time donation', 'Monthly', 'Quarterly', 'Annually'],
    },
    {
      'question': 'Which causes are you most passionate about?',
      'icon': Icons.volunteer_activism_outlined,
      'color': Colors.orange,
      'options': [
        'Food security',
        'Housing assistance',
        'Education support',
        'Healthcare access'
      ],
    },
  ];

  final List<String> _answers = [];

  final List<Map<String, dynamic>> questions_answers = [
    {
      'question': 'What motivates you to help others?',
      'answer': '',
    },
    {
      'question': 'How often would you like to donate?',
      'answer': '',
    },
    {
      'question': 'Which causes are you most passionate about?',
      'answer': '',
    },
    {
      'question': 'What is your preferred donation method?',
      'answer': '',
    },
    {
      'question': 'list of tags',
      'answer': '',
    },
  ];

  void _selectAnswer(String answer) {
    setState(() {
      _answers.add(answer);
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        context.pushNamed('/donor_tag', extra: questions_answers);
      }
    });
    questions_answers[_currentQuestionIndex]['answer'] = answer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Questionnaire',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _questions[_currentQuestionIndex]['question'],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Options
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Choose your answer",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...List.generate(
                          _questions[_currentQuestionIndex]['options'].length,
                          (index) {
                            final option = _questions[_currentQuestionIndex]
                                ['options'][index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  onTap: () => _selectAnswer(option),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: _questions[
                                                        _currentQuestionIndex]
                                                    ['color']
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            _questions[_currentQuestionIndex]
                                                ['icon'],
                                            color: _questions[
                                                _currentQuestionIndex]['color'],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            option,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Progress Bar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${(_answers.length / _questions.length * 100).round()}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: _answers.length / _questions.length,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(8),
                  minHeight: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
