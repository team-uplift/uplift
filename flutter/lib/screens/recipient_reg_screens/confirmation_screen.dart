import 'package:flutter/material.dart';
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
    Key? key,
  }) : super(key: key);

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
            }).toList(),

            // 🏷️ Special Section for Selected Tags
            if (formData.containsKey('tags') && (formData['tags'] as List).isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                "🏷️ Selected Tags:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Wrap(
                spacing: 8,
                children: (formData['tags'] as List<Tag>).map((tag) {
                  return Chip(
                    label: Text(tag.name),
                    backgroundColor: Colors.blue.shade100,
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