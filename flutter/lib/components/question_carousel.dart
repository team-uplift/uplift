/// question_carousel.dart
///
/// An interactive carousel component that displays:
/// - Multiple choice questions
/// - Question navigation controls
/// - Progress indicators
/// - Answer submission functionality
///
/// Used in onboarding and survey screens to present questions
/// in an engaging, swipeable format.
///
/// chatgpt generated

import 'package:flutter/material.dart';
import 'package:uplift/constants/constants.dart';

/// model for question/answer pairs
class QuestionAnswer {
  final String question;
  final String answer;

  QuestionAnswer({required this.question, required this.answer});
}

/// A carousel widget that allows users to swipe through a list of questions and answers.
class QuestionCarousel extends StatefulWidget {
  /// List of question/answer items to display
  final List<QuestionAnswer> items;

  /// Height of each card; defaults to 200
  final double cardHeight;

  const QuestionCarousel({
    super.key,
    required this.items,
    this.cardHeight = 200,
  });

  @override
  _QuestionCarouselState createState() => _QuestionCarouselState();
}

class _QuestionCarouselState extends State<QuestionCarousel> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.cardHeight,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final qa = widget.items[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 5,
              color: AppColors.warmWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: AppColors.baseBlue, width: 4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      qa.question,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          qa.answer,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
