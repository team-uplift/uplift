/// recipient_appbar.dart
///
/// A custom app bar component for recipient screens that provides:
/// - Profile picture display
/// - Navigation controls
/// - Action buttons
/// - Status indicators
///
/// Used in recipient-specific screens to maintain consistent
/// navigation and user interface elements.

import 'package:flutter/material.dart';
import 'package:uplift/constants/constants.dart';

/// appbar for recipient profile
class RecipientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final bool isVerified;
  final VoidCallback? onVerifyPressed;
  final bool useGradient; // used to dislay blue green gradient vs solid green

  const RecipientAppBar({
    super.key,
    required this.title,
    this.isVerified = false,
    this.onVerifyPressed,
    this.useGradient = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      centerTitle: true,
      elevation: 0,
      backgroundColor: useGradient ? null : AppColors.baseGreen,
      flexibleSpace: useGradient
          ? Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.baseGreen, AppColors.baseBlue],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            )
          : null,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: isVerified
              ? Row(
                  children: const [
                    Icon(Icons.verified, color: AppColors.warmWhite, size: 20),
                    SizedBox(width: 4),
                    Text(
                      'Verified',
                      style: TextStyle(
                        color: AppColors.warmWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : TextButton(
                  onPressed: onVerifyPressed,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.warmWhite,
                    backgroundColor: AppColors.baseRed,
                    textStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  child: const Text(
                    'Unverified',
                    style: TextStyle(color: AppColors.warmWhite),
                  ),
                ),
        ),
      ],
    );
  }
}
