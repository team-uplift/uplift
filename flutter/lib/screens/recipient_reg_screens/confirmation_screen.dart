import 'package:flutter/material.dart';
import 'package:uplift/components/tag_card.dart';
import 'registration_questions.dart';
import 'package:uplift/models/tag_model.dart';

class Confirmation extends StatelessWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onBack;
  final VoidCallback onGenerate;
  final void Function(String questionKey) onJumpToQuestion;

  const Confirmation({
    required this.formData,
    required this.onBack,
    required this.onGenerate,
    required this.onJumpToQuestion,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: registrationQuestions
                    .where((q) =>
                        q['type'] != 'confirmation' &&
                        formData.containsKey(q['key']))
                    .map((q) {
                  dynamic answer = formData[q['key']];
                  if (answer is List) {
                    answer = answer.join(", ");
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => onJumpToQuestion(q['key']),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      q['q'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.edit, size: 18, color: Colors.grey),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                answer.toString().isNotEmpty ? answer.toString() : "Not provided",
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                "Tap to edit",
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(thickness: 1),
                    ],
                  );
                }).toList(),
              ),
            ),

            /// 👇 Confirmation dialog now added here
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              // color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Generate Tags?"),
                          content: const Text(
                              "Are you sure you want to generate tags? You will not be able to edit your profile or regenerate tags for 24 hours."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // Close dialog
                                onGenerate(); // Proceed to tag generation
                              },
                              child: const Text("Yes, Generate Tags"),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Generate Tags"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
