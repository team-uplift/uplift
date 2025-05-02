import 'package:flutter/material.dart';
import 'package:uplift/constants/constants.dart';

/// A card displaying the donor-visible profile information:
/// "About Me" and "Why I Need Help" sections.
class VisibleInfoCard extends StatelessWidget {
  final String? aboutMe;
  final String? reasonForNeed;

  const VisibleInfoCard({
    super.key,
    this.aboutMe,
    this.reasonForNeed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      elevation: 5,
      color: AppColors.warmWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.lavender, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.visibility, size: 18, color: AppColors.baseBlue),
                const SizedBox(width: 6),
                Text(
                  'Donors can see this information',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.baseBlue),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // About Me section
            Text(
              'About Me',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              aboutMe!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            // Reason for Need section
            Text(
              'Why I Need Help',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              reasonForNeed!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
