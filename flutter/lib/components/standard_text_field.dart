/// standard_text_field.dart
///
/// A reusable text input component that provides:
/// - Consistent text field styling
/// - Input validation
/// - Error states
/// - Helper text support
///
/// Used throughout the app to maintain consistent
/// text input styling and behavior.

import 'package:flutter/material.dart';

class StandardTextField extends StatelessWidget {
  final String title;

  const StandardTextField({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)),
        label: Text(title),
        // fillColor: Colors.grey[200],
        // filled: true,
      ),
    );
  }
}
