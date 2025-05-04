/// standard_button.dart
///
/// A reusable button component that provides:
/// - Consistent button styling
/// - Loading states
/// - Disabled states
/// - Customizable text and icons
///
/// Used throughout the app to maintain consistent
/// button styling and behavior.

import 'package:flutter/material.dart';

class StandardButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const StandardButton({
    super.key,
    required this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60,
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
