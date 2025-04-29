/// recipient_profile_display.dart
///
/// Creates cards to display profile information. The individual cards are
/// generated from maps of string pairs and tag objects
///
library;

import 'package:flutter/material.dart';
import 'package:uplift/components/match_color_legend.dart';
import 'package:uplift/constants/constants.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/tag_model.dart';
import 'package:uplift/components/tag_card.dart';

class RecipientProfileDisplay extends StatelessWidget {
  final Map<String, String> profileFields;
  final List<Tag> tags;
  final VoidCallback? onVerifyPressed;
  final Recipient recipient;

  const RecipientProfileDisplay({
    super.key,
    required this.profileFields,
    required this.tags,
    required this.onVerifyPressed,
    required this.recipient,
  });

  @override
  Widget build(BuildContext context) {
    final entries = profileFields.entries.toList(); //all profile info here

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...entries.map((entry) {
          // set bool and val to allow for verification if not verified
          final isVerification = entry.key == "Income Verification";
          final isVerified = entry.value ==
              "✅ Verified";

          // cards for all profile iteams aside from tags
          return Card(
            color: AppColors.warmWhite,
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: AppColors.lavender,
                width: 1.5,
              )
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          entry.value,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // display camera icon and link if user not verified and verification is available
                  if (isVerification && !isVerified)
                  // TODO test this
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: onVerifyPressed,
                        icon: const Icon(Icons.camera_alt, size: 18),
                        label: const Text('Verify Now'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColors.warmWhite,
                          backgroundColor: AppColors.baseRed,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          textStyle: const TextStyle(fontSize: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 8),

        // card to hold all tag cards
        SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 5,
            color: AppColors.warmWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColors.lavender, width: 1.5)
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Tags",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  
                  const MatchColorLegend(),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 12,
                    runSpacing: 12,
                    children: tags.map((tag) => TagCard(tag: tag)).toList(),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
