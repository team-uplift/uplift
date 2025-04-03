import 'package:flutter/material.dart';
import 'package:uplift/components/tag_card.dart';
import 'registration_questions.dart';
import 'package:uplift/models/tag_model.dart';

class Confirmation extends StatelessWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const Confirmation({
    required this.formData,
    required this.onBack,
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Review Your Details"),
            const SizedBox(height: 24),

            // Dynamically list all responses from `registrationQuestions`
            ...registrationQuestions.where((q) => formData.containsKey(q['key']) && q['type'] != 'confirmation').map((q) {
              dynamic answer = formData[q['key']];
              if (answer is List) {
                answer = answer.join(", "); // Convert lists (e.g., checkboxes) to readable text
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q['q'], // Display question text
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      answer.toString().isNotEmpty ? answer.toString() : "Not provided",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }),

            if (formData.containsKey('tags') && (formData['tags'] as List).isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                "🏷️ Selected Tags:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (formData['tags'] as List<Tag>).map((tag) {
                  return TagCard(
                    tag: tag,
                    isSelected: false, // confirmation is display-only
                    // onTap omitted to make it non-interactive
                  );
                }).toList(),
              ),
            ],


            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: onBack,
                  child: const Text("Back"),
                ),
                ElevatedButton(
                  onPressed: onSubmit,
                  child: const Text("Submit"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}