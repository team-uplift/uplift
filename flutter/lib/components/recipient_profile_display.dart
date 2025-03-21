import 'package:flutter/material.dart';
import 'package:uplift/models/tag_model.dart';
import 'package:uplift/components/tag_card.dart';

class RecipientProfileDisplay extends StatelessWidget {
  final Map<String, String> profileFields;
  final List<Tag> tags;
  final VoidCallback? onVerifyPressed;

  const RecipientProfileDisplay({
    super.key,
    required this.profileFields,
    required this.tags,
    required this.onVerifyPressed,
  });

  @override
  Widget build(BuildContext context) {
    final entries = profileFields.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...entries.map((entry) {
          final isVerification = entry.key == "Verification";
          final isVerified = entry.value == "✅ Verified";

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.value,
                          style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                        ),
                      ],
                    ),
                  ),
                  if (isVerification && !isVerified)
                    IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.red),
                      onPressed: onVerifyPressed ?? () {},
                    ),
                ],
              ),
              const Divider(thickness: 1),
            ],
          );
        }),


        // TODO sort out tagging colors, etc here
        const SizedBox(height: 16),
        const Text(
          "Your Tags",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: tags.map((tag) => TagCard(tag: tag)).toList(),
        ),
      ],
    );
  }
}

