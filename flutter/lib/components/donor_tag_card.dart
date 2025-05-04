/// donor_tag_card.dart
///
/// A specialized card component that displays:
/// - Donor preference tags
/// - Tag matching status
/// - Tag importance indicators
/// - Tag management controls
///
/// Used in donor profiles to show and manage the tags
/// that represent donor preferences and matching criteria.

import 'package:flutter/material.dart';
import 'package:uplift/models/donor_tag_model.dart';

class DonorTagCard extends StatelessWidget {
  final DonorTag tag;
  final bool isSelected;

  const DonorTagCard({
    required this.tag,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green[100] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.green : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Center(
        child: Text(
          tag.tagName,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.green[900] : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
