/// verify_card.dart
///
/// A card component used for verification purposes, displaying:
/// - Verification status
/// - Required verification information
/// - Action buttons for verification process
///
/// Used in verification screens to guide users through the verification process
/// with clear visual feedback and actions.

import 'package:flutter/material.dart';
import 'package:uplift/constants/constants.dart';

class VerifyCard extends StatelessWidget {
  final String title;
  final bool isVerified;
  final VoidCallback? onVerifyPressed;

  const VerifyCard({
    super.key,
    required this.title,
    required this.isVerified,
    this.onVerifyPressed,
  });

  @override
  Widget build(BuildContext context) {
    // change border color if unverified to make it more pronounced
    final borderColor = isVerified ? AppColors.baseBlue : AppColors.baseRed;
    final elevation = isVerified ? 5.0 : 8.0;
    final cardColor = isVerified ? AppColors.warmWhite : Colors.red[100];

    return SizedBox(
      width: double.infinity,
      child: Card(
        // match the styling/margins of your other cards
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        elevation: elevation,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: borderColor, width: 4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  // show checkmark if verified else button
                  if (isVerified) ...[
                    const Icon(Icons.verified,
                        color: AppColors.baseGreen, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Verified',
                      style: TextStyle(
                        color: AppColors.baseGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ] else if (onVerifyPressed != null) ...[
                    ElevatedButton.icon(
                      onPressed: onVerifyPressed,
                      icon: const Icon(Icons.camera_alt, size: 18),
                      label: const Text('Verify Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.baseRed,
                        foregroundColor: AppColors.warmWhite,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        textStyle: const TextStyle(fontSize: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              // warning that user not allowed to receive donations
              if (!isVerified) ...[
                const SizedBox(height: 12),
                Text(
                  'You are not eligible to receive donations until you verify.',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
