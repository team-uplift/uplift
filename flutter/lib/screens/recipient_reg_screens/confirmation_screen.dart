/// confirmation_screen.dart
///
/// used to build a confirmation screen before tag generation is called
/// all fields on this screen are editable
/// include:
/// - _buildGroupedContent
///

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

  /// builds content to be grouped together on confirmation screen
  String _buildGroupedContent(Map<String, dynamic> formData) {
    final first = formData['firstName'] ?? '';
    final last = formData['lastName'] ?? '';
    final addr1 = formData['streetAddress1'] ?? '';
    final addr2 = formData['streetAddress2'] ?? '';
    final city = formData['city'] ?? '';
    final state = formData['state'] ?? '';
    final zip = formData['zipCode'] ?? '';

    return [
      "$first $last",
      addr1,
      if (addr2.toString().isNotEmpty) addr2,
      "$city, $state $zip",
    ].where((line) => line.trim().isNotEmpty).join('\n');
  }

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
                  // building address fields for card
                  ...groupedFields.entries.map((entry) {
                    final content = _buildGroupedContent(formData);
                    return buildConfirmationCard(
                      title: entry.key,
                      content: content,
                      onEdit: () => onJumpToQuestion("basicAddressInfo"),
                    );
                  }),

                  // all other registration question cards
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

                    return buildConfirmationCard(
                      title: q['q'],
                      content: answer?.toString() ?? '',
                      onEdit: () => onJumpToQuestion(q['key']),
                    );
                  }),
                ],
              ),
            ),

            // generate tags button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // warning that user will not be able to generate tags again for 24 hours
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

  // helper widget to reduce size of main method here and build out cards
  Widget buildConfirmationCard({
    required String title,
    required String content,
    required VoidCallback onEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 5,
        color: AppColors.lightBeige,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.baseGreen, width: 2)
        ),
        child: InkWell(
          onTap: onEdit,
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
  }
}
