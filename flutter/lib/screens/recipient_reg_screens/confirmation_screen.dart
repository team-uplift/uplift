import 'package:flutter/material.dart';
import 'package:uplift/constants/constants.dart';
import 'registration_questions.dart';

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
    final groupedFields = {
      'Name & Address': [
        'firstName',
        'lastName',
        'streetAddress1',
        'streetAddress2',
        'city',
        'state',
        'zipCode',
      ],
    };

    final groupedKeys = groupedFields.values.expand((keys) => keys).toSet();

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [

                  // ✅ Render grouped fields
                  ...groupedFields.entries.map((entry) {
                    final title = entry.key;
                    final keys = entry.value;
                    final first = formData['firstName'] ?? '';
                    final last = formData['lastName'] ?? '';
                    final addr1 = formData['streetAddress1'] ?? '';
                    final addr2 = formData['streetAddress2'] ?? '';
                    final city = formData['city'] ?? '';
                    final state = formData['state'] ?? '';
                    final zip = formData['zipCode'] ?? '';

                    final content = [
                      "$first $last",
                      addr1,
                      if (addr2.toString().isNotEmpty) addr2,
                      "$city, $state $zip",
                    ].join('\n');

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        elevation: 5,
                        color: AppColors.lightBeige,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () => onJumpToQuestion("basicAddressInfo"),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.edit, size: 18, color: AppColors.baseBlue),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  content.isNotEmpty ? content : "Not provided",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Tap to edit",
                                  style: TextStyle(fontSize: 12, color: AppColors.baseBlue),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  // ✅ Then render all other questions
                  ...registrationQuestions
                      .where((q) =>
                          q['type'] != 'confirmation' &&
                          !groupedKeys.contains(q['key']) &&
                          formData.containsKey(q['key']))
                      .map((q) {
                    dynamic answer = formData[q['key']];
                    if (answer is List) {
                      answer = answer.join(", ");
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        elevation: 5,
                        color: AppColors.lightBeige,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () => onJumpToQuestion(q['key']),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
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
                                    const Icon(Icons.edit, size: 18, color: AppColors.baseBlue),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  answer.toString().isNotEmpty ? answer.toString() : "Not provided",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Tap to edit",
                                  style: TextStyle(fontSize: 12, color: AppColors.baseBlue),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            // ✅ Confirm & Generate Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: AppColors.warmWhite,
                          title: const Text("Generate Tags?"),
                          content: const Text(
                            "Are you sure you want to generate tags? You will not be able to edit your profile or regenerate tags for 24 hours.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.baseRed,
                                foregroundColor: AppColors.warmWhite,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                onGenerate();
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
            ),
          ],
        ),
      ),
    );
  }
}
